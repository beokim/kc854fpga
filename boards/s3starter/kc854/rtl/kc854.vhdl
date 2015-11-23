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
-- KC85/4 Toplevel fuer S3Starter
--
library IEEE;
use IEEE.std_logic_1164.all;

entity kc854 is
    generic (
        RESET_DELAY : integer := 100000
    );
    port(
        CLOCK_50    : in std_logic;
        VGA_R       : out std_logic;
        VGA_G       : out std_logic;
        VGA_B       : out std_logic;
        VGA_HS      : out std_logic;
        VGA_VS      : out std_logic;
        
        SRAM_ADDR   : out std_logic_vector(17 downto 0);
        SRAM_DQ     : inout std_logic_vector(15 downto 0);
        SRAM_OE_N   : out std_logic;
        SRAM_CE_N   : out std_logic;
        SRAM_WE_N   : out std_logic;
        SRAM_LB_N   : out std_logic;
        SRAM_UB_N   : out std_logic;
        
        PS2_CLK     : inout std_logic;
        PS2_DAT     : inout std_logic;
    
        UART_TXD    : out std_logic;
        UART_RXD    : in std_logic;
        
--      Reset_n     : in std_logic;
--      clk         : in std_logic;
--      nmi_n           : in std_logic;
        
        KEY         : in  std_logic_vector(3 downto 0);
        SW          : in  std_logic_vector(7 downto 0);
        LEDR        : out std_logic_vector(7 downto 0);
        
        HEX         : out std_logic_vector(7 downto 0);
        HEX_AN      : out std_logic_vector(3 downto 0);
          
        SD_DAT      : in std_logic;
        SD_DAT3     : out std_logic;
        SD_CMD      : out std_logic;
        SD_CLK      : out std_logic;
        
        GPIO_1      : out std_logic_vector(9 downto 0)
    );
end kc854;

architecture struct of kc854 is

    constant NUMINTS    : integer := 4 + 6 + 2 + 4; -- (CTC + SIO + PIO + CTC)
    
    signal cpuclk       : std_logic;
    signal vgaclk       : std_logic;
    
    signal clkLocked    : std_logic;
    
    signal sramOE_n     : std_logic;
    signal sramDataOut  : std_logic_vector(15 downto 0);
    signal sramDataIn   : std_logic_vector(15 downto 0);
    
    signal cpuReset_n   : std_logic;
    signal cpuAddr      : std_logic_vector(15 downto 0);
    signal cpuDataIn    : std_logic_vector(7 downto 0);
    signal cpuDataOut   : std_logic_vector(7 downto 0);
    signal cpuEn        : std_logic;
    signal cpuWait      : std_logic;
    signal cpuTick      : std_logic;
    signal cpuInt_n     : std_logic := '1';
    signal cpuM1_n      : std_logic;
    signal cpuMReq_n    : std_logic;
    signal cpuRfsh_n    : std_logic;
    signal cpuIorq_n    : std_logic;
    signal cpuRD_n      : std_logic;
    signal cpuWR_n      : std_logic;
    signal cpuRETI      : std_logic;
    signal cpuIntE      : std_logic;

    signal memDataOut   : std_logic_vector(7 downto 0);
    
    signal vidAddr      : std_logic_vector(13 downto 0);
    signal vidData      : std_logic_vector(15 downto 0);
    signal vidBusy      : std_logic;
    signal vidRead      : std_logic;
    signal vidHires     : std_logic;
    signal vidBlinkEn   : std_logic;
    
    signal ioSel        : boolean;
    
    signal pioCS_n      : std_logic;
    
    signal pioAIn       : std_logic_vector(7 downto 0);
    signal pioAOut      : std_logic_vector(7 downto 0);
    signal pioARdy      : std_logic;
    signal pioAStb      : std_logic;
        
    signal pioBIn       : std_logic_vector(7 downto 0);
    signal pioBOut      : std_logic_vector(7 downto 0);
    signal pioBRdy      : std_logic;
    signal pioBStb      : std_logic;
    
    signal pioDataOut   : std_logic_vector(7 downto 0);
    
    signal ctcCS_n      : std_logic;
    signal ctcH4Clk     : std_logic;
    signal ctcBIClk     : std_logic;
    signal vidH5ClkEn   : std_logic;
        
    signal ctcDataOut   : std_logic_vector(7 downto 0);
    signal ctcClkTrg    : std_logic_vector(3 downto 0);
    signal ctcZcTo      : std_logic_vector(3 downto 0);
    
    signal intPeriph    : std_logic_vector(NUMINTS-1 downto 0);
    signal intAckPeriph : std_logic_vector(NUMINTS-1 downto 0);
    
    signal debugCpuAddr : std_logic_vector(15 downto 0);
    signal debugClock   : integer range 0 to 24999999 := 0;
    signal debugRunCpu  : std_logic;
    signal debugPort    : std_logic_vector(5 downto 0) := (others => '0');
    
    signal bootmode     : std_logic;
    signal resetDelay   : integer range 0 to RESET_DELAY := RESET_DELAY;
    signal uartTXD1     : std_logic;
    signal uartTXD2     : std_logic;
    signal uartTXD3     : std_logic;
    
    signal keybPs2code  : std_logic_vector(7 downto 0);
    signal keybKcKey    : std_logic_vector(7 downto 0);
    
    signal m003DataOut  : std_logic_vector(7 downto 0);
    signal m003Sel      : std_logic;
    signal m003Test     : std_logic_vector(7 downto 0);
    signal m003TestUart : std_logic;
     
    signal vgaRed       : std_logic_vector(3 downto 0);
    signal vgaGreen     : std_logic_vector(3 downto 0);
    signal vgaBlue      : std_logic_vector(3 downto 0);
     
    signal uart1Wr_n    : std_logic;
     
    signal ledData      : std_logic_vector(15 downto 0);
    
