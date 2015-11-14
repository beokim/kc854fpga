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
-- sehr minimale TB
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity kc854_min_tb is
end kc854_min_tb; 

architecture struct of kc854_min_tb is
    signal cpuclk       : std_logic;
  
    signal cpuAddr      : std_logic_vector(15 downto 0);
    signal cpuDataIn    : std_logic_vector(7 downto 0);
    signal cpuDataOut   : std_logic_vector(7 downto 0);
    signal cpuEn        : std_logic;
    signal cpuWait      : std_logic;
    signal cpuTick      : std_logic;
    
    signal cpuInt_n     : std_logic;
    signal cpuM1_n      : std_logic;
    signal cpuMReq_n    : std_logic;
    signal cpuRfsh_n    : std_logic;
    signal cpuIorq_n    : std_logic;
    signal cpuRD_n      : std_logic;
    signal cpuWR_n      : std_logic;
    signal cpuRETI      : std_logic;
    
    signal reset_n      : std_logic;
begin
    process
    begin
        cpuclk <= '0';
        wait for 10 ns;
        cpuclk <= '1';
        wait for 10 ns;
    end process;
    
    reset_n <= '0' , '1' after 30 ns; 
    cpuEn <= '1';
    cpuWait <= '1';
    
    cpu : entity work.T80se
    generic map(Mode => 1, T2Write => 1, IOWait => 0)
    port map(
        RESET_n => reset_n,
        CLK_n   => cpuclk,
        CLKEN   => cpuEn,
        WAIT_n  => cpuWait,
--        INT_n   => cpuInt_n,
        INT_n   => '1',
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
        DI      => "00000000",
--        DI      => cpuDataIn,
        DO      => cpuDataOut,
        RETI_n  => cpuRETI
    );
end;


