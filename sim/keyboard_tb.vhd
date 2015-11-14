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
-- Toplevel fuer Test des Keyboards
--
library IEEE;
use IEEE.std_logic_1164.all;

entity keyboard_tb is
    port(
        CLOCK_50    : in std_logic;
        CLOCK_24    : in  std_logic_vector(1 downto 0);
        VGA_R       : out std_logic_vector(3 downto 0);
        VGA_G       : out std_logic_vector(3 downto 0);
        VGA_B       : out std_logic_vector(3 downto 0);
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
        SW          : in  std_logic_vector(9 downto 0);
        LEDR        : out std_logic_vector(9 downto 0);
        LEDG        : out std_logic_vector(7 downto 0);
        
        HEX0        : out std_logic_vector(6 downto 0);
        HEX1        : out std_logic_vector(6 downto 0);
        HEX2        : out std_logic_vector(6 downto 0);
        HEX3        : out std_logic_vector(6 downto 0);
        
        GPIO_1      : out std_logic_vector(9 downto 0)
    );
end keyboard_tb;

architecture struct of keyboard_tb is
    signal cpuclk    : std_logic;
    signal clkLocked : std_logic;
    
    signal keybPs2code : std_logic_vector(7 downto 0);
    signal keybKcKey : std_logic_vector(7 downto 0);
    
begin
    dec1 : entity work.seg7dec
    port map (
        number => keybPs2code(3 downto 0),
        digits => HEX0
    );
    
    dec2 : entity work.seg7dec
    port map (
        number => keybPs2code(7 downto 4),
        digits => HEX1
    );
    
    dec3 : entity work.seg7dec
    port map (
        number => keybKcKey(3 downto 0),
        digits => HEX2
    );
    
    dec4 : entity work.seg7dec
    port map (
        number => keybKcKey(7 downto 4),
        digits => HEX3
    );

    clockgen : entity work.clockgen
    port map (
        extclk => CLOCK_50,
        cpuclk => cpuclk,
        vgaclk => open,
        locked => clkLocked
    );
    
    keyboard : entity work.keyboard
    port map (
        clk     => cpuclk,
        res_n   => clkLocked,
        
        ps2clk  => PS2_CLK,
        ps2data => PS2_DAT,
        
        remo    => GPIO_1(1),
        ps2code => keybPs2code,
        kcKey   => keybKcKey,
        kcKeydown => LEDG(0),
        ps2shift => LEDG(1)
    );
end;
