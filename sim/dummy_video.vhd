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
-- Dummy-Video fuer schnellere Simulation
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity video is
    port (
        cpuclk    : in  std_logic;
        vidclk    : in  std_logic;
        
        vidH5ClkEn : in  std_logic;
        
        vgaRed    : out std_logic_vector(3 downto 0);
        vgaGreen  : out std_logic_vector(3 downto 0);
        vgaBlue   : out std_logic_vector(3 downto 0);
        vgaHSync  : out std_logic;
        vgaVSync  : out std_logic;
        
        vidAddr   : out std_logic_vector(13 downto 0);
        vidData   : in  std_logic_vector(15 downto 0);
        vidRead   : in  std_logic;
        vidBusy   : in  std_logic;
        
        vidHires  : in  std_logic;
        
        vidBlink  : in  std_logic;
        vidBlinkEn : in  std_logic;
        
        vidScanline : in  std_logic;
        
        blinkTest  : in std_logic;
        
        test       : out std_logic_vector(3 downto 0)
    );
end video;

architecture rtl of video is

begin
    vgaRed   <= "0000";
    vgaGreen <= "0000";
    vgaBlue  <= "0000";
    vgaHSync <= '1';
    vgaVSync <= '1';
    vidAddr  <= (others => '0');
end;