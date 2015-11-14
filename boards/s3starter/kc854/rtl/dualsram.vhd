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
-- Dualport-BRAM for Xilinx
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dualsram is
    generic(
        AddrWidth   : integer := 11;
        DataWidth   : integer := 8
    );
    port (
        clk1,clk2    : in std_logic;
        addr1, addr2 : in std_logic_vector(AddrWidth - 1 downto 0);
        din1, din2   : in std_logic_vector(DataWidth - 1 downto 0);
        dout1, dout2 : out std_logic_vector(DataWidth - 1 downto 0);
        we1_n, we2_n : in std_logic;
        ce1_n, ce2_n : in std_logic
    );
end dualsram;

architecture rtl of dualsram is
    type mem is array (natural range <>) of std_logic_vector(DataWidth - 1 downto 0);
    shared variable ram: mem(0 to 2 ** AddrWidth - 1) := ((others=> (others=>'0')));
    
begin
    process
    begin
        wait until rising_edge(clk1);
        
        if we1_n = '0' and ce1_n = '0' then
                ram(to_integer(unsigned(addr1))) := din1;
        end if;
        dout1 <= ram(to_integer(unsigned(addr1)));
    end process;
    
    process
    begin
      wait until rising_edge(clk2);
        
        if ce2_n = '0' and we2_n = '0' then
            ram(to_integer(unsigned(addr2))) := din2;
        end if;
        dout2 <= ram(to_integer(unsigned(addr2)));
    end process;
end rtl;