begin
--    GPIO_1(1) <= debugPort(2);
--    GPIO_1(3) <= uartTXD1;
--    GPIO_1(5) <= uartTXD2;
--    GPIO_1(7) <= uartTXD3;

    VGA_R <= vgaRed(3);
    VGA_G <= vgaGreen(3);
    VGA_B <= vgaBlue(3);
     
    ledData <= keybKcKey & keybPs2code;
     
    LEDR(0) <= pioBStb;
    LEDR(4 downto 1) <= ctcClkTrg;
    LEDR(5) <= '0';
    LEDR(6) <= not UART_RXD;
    LEDR(7) <= debugPort(1);
--   LEDR(7 downto 6) <= (others =>'0');
--   ledData <= cpuAddr;
     
    led : entity work.ledDisplay
    port map (
        clk        => cpuclk,
        display    => ledData,
        hex_digits => HEX_AN,
        hex        => HEX
    );

    debug : process
    begin
        wait until rising_edge(cpuclk);
    
        debugPort(0) <= '0';
        if (intPeriph(5 downto 4) /="00") then
             debugPort(0) <= '1';
        end if;
        
        if (cpuTick='1') then
 --           debugPort(1) <= not debugPort(1);
        end if;
        
        debugPort(2) <= '0';
        if (intPeriph(15 downto 6) /= "0000000000") then
            debugPort(2) <= '1';
        end if;
        
--        if (SW(0)='0') then
--              debugRunCpu <= cpuTick; 
--        else
--              if (debugClock<24999999) then
--                   debugRunCpu <= '0';
--                  debugClock <= debugClock + 1;
--              else
--                   debugPort(1) <= not debugPort(1);
--                  debugClock <= 0;
--                  debugRunCpu <= KEY(1);
--              end if;
--        end if;
            
        if (cpuTick='1') then
                if (debugClock<1773447) then
                     debugRunCpu <= '0';
                    debugClock <= debugClock + 1;
                else
                     debugPort(1) <= not debugPort(1);
                    debugClock <= 0;
                end if;
          end if;
          
 --       debugRunCpu <= '1';
