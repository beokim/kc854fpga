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
-- LED-Anzeige S3Starter
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ledDisplay is
    generic (
        sysclk : integer := 50000 -- 50MHz
    );
    Port ( 
        clk          : in  STD_LOGIC;
        display      : in   STD_LOGIC_VECTOR (15 downto 0);
        hex_digits   : out  STD_LOGIC_VECTOR (3 downto 0);
        hex          : out  STD_LOGIC_VECTOR (7 downto 0));
end ledDisplay;

architecture rtl of ledDisplay is
     signal displayDelay : integer range 0 to sysclk := 0;
     signal displayDigit : integer range 0 to 3 := 0;
     signal digit        : std_logic_vector(3 downto 0);
begin
    process
    begin
        wait until rising_edge(clk);
         
        if (displayDelay < sysclk) then
              displayDelay <= displayDelay + 1;
        else
            displayDelay <= 0;
                
            if (displayDigit < 3) then
                displayDigit <= displayDigit + 1;
            else
                displayDigit <= 0;
            end if;
        end if;
    end process;
     
    hex_digits <= "1110" when displayDigit=0 else
                  "1101" when displayDigit=1 else
                  "1011" when displayDigit=2 else
                  "0111";
                  
    digit <= display(3 downto 0)  when displayDigit=0 else
                display(7 downto 4)  when displayDigit=1 else
                display(11 downto 8) when displayDigit=2 else
                display(15 downto 12);
     
    dec : entity work.seg7dec
    port map (
        number => digit,
        digits => hex(6 downto 0)
    );

    hex(7) <= '1';
end;

