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
-- Erzeugung der Takte fuer KC
--   CPU+CTC
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sysclock is
    port (
        clk      : in std_logic;
        
        cpuClkEn : out std_logic; -- 1,7734476 MHz (PALx2: 8,867238 MHz/5)
        h4Clk    : out std_logic; 
        h5ClkEn  : out std_logic; -- 15,694 kHz Clock enable
        biClk    : out std_logic  
    );
end sysclock;

architecture rtl of sysclock is
    constant H4_CLK_MAX : integer := 32 + 32 + 32 + 16; -- 32 (L) 32 (H) 32 (L) 16 (H) = 112 (15,834 kHz)
    constant BI_CLK_MAX : integer := 256 + 56; -- 256 * 112 (L) 56 * 112 (H) = 34.944 (50,75Hz)

    constant DIVIDER    : integer := 28;
    constant FRACT_DIVIER : integer := 5;
    
    signal mainDivider  : integer range 0 to DIVIDER := 0;
    signal fractDivider : integer range 0 to FRACT_DIVIER := 0;
    
    signal mainClkEn    : std_logic;
    signal h5ClkCounter : integer range 0 to H4_CLK_MAX-1;
    signal h5ClkCounterSLV : std_logic_vector(6 downto 0);
    signal biClkCounter : integer range 0 to BI_CLK_MAX-1;
    
begin
    cpuClkEn <= mainClkEn;
    -- Divider: Reset@ 111 0000 => 112
    -- 32 (L) 32 (H) 32 (L) 16 (H) = 112
    h5ClkCounterSLV <= std_logic_vector(to_unsigned(h5ClkCounter,h5ClkCounterSLV'length));
    h4Clk <= h5ClkCounterSLV(5);
    -- Divider: Reset@ 1 0011 1000 => 312
    -- 256 (L) 56 (H) 
    biClk <= '0' when biClkCounter<256 else '1'; 
    
    -- Ziel: 1,7734476 MHz
    -- genauer Teiler: 28,193681
    -- 50 MHz durch 28,2 dividieren
    --  --> 1,7730496 MHz
    cpuClk : process 
    begin
        wait until rising_edge(clk);

        if (mainDivider > 0) then
            mainDivider <= mainDivider - 1;
            mainClkEn <= '0';
        else
            if (fractDivider>0) then
                mainDivider <= DIVIDER - 1;
                fractDivider <= fractDivider - 1;
            else
                mainDivider <= DIVIDER;
                fractDivider <= FRACT_DIVIER-1;
            end if;
                
            mainClkEn <= '1';
        end if;
    end process;
    
    -- Takte fuer CTC (normalerweise aus Videotakt abegeleitet)
    ctcClk : process
    begin
        wait until rising_edge(clk);

        h5ClkEn <= '0';        
        
        if (mainClkEn='1') then
            -- H4-Clock
            if (h5ClkCounter<H4_CLK_MAX-1) then
                h5ClkCounter <= h5ClkCounter + 1;
            else 
                h5ClkCounter <= 0;
                h5ClkEn <= '1';
                
                -- BI-Clock
                if (biClkCounter<BI_CLK_MAX-1) then
                    biClkCounter <= biClkCounter + 1;
                else
                    biClkCounter <= 0;
                end if;
            end if;
        end if;
    end process;
    
end;

