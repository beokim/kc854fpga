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
-- M003 Modul
--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity m003 is
    generic (
        SLOT     : std_logic_vector(7 downto 0) := x"08";
        SIGNATURE :  std_logic_vector(7 downto 0) := x"ee"
    );
    port (
        clk      : in std_logic;
        sysClkEn : in std_logic;
        
        res_n    : in std_logic;
        
        addr     : in std_logic_vector(15 downto 0);
        dIn      : in std_logic_vector(7 downto 0);
        dOut     : out std_logic_vector(7 downto 0);
        
        modSel   : out std_logic;
        modEna   : out std_logic;
        
        m1_n     : in std_logic;
        mreq_n   : in std_logic;
        iorq_n   : in std_logic;
        rd_n     : in std_logic;
        
        int      : out std_logic_vector(9 downto 0);
        intAck   : in std_logic_vector(9 downto 0);
        
        divideBy2 : in std_logic;
        
        aRxd     : in std_logic;
        aTxd     : out std_logic;
        bRxd     : in std_logic;
        bTxd     : out std_logic;
        
        test     : out std_logic_vector(7 downto 0)
    );
end m003;

architecture rtl of m003 is
    signal ioSel       : boolean;
    signal controlWordSel : std_logic;
    signal sioCS_n     : std_logic;
    signal ctcCS_n     : std_logic;

    signal enabled     : boolean;
    
    signal controlWord : std_logic_vector(7 downto 0) := (others => '0');
    
    signal ctcClkTrg   : std_logic_vector(3 downto 0) := (others => '0');
    signal ctcZcTo     : std_logic_vector(3 downto 0);

    signal ctcDataOut  : std_logic_vector(7 downto 0);
    signal sioDataOut  : std_logic_vector(7 downto 0);
begin
    ioSel   <= iorq_n = '0' and m1_n='1';
    
    controlWordSel <= '1' when ioSel and addr=(SLOT & x"80") else '0'; -- Controlword
    sioCS_n  <= '0' when enabled and ioSel and addr(7 downto 2)="000010" else '1'; -- 08 - 0B
    ctcCS_n  <= '0' when enabled and ioSel and addr(7 downto 2)="000011" else '1'; -- 0C - 0F
    
    test <= "00000" & controlWordSel & ctcCS_n & sioCS_n;
    
    dOut <= SIGNATURE  when controlWordSel='1' else
            sioDataOut when sioCS_n='0' or (intAck(5 downto 0)/="000000") else
            ctcDataOut when ctcCS_n='0' or (intAck(9 downto 6)/="0000") else
            x"00";
    
    modSel  <= controlWordSel or not sioCS_n or not ctcCS_n;
    
    modEna  <= controlWord(0);
    enabled <= controlWord(0)='1';
    
    control : process
    begin
        wait until rising_edge(clk);
        
        if (res_n='0') then
            controlWord <= (others => '0');
        elsif (controlWordSel='1' and rd_n='1') then
            controlWord <= dIn;
        end if;
    end process;
    
    divider : process
    begin
        wait until rising_edge(clk);
        
        if (divideBy2='1') then
            ctcClkTrg(1 downto 0) <= (others => sysClkEn);
        elsif (sysClkEn='1') then
            ctcClkTrg(1 downto 0) <= not ctcClkTrg(1 downto 0);
        end if;
    end process;
    
    ctc : entity work.ctc
    port map (
        clk     => clk,
        sysClkEn => sysClkEn,
        res_n   => res_n,
        cs      => ctcCS_n,
        dIn     => dIn,
        dOut    => ctcDataOut,
        chanSel => addr(1 downto 0),
        m1_n    => m1_n,
        iorq_n  => iorq_n,
        rd_n    => rd_n,
        int     => int(9 downto 6),
        intAck  => intAck(9 downto 6),
        clk_trg => ctcClkTrg,
        zc_to   => ctcZcTo
    );
    
    sio : entity work.sio
    port map (
        clk     => clk,  
        res_n   => res_n, 
        cs_n    => sioCS_n,
        
        dIn     => dIn,
        dOut    => sioDataOut,
        
        rd_n    => rd_n,
        iorq_n  => iorq_n,
        m1_n    => m1_n,
        baSel   => addr(0), 
        cdSel   => addr(1), 
        
        int     => int(5 downto 0),
        intAck  => intAck(5 downto 0), 
        
        aRxd     => aRxd,
        aTxd     => aTxd,
        aRxTxClk => ctcZcTo(0),
        
        bRxd     => bRxd,
        bTxd     => bTxd,
        bRxTxClk => ctcZcTo(1)
    );
end;

