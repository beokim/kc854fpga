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
-- Testbench fuer Speichercontroller ohne CPU
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memcontrol_tb is
end memcontrol_tb;

architecture sim of memcontrol_tb is
    signal clk      : std_logic := '0';
    signal reset_n  : std_logic := '0';

    type testVectType is record
        cpuAddr     : std_logic_vector(15 downto 0);
        cpuDIn      : std_logic_vector(7 downto 0);
        cpuWR_n     : std_logic;
        cpuRD_n     : std_logic;
        cpuMREQ_n   : std_logic;
        vidRead     : std_logic;
        sramData    : std_logic_vector(15 downto 0);
        pioPortA    : std_logic_vector(7 downto 0);
        pioPortB    : std_logic_vector(7 downto 0);
    end record;
  
    signal testVect : testVectType;
    
    signal sramAddr : std_logic_vector(17 downto 0);
    signal sramData : std_logic_vector(15 downto 0);
    signal sramOE_n : std_logic;
    signal sramCE_n : std_logic;
    signal sramWE_n : std_logic;
    signal sramLB_n : std_logic;
    signal sramUB_n : std_logic;

    signal cpuDOut  : std_logic_vector(7 downto 0);
    signal cpuEn    : std_logic;
    
    signal vidData  : std_logic_vector(15 downto 0);
    signal vidBusy  : std_logic;
begin
    clk <= not clk after 10 ns;

    reset_n <= '1' after 100 ns;
    
    testVect <= (x"0000", x"00", '1', '1', '1', '1', x"0001", x"00", x"00" ),
                (x"0001", x"00", '1', '1', '1', '0', x"0002", x"00", x"00" ) after 90 ns,
                (x"0002", x"00", '1', '0', '0', '0', x"0003", x"00", x"00" ) after 150 ns,
                (x"0003", x"00", '1', '1', '1', '0', x"0004", x"00", x"00" ) after 190 ns,
                (x"0003", x"00", '0', '1', '0', '0', x"0004", x"00", x"00" ) after 210 ns,
                (x"0003", x"00", '1', '1', '1', '0', x"0004", x"00", x"00" ) after 250 ns;
                
    memcontrol : entity work.memcontrol
    port map (
        clk          => clk,
        reset_n      => reset_n,
         
        sramAddr     => sramAddr,
        sramDataOut  => open,
        sramDataIn   => testVect.sramData,
        sramOE_n     => sramOE_n,
        sramCE_n     => sramCE_n,
        sramWE_n     => sramWE_n,
        sramLB_n     => sramLB_n,
        sramUB_n     => sramUB_n,
         
        cpuAddr      => testVect.cpuAddr,
        cpuDOut      => cpuDOut,
        cpuDIn       => testVect.cpuDIn,
         
        cpuWR_n      => testVect.cpuWR_n,
        cpuRD_n      => testVect.cpuRD_n,
        cpuM1_n      => '1',
        cpuMREQ_n    => testVect.cpuMREQ_n,
        cpuIORQ_n    => '1',
        
        cpuEn        => cpuEn,
        cpuWait      => open,
               
        cpuTick      => '1',
        
        pioPortA     => testVect.pioPortA,
        pioPortB     => testVect.pioPortA,
        
        vidAddr      => testVect.cpuAddr(13 downto 0),
        vidData      => vidData,
        vidRead      => open,
        vidBusy      => vidBusy,
        
        vidHires     => open
    ); 

end;