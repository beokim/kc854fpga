-- Copyright (c) 2015, $ME
-- All rights reserved.
--
-- Redistribution and use in source and synthezised forms, with or without modification, are permitted 
-- provided that the following conditions are met:
--
-- 1. Redistributions of source code must retain the above copyright notice, this list of conditions 
--    and the following disclaimer.
--
-- 2. Redistributions in synthezised form must reproduce the above copyright notice, this list of conditions
--    and the following disclaimer in the documentation and/or other materials provided with the distribution.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED 
-- WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
-- PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR 
-- ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED 
-- TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
-- HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING 
-- NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
-- POSSIBILITY OF SUCH DAMAGE.
--
--
-- Speicher-Controller fuer KC85/4
--   fuer SRAM mit 256kx16
library IEEE;
use IEEE.std_logic_1164.all;

entity memcontrol is
    port (
        clk         : in  std_logic;
        reset_n     : in  std_logic;
        
        sramAddr    : out std_logic_vector(17 downto 0);
        sramDataOut : out std_logic_vector(15 downto 0);
        sramDataIn  : in  std_logic_vector(15 downto 0);
        sramOE_n    : out std_logic;
        sramCE_n    : out std_logic;
        sramWE_n    : out std_logic;
        sramLB_n    : out std_logic;
        sramUB_n    : out std_logic;
        
        cpuAddr     : in  std_logic_vector(15 downto 0);
        cpuDOut     : out std_logic_vector(7 downto 0);
        cpuDIn      : in  std_logic_vector(7 downto 0);
        
        cpuWR_n     : in  std_logic;
        cpuRD_n     : in  std_logic;
        cpuM1_n     : in  std_logic;
        cpuMREQ_n   : in  std_logic;
        cpuIORQ_n   : in  std_logic;
        
        cpuEn       : out std_logic;
        cpuWait     : out std_logic;
        
        cpuTick     : in  std_logic;

        pioPortA    : in  std_logic_vector(7 downto 0);
        pioPortB    : in  std_logic_vector(7 downto 0);  
                
        vidAddr     : in  std_logic_vector(13 downto 0);
        vidData     : out std_logic_vector(15 downto 0);
        vidRead     : out std_logic;
        vidBusy     : out std_logic;
        
        vidBlinkEn  : out std_logic;
        vidHires    : out std_logic;
        
        bootmode    : in  std_logic;
        
        switches    : out std_logic_vector(9 downto 0)
    );
end memcontrol;

architecture rtl of memcontrol is
    type   state_type is ( cpuCycle0, cpuCycle1, cpuCycle2,  cpuIdle0, cpuIdle1, cpuIdle2, vidSetAddr, vidReadMem );
    
    signal state      : state_type := cpuIdle0;

    signal cpuAddrInt : std_logic_vector(17 downto 0);

    signal vidAddrInt : std_logic_vector(17 downto 0);
    
    signal port84     : std_logic_vector(7 downto 0);
    signal port86     : std_logic_vector(7 downto 0);
    
    signal bankWe     : boolean;
    signal bankEn     : boolean;
    signal bankLByte  : std_logic;
    signal bankAddr   : std_logic_vector(3 downto 0);
    
    signal romData    : std_logic_vector(7 downto 0);
    
    signal selectVid  : boolean;
    
    signal cpuCycle   : boolean;
begin
    vidAddrInt <= "111" & port84(0) & vidAddr; -- Videoadresse: 1110 Bild0 -- 1111 Bild 1
    cpuAddrInt <= bankAddr  & cpuAddr(13 downto 0);
    
    -- CPU laufen lassen?
    cpuEn    <= '1' when state=vidReadMem and cpuCycle else '0';
    cpuWait  <= '1';
    
    vidRead <= '1' when state = vidReadMem else '0';
    vidBusy <= '1' when selectVid else '0';
    vidBlinkEn <= pioPortB(7);
    
