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
-- TB fuer kompletten KC - entsprechend langsam
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity blink_tb is
end blink_tb; 

architecture sim of blink_tb is
    constant SRAM_ADDR_BITS : integer := 18;
  
    signal CLOCK_50  : std_logic;
    signal VGA_R     : std_logic_vector(3 downto 0);
    signal VGA_G     : std_logic_vector(3 downto 0);
    signal VGA_B     : std_logic_vector(3 downto 0);
    signal VGA_HS    : std_logic;
    signal VGA_VS    : std_logic;

    signal SRAM_ADDR : std_logic_vector(17 downto 0);
    signal SRAM_DQ   : std_logic_vector(15 downto 0);
    signal SRAM_OE_N : std_logic;
    signal SRAM_CE_N : std_logic;
    signal SRAM_WE_N : std_logic;
    signal SRAM_LB_N : std_logic;
    signal SRAM_UB_N : std_logic;
        
    signal SRAM_LB_CE_N : std_logic;
    signal SRAM_UB_CE_N : std_logic;
    
    signal UART_TXD  : std_logic;
    signal UART_RXD  : std_logic := '1';
begin
    process
    begin
        CLOCK_50 <= '0';
        wait for 10 ns;
        CLOCK_50 <= '1';
        wait for 10 ns;
    end process;
    
    kc854 : entity work.blink_test
    port map (
        CLOCK_50   => CLOCK_50,
        CLOCK_24   => "10",
      
        VGA_R      => VGA_R,
        VGA_G      => VGA_G,
        VGA_B      => VGA_B,
        VGA_HS     => VGA_HS,
        VGA_VS     => VGA_VS,
        
        SRAM_ADDR  => SRAM_ADDR,
        SRAM_DQ    => SRAM_DQ,
        SRAM_OE_N  => SRAM_OE_N,
        SRAM_CE_N  => SRAM_CE_N,
        SRAM_WE_N  => SRAM_WE_N,
        SRAM_LB_N  => SRAM_LB_N,
        SRAM_UB_N  => SRAM_UB_N,
        
        
        KEY        => (others => '1'),
        SW         => (others => '1'), 
      
        UART_RXD   => UART_RXD,
        UART_TXD   => UART_TXD
      );
end;
