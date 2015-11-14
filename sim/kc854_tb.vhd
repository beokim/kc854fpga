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

entity kc854_tb is
end kc854_tb; 

architecture sim of kc854_tb is
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
    
    kc854 : entity work.kc854
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
      
      SRAM_LB_CE_N <= SRAM_CE_N or SRAM_LB_N;
      SRAM_UB_CE_N <= SRAM_CE_N or SRAM_UB_N;
      
      lsram : entity work.sram_d
          generic map (
            -- Configuring RAM size
            size            =>  2**SRAM_ADDR_BITS-1,  -- number of memory words
            adr_width   =>  SRAM_ADDR_BITS,  -- number of address bits
            width       =>  8,  -- number of bits per memory word
            -- READ-cycle timing parameters
            tAA_max     => 10 ns, -- Address Access Time
            tOHA_min    =>  3 ns, -- Output Hold Time
            tACE_max    => 10 ns, -- nCE/CE2 Access Time
            tDOE_max    =>  4 ns, -- nOE Access Time
            tLZOE_min   =>  0 ns, -- nOE to Low-Z Output
            tHZOE_max   =>  4 ns, --  OE to High-Z Output
            tLZCE_min   =>  3 ns, -- nCE/CE2 to Low-Z Output
            tHZCE_max   => 10 ns, --  CE/nCE2 to High Z Output
            -- WRITE-cycle timing parameters
            tWC_min     => 10 ns, -- Write Cycle Time
            tSCE_min    =>  8 ns, -- nCE/CE2 to Write End
            tAW_min     =>  8 ns, -- tAW Address Set-up Time to Write End
            tHA_min     =>  0 ns, -- tHA Address Hold from Write End
            tSA_min     =>  0 ns, -- Address Set-up Time
            tPWE_min    =>  8 ns, -- nWE Pulse Width
            tSD_min     =>  6 ns, -- Data Set-up to Write End
            tHD_min     =>  0 ns, -- Data Hold from Write End
            tHZWE_max   =>  5 ns, -- nWE Low to High-Z Output
            tLZWE_min   =>  2 ns  -- nWE High to Low-Z Output
          ) 
          port map (
            nCE => SRAM_LB_CE_N,
            nOE => SRAM_OE_N,
            nWE => SRAM_WE_N,
            A   => SRAM_ADDR,
            D   => SRAM_DQ(7 downto 0)
          );
          
      usram : entity work.sram_d
          generic map (
            -- Configuring RAM size
            size            =>  2**SRAM_ADDR_BITS-1,  -- number of memory words
            adr_width   =>  SRAM_ADDR_BITS,  -- number of address bits
            width       =>  8,  -- number of bits per memory word
            -- READ-cycle timing parameters
            tAA_max     => 10 ns, -- Address Access Time
            tOHA_min    =>  3 ns, -- Output Hold Time
            tACE_max    => 10 ns, -- nCE/CE2 Access Time
            tDOE_max    =>  4 ns, -- nOE Access Time
            tLZOE_min   =>  0 ns, -- nOE to Low-Z Output
            tHZOE_max   =>  4 ns, --  OE to High-Z Output
            tLZCE_min   =>  3 ns, -- nCE/CE2 to Low-Z Output
            tHZCE_max   => 10 ns, --  CE/nCE2 to High Z Output
            -- WRITE-cycle timing parameters
            tWC_min     => 10 ns, -- Write Cycle Time
            tSCE_min    =>  8 ns, -- nCE/CE2 to Write End
            tAW_min     =>  8 ns, -- tAW Address Set-up Time to Write End
            tHA_min     =>  0 ns, -- tHA Address Hold from Write End
            tSA_min     =>  0 ns, -- Address Set-up Time
            tPWE_min    =>  8 ns, -- nWE Pulse Width
            tSD_min     =>  6 ns, -- Data Set-up to Write End
            tHD_min     =>  0 ns, -- Data Hold from Write End
            tHZWE_max   =>  5 ns, -- nWE Low to High-Z Output
            tLZWE_min   =>  2 ns  -- nWE High to Low-Z Output
          ) 
          port map (
            nCE => SRAM_UB_CE_N,
            nOE => SRAM_OE_N,
            nWE => SRAM_WE_N,
            A   => SRAM_ADDR,
            D   => SRAM_DQ(15 downto 8)
          ); 
end;
