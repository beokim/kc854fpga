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
-- Toplevel fuer Display Blinktest
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity blink_test is
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
end blink_test;

architecture struct of blink_test is
    constant CTC_DIVIDER_MAX1 : integer := 33*16 ; -- DIGGER
    constant CTC_DIVIDER_MAX2 : integer := 20*16 ; -- DIGGER-4

    signal cpuclk       : std_logic;
    signal vgaclk       : std_logic;
    
    signal clkLocked    : std_logic;
        
    signal blink2div    : std_logic := '0';
    signal blink2div2   : std_logic := '0';
    signal blink2div3   : std_logic := '0';
    
    signal ctcDiv       : integer range 0 to CTC_DIVIDER_MAX1-1;
    
    signal blinkTest    : std_logic_vector(3 downto 0);
    
    signal vidLine      : std_logic_vector(8 downto 0);
    
    signal cpuTick      : std_logic;
    signal ctcH4Clk     : std_logic_vector(1 downto 0);
    signal vidH5ClkEn   : std_logic;
    signal ctcBIClk     : std_logic;
    
    signal vDisplay     : std_logic;
    
    signal testDiv      : integer range 0 to 50000 := 0;
    
    constant KC_VIDLINES : integer := 312;
    constant VGA_BLINKLINES : integer := 3*5*3*17; -- (765)
    signal kcVidLine    : integer range 0 to KC_VIDLINES-1 := 0;
    signal vgaVidLine   : integer range 0 to VGA_BLINKLINES-1 := 0;
    signal kcVidLineSLV : std_logic_vector(8 downto 0);
    signal vidBlink     : std_logic;
    signal vgaDiv       : integer range 0 to 33*192;
    
    signal vgaData      : std_logic_vector(15 downto 0);
    
    signal vidBlinkRam  : std_logic;
    
begin
    GPIO_1(1) <= kcVidLineSLV(0);
    GPIO_1(3) <= blink2Div;
    GPIO_1(5) <= vidBlinkRam;
    GPIO_1(7) <= vidLine(0);
    
    clockgen : entity work.clockgen
    port map (
        extclk => CLOCK_50,
        cpuclk => cpuclk,
        vgaclk => vgaclk,
        locked => clkLocked
    );
    
    sysclock : entity work.sysclock
    port map (
        clk      => cpuclk,
        cpuClkEn => cpuTick,
        h4Clk    => ctcH4Clk(0),
        h5ClkEn  => vidH5ClkEn,
        biClk    => ctcBIClk
    );
    
    blink : process
    begin
        wait until rising_edge(cpuclk);
       
 --       if (cpuTick='1' and KEY(0)='0') then
        if (cpuTick='1') then
            if (ctcDiv=0) then
                blink2Div <= not blink2Div;
                if (KEY(0)='1') then
--                    ctcDiv <= 16*21-1;
                    ctcDiv <= CTC_DIVIDER_MAX1-1;
                else
--                    blink2Div <= '1';
                    ctcDiv <= CTC_DIVIDER_MAX1-1;
                end if;
            else
                ctcDiv <= ctcDiv - 1;
            end if;
        end if;
    end process;
    
    kcLineCounter : process
    begin
        wait until rising_edge(cpuclk);
        
        if (vidH5ClkEn = '1') then
            if (kcVidLine<KC_VIDLINES-1) then
                kcVidLine <= kcVidLine + 1;
            else
                kcVidLine <= 0;
            end if;
        end if;
    end process;
    
    kcVidLineSLV <= std_logic_vector(to_unsigned(kcVidLine,kcVidLineSLV'length));
    
    blinkbuffer : entity work.dualsram
    generic map (
        ADDRWIDTH => 9,
        DATAWIDTH => 1
    )
    port map (
        clk1   => cpuclk,
        clk2   => vgaclk,
        addr1  => kcVidLineSLV,
        addr2  => vidLine,
        din1(0) => blink2Div,
        din2   => "0",
        dout1  => open,
        dout2(0)  => vidBlinkRam,
        wr1_n  => not vidH5ClkEn,
        wr2_n  => '1',
        cs1_n  => '0',
        cs2_n  => '0'
    );
    
    vgaData <= "11111001" & vidLine(7 downto 0);
    vidline(8) <= '0';
    
    -- Timing- und Pixelgenerator instanziieren
    vidgen : entity work.vidgen
    generic map (
        DITHER_MODE => 0
    )
    port map (
        vidclk   => vgaclk,
        
        vgaRed   => VGA_R,
        vgaGreen => VGA_G,
        vgaBlue  => VGA_B,
        vgaHSync => VGA_HS,
        vgaVSync => VGA_VS,
        
        vgaAddr  => open,
        vgaData  => vgaData,
        
        vidHires => '0',
        
        vidBlink => vidBlinkRam,
        
        vidLine  => vidLine(7 downto 0),
        
        vidScanline => SW(1),
        
        vidNextLine => open,
        
        test => blinkTest
    );
end;