--        if (debugClock<20000000) then
--            debugClock <= debugClock + 1;
--            if (debugCpuAddr<x"FFFF") then
--                debugRunCpu <= (cpuM1_n or SW(4)) and KEY(1);
--            else
--                debugRunCpu <= not KEY(2);
--            end if;
--        else
--            debugClock <= 0;
--            debugRunCpu <= KEY(1);            
--        end if;
        
        if (cpuM1_n='0') then
            debugCpuAddr <= cpuAddr;
 --           LEDR         <= cpuDataIn;
        end if;
       
        if (cpuReset_n='0') then
            debugCpuAddr <= (others => '0');
        end if;
    end process;  
  
    cpuReset_n <= '0' when resetDelay /= 0 else '1';
  
    reset : process
    begin
        wait until rising_edge(cpuclk);
        
        if resetDelay>0 then
            resetDelay <= resetDelay - 1;
        elsif (debugCpuAddr(15 downto 14)="11") then
            bootmode <= '0';
        end if;
        
        if (KEY(0)='1' or clkLocked='0') then
            bootmode <= '1';
            resetDelay <= RESET_DELAY;
        end if;
    end process;
    
    clockgen : entity work.clockgen
    port map (
        extclk => CLOCK_50,
        cpuclk => cpuclk,
        vgaclk => vgaclk,
        locked => clkLocked
    );
    
    video : entity work.video
    generic map (
        DITHER_MODE => 1    
    )
    port map (
        cpuclk    => cpuclk, 
        vidclk    => vgaclk,
        
        vidH5ClkEn => vidH5ClkEn,
        
        vgaRed    => vgaRed,
        vgaGreen  => vgaGreen,
        vgaBlue   => vgaBlue,
        vgaHSync  => VGA_HS,
        vgaVSync  => VGA_VS,
        
        vidAddr   => vidAddr,
        vidData   => vidData,
        vidRead   => vidRead,
        vidBusy   => vidBusy,
 
        vidBlink  => ctcZcTo(2),
        vidBlinkEn => vidBlinkEn,
 
        vidBlank  => not cpuReset_n,
        
        vidHires  => vidHires,
        
 
        vidScanline => SW(1)
    );
    
    SRAM_OE_N <= sramOE_n;
    SRAM_DQ <= sramDataOut when sramOE_n='1' else "ZZZZZZZZZZZZZZZZ";
    sramDataIn <= SRAM_DQ;
    
    memcontrol : entity work.memcontrol
    port map (
        clk          => cpuclk,
        reset_n      => cpuReset_n,

        sramAddr     => SRAM_ADDR,
        sramDataIn   => sramDataIn,
        sramDataOut  => sramDataOut,
        sramOE_n     => sramOE_n,
        sramCE_n     => SRAM_CE_N,
        sramWE_n     => SRAM_WE_N,
        sramLB_n     => SRAM_LB_N,
        sramUB_n     => SRAM_UB_N,
         
        cpuAddr      => cpuAddr,

        cpuDOut      => memDataOut,
        cpuDIn       => cpuDataOut,
         
        cpuWR_n      => cpuWR_n,
        cpuRD_n      => cpuRD_n,
        cpuMREQ_n    => cpuMReq_n,
        cpuM1_n      => cpuM1_n,
        cpuIORQ_n    => cpuIorq_n,
        
        cpuEn        => cpuEn,
        cpuWait      => cpuWait,
        
 --       cpuTick      => debugRunCpu,
        cpuTick      => cpuTick,
        
        pioPortA     => pioAOut,
        pioPortB     => pioBOut,
        
        vidAddr      => vidAddr,
        vidData      => vidData,
        vidBusy      => vidBusy,
        vidRead      => vidRead,
        
        vidHires     => vidHires,
        vidBlinkEn   => vidBlinkEn,
        
        bootmode     => bootmode
        
--        switches     => LEDR
    );
    
    -- CPU data-in multiplexer
    cpuDataIn <= 
            ctcDataOut when ctcCS_n='0' or intAckPeriph(3 downto 0) /= "0000" else
            pioDataOut when pioCS_n='0' or intAckPeriph(5 downto 4) /= "00"   else
            m003DataOut when m003Sel='1' or intAckPeriph(15 downto 6) /= "0000000000" else
            memDataOut;
            
    cpu : entity work.T80se
    generic map(Mode => 1, T2Write => 1, IOWait => 0)
    port map(
        RESET_n => cpuReset_n,
--        RESET_n => '0',
        CLK_n   => cpuclk,
        CLKEN   => cpuEn,
        WAIT_n  => cpuWait,
        INT_n   => cpuInt_n,
        NMI_n   => '1',
        BUSRQ_n => '1',
        M1_n    => cpuM1_n,
        MREQ_n  => cpuMReq_n,
        IORQ_n  => cpuIorq_n,
        RD_n    => cpuRD_n,
        WR_n    => cpuWR_n,
        RFSH_n  => open,
        HALT_n  => open,
        BUSAK_n => open,
        A       => cpuAddr,
--            DI      => "00000000",
        DI      => cpuDataIn,
        DO      => cpuDataOut,
        IntE    => cpuIntE,
        RETI_n  => cpuRETI
    );
        
    ioSel   <= cpuIorq_n = '0' and cpuM1_n='1';
    
    -- PIO: 88H-8BH
    pioCS_n <= '0' when cpuAddr(7 downto 2) = "100010"  and ioSel else '1';
    
    pioAStb <= '1';
    pioAIn  <= (others => '1');
    pioBIn  <= (others => '1');
    
    pio : entity work.pio
    port map (
        clk     => cpuclk,
        res_n   => cpuReset_n,
        dIn     => cpuDataOut,
        dOut    => pioDataOut,
        baSel   => cpuAddr(0),
        cdSel   => cpuAddr(1),
        cs_n    => pioCS_n,
        m1_n    => cpuM1_n,
        iorq_n  => cpuIorq_n,
        rd_n    => cpuRD_n,
        intAck  => intAckPeriph(5 downto 4),
        int     => intPeriph(5 downto 4),
        aIn     => pioAIn,
        aOut    => pioAOut,
        aRdy    => pioARdy,
        aStb    => pioAStb,
        bIn     => pioBIn,
        bOut    => pioBOut,
        bRdy    => pioBRdy,
--        bStb  => '1'
        bStb    => pioBStb
    );
    
    keyboard : entity work.keyboard
    port map (
        clk     => cpuclk,
        res_n   => clkLocked,
        
        ps2clk  => PS2_CLK,
        ps2data => PS2_DAT,
        
        remo    => pioBStb,
        
        ps2code => keybPs2code,
        kcKey   => keybKcKey
    );
    
    sysclock : entity work.sysclock
    port map (
        clk      => cpuclk,
        cpuClkEn => cpuTick,
        h4Clk    => ctcH4Clk,
        h5ClkEn  => vidH5ClkEn,
        biClk    => ctcBIClk
    );
    
    -- CTC: 8CH-8FH
    ctcCS_n <= '0' when cpuAddr(7 downto 2) = "100011"  and ioSel else '1';

    ctcClkTrg(0) <= ctcH4Clk;
    ctcClkTrg(1) <= ctcH4Clk;
    ctcClkTrg(2) <= ctcBIClk;
    ctcClkTrg(3) <= ctcBIClk;

    ctc : entity work.ctc
    port map (
        clk     => cpuclk,
        sysClkEn => cpuTick,
        res_n   => cpuReset_n,
        cs      => ctcCS_n,
        dIn     => cpuDataOut,
        dOut    => ctcDataOut,
        chanSel => cpuAddr(1 downto 0),
        m1_n    => cpuM1_n,
        iorq_n  => cpuIorq_n,
        rd_n    => cpuRD_n,
        int     => intPeriph(3 downto 0),
        intAck  => intAckPeriph(3 downto 0),
        clk_trg => ctcClkTrg,
        zc_to   => ctcZcTo
    );
    
    m003TestUart <= '1' when (not m003Sel='1') or (intAckPeriph(15 downto 6) /= "0000000000") else '0';
    
     uart1Wr_n <= cpuRD_n and cpuWR_n;
     
    uart1 : entity work.uart
    generic map (
        BAUDRATE => 2_000_000
    )
    port map (
        clk     => cpuclk,
        cs_n    => m003TestUart,
        rd_n    => '1',
        wr_n    => uart1Wr_n,
        addr    => "0",
        dIn     => cpuAddr(7 downto 0),
        dOut    => open,
        txd     => uartTXD1,
        rxd     => '1'
    );
    
    uart2 : entity work.uart
    generic map (
        BAUDRATE => 2_000_000
    )
    port map (
        clk     => cpuclk,
        cs_n    => m003TestUart,
        rd_n    => '1',
        wr_n    => cpuRD_n,
        addr    => "0",
        dIn     => m003DataOut,
        dOut    => open,
        txd     => uartTXD2,
        rxd     => '1'
    );
    
    uart3 : entity work.uart
    generic map (
        BAUDRATE => 2_000_000
    )
    port map (
        clk     => cpuclk,
        cs_n    => m003TestUart,
        rd_n    => '1',
        wr_n    => cpuWR_n,
        addr    => "0",
        dIn     => cpuDataOut,
--        dIn     => m003Test,
        dOut    => open,
        txd     => uartTXD3,
        rxd     => '1'
    );
    
    intController : entity work.intController
    generic map (
        NUMINTS => NUMINTS
    )
    port map (
        clk     => cpuclk,
        res_n   => cpuReset_n,
        int     => cpuInt_n,
        intPeriph => intPeriph,
        intAck  =>  intAckPeriph,
        m1      => cpuM1_n,
        iorq    => cpuIorq_n,
        RETI_n  => cpuRETI
    );
    
    m003 : entity work.m003
    port map (
        clk      => cpuclk,
        sysClkEn => cpuTick,
        
        res_n    => cpuReset_n,
        
        addr     => cpuAddr,
        dIn      => cpuDataOut,
        dOut     => m003DataOut,
        
        modSel   => m003Sel,
--        modEna   => LEDR(9),
        
        m1_n     => cpuM1_n,
        mreq_n   => cpuMREQ_n,
        iorq_n   => cpuIORQ_n,
        rd_n     => cpuRD_n,
        
        int      => intPeriph(15 downto 6),
        intAck   => intAckPeriph(15 downto 6),
        
        divideBy2 => SW(2),
        aRxd     => '1',
        aTxd     => open,
        bRxd     => UART_RXD,
        bTxd     => UART_TXD,
--        bTxd     => GPIO_1(1),
        
        test     => m003Test
    );
end;