--    waitState <= lastWr='1' and cpuWR_n='0' and cpuMREQ_n='0';

    sramAddr <= vidAddrInt when selectVid else cpuAddrInt;
    
    -- upper/lower byte fuer CPU-Writes
    sramDataOut(7 downto 0)  <= cpuDIn when bankLByte='1' else x"00";
    sramDataOut(15 downto 8) <= cpuDIn when bankLByte='0' else x"00";

    -- upper/lower byte fuer read-/writes -> cpu+video
    -- videozugriffe lesen immer 2 bytes: farbe+pixel
    sramLB_n <= '0' when selectVid else not bankLByte;
    sramUB_n <= '0' when selectVid else bankLByte;
    -- SRAM control    
    sramWE_n <= '0' when state=cpuCycle1 and cpuMREQ_n='0' and cpuWR_n='0' and (bankWe or bootmode='1') else '1';
    sramOE_n <= '1' when cpuWR_n='0' and cpuMREQ_n='0' and (state=cpuCycle0 or state=cpuCycle1 or state=cpuCycle2) else '0';
    sramCE_n <= '0';

    -- Bootrom einbinden
    bootrom : entity work.bootrom
    port map (
        clk => clk,
        addr => cpuAddr(13 downto 0),
        data => romData
    );
     
    -- Port 84/85 (port84)
    --  Bit 0: Bild - bild 0/1 anzeigen
    --  Bit 1: BLA0 - pixel (1)/color (0)
    --  Bit 2: BLA1 - bildschirm zugriff (0/1)
    --  Bit 3: FPIX - hires (0)
    --  Bit 4-7: RAF0-3 - ram bank @8000
    --
    -- Port 86/87 (port86)
    --  Bit 0: RAO4 - ram4 en (@4000)
    --  Bit 1: WER4 - ram4 we 
    --  Bit 5: ROF0 - Pin 27 romc (Bankswitching fuer 27256?)
    --  Bit 6: ROF1 - Pin 26 romc (Bankswitching fuer 27256?)
    --  Bit 7: ROCC - caos c en (@c000)
    
    -- PIO Port A (pioPortA) Port 88/8a
    --  Bit 0: ROE  - caos e  en (@e000)
    --  Bit 1: RAO0 - ram0 en (@0000) 
    --  Bit 2: IRO  - irm  en
    --  Bit 3: WER0 - ram0 we
    --  Bit 7: ROCB - romc (basic @c000) en
    
    -- PIO Port B (pioPortB) Port 89/8b
    --  Bit 5: RAO8 - ram8 en (@8000)
    --  Bit 6: WER8 - ram8 we
    --  Bit 7: blen_ - blink enable
--    bankswitching: process (cpuAddr, port84, port86, pioPortA, pioPortB)
    bankswitching: process
        variable ram0en : boolean;
        variable ram0we : boolean;
        variable ram4en : boolean;
        variable ram4we : boolean;
        variable ram8en : boolean;
        variable ram8we : boolean;
        variable ram8raf : std_logic_vector(3 downto 0);
        variable irmEn  : boolean;
        variable irmBLA : std_logic_vector(1 downto 0);
        variable romCaosC : boolean;
        variable romCaosE : boolean;
        variable romBasic : boolean;
    
    begin
        wait until rising_edge(clk);
        
        ram0en := pioPortA(1)='1'; -- RAM0
        ram0we := pioPortA(3)='1'; 
        ram4en := port86(0)='1';   -- RAM4
        ram4we := port86(1)='1'; 
        ram8en := pioPortB(5)='1'; -- RAM8
        ram8we := pioPortB(6)='1';
        irmEn  := pioPortA(2)='1'; 
        irmBLA := port84(2 downto 1);
        ram8raf := port84(7 downto 4);
        romCaosC := port86(7)='1';
        romCaosE := pioPortA(0)='1';
        romBasic := pioPortA(7)='1';
        
        -- romCaosE & romCaosC & romBasic 
        switches <= pioPortA(7 downto 1) & pioPortA(0) & port86(7) & pioPortA(7); 
        
        vidHires  <= not port84(3);
        
        bankLByte <= '1';
        bankWe    <= true;
        bankAddr  <= "00" & cpuAddr(15 downto 14);
        
        -- bankswitching fuer CPU
        case cpuAddr(15 downto 14) is
            when "00" => -- ram0
                bankWe <= ram0we;
                bankEn <= ram0en;
            when "01" => -- ram4
                bankWe <= ram4we;
                bankEn <= ram4en;
            when "10" => -- ram8 / irm
                if irmEn then
                    bankEn <= true;
                    if cpuAddr(15 downto 0) < x"a800" then -- irm
                        bankAddr <= "111" & irmBLA(1); -- bild 0/1 zugriff
                        bankLByte <= not irmBLA(0); -- pixel/color zugriff
                    else -- systemspeicher aktiv -> bank 0 pixel
                        bankAddr <= "1110";
                    end if;
                else -- ram8
                    bankWe <= ram8we;
                    bankEn <= ram8en;
                    bankLByte <= not ram8raf(0); -- bank 0 unteres byte / bank 1 oberes byte
                end if;
            when others => -- "11" -> roms
                bankWe <= false;
					 bankEn <= false;
                if (cpuAddr(13)='0') then -- caos c/basic
                    if romCaosC or romBasic then
                        bankEn <= true;
                    end if;
                    
                    if romBasic and not romCaosC then -- Basic / Caos C -> Caos C hat Vorrang
                        bankLByte <= '0'; -- Basic im oberen byte
                    end if;
                else -- caos e
                    bankEn <= romCaosE;
                end if;
        end case;
    end process;

    -- latches nachbauen
    memlatches : process
    begin
        wait until rising_edge(clk);
        
        if (reset_n='0') then
            port84 <= (others => '0');
            port86 <= (others => '0');
        else
            if (cpuIORQ_n='0' and cpuM1_n='1' and cpuWR_n='0') then
                case cpuAddr(7 downto 0) is
                    when x"84"|x"85" => 
                        port84 <= cpuDIn;
                    when x"86"|x"87" => 
                        port86 <= cpuDIn;
                    when others => 
                        null;
                end case;
            end if;
        end if;
    end process;
    
    -- SRAM -> CPU wenn cpuCycle1
    sram : process 
    begin
        wait until rising_edge(clk);
        -- daten fuer cpu lesen
        if state = cpuCycle1 and cpuMREQ_n='0' then
            if bootmode='1' and cpuAddr(15 downto 15)="0" then -- rom @0000 wenn bootmode
                cpuDOut <= romData;
            elsif bankEn then
                if bankLByte='1' then
                    cpuDOut <= sramDataIn(7 downto 0);
                else
                    cpuDOut <= sramDataIn(15 downto 8);
                end if;
            else
                cpuDOut <= "00000000";
            end if;
        end if;
        
        if state = vidSetAddr then
            vidData <= sramDataIn;
        end if;
    end process;
    
    -- Statemaschine zur Steuerung der 5 Zeitslots:
    --   0-2 CPU-idle
    --   3 Video-Adresse
    --   4 Video-Daten + CPU-Tick (wenn getriggert)
    -- oder bei CPU-Speicherzugriff 
    --   0 CPU-Adresse 
    --   1 CPU-read/write teil1 (WE an)
    --   2 CPU-write teil2  (WE aus)
    --   3 Video-Adresse
    --   4 Video-Daten + CPU-Tick  (wenn getriggert)
    ctlstate : process
    begin
        wait until rising_edge(clk); 
        
        if (reset_n='0') then
            cpuCycle <= false;
            state <= cpuCycle0;
            selectVid <= false;
        else
            if cpuTick='1' then
                cpuCycle <= true;
            end if;
          
            case state is
                when cpuIdle0 => state <= cpuIdle1; -- Idle
                when cpuIdle1 => state <= cpuIdle2;
                when cpuCycle0 => state <= cpuCycle1; -- CPU
                when cpuCycle1 => state <= cpuCycle2;
                when cpuCycle2 | cpuIdle2 => 
                    state <= vidSetAddr;
                    selectVid <= true;
                when vidSetAddr => state <= vidReadMem; -- Video-Adresse
                when vidReadMem => -- Video-Speicher lesen
                    cpuCycle <= false;
                    if cpuCycle then -- soll CPU laufen?
                        state <= cpuCycle0;
                    else
                        state <= cpuIdle0;
                    end if;
                    selectVid <= false;
            end case;
        end if;
    end process;
end;
