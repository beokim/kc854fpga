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
-- Videoausgabe
--  - Pixel
--  - HSync/VSync
--
-- TODO: Hires-Mode
-- 
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.log2;
use IEEE.math_real.ceil;

entity vidgen is
    generic (
        DITHER_MODE : integer := 0
    );
    port (
        vidclk      : in  std_logic;
        
        vgaRed      : out std_logic_vector(3 downto 0);
        vgaGreen    : out std_logic_vector(3 downto 0);
        vgaBlue     : out std_logic_vector(3 downto 0);
        vgaHSync    : out std_logic;
        vgaVSync    : out std_logic;
        
        vgaAddr     : out std_logic_vector(5 downto 0);
        vgaData     : in  std_logic_vector(15 downto 0);
        
        vidHires    : in  std_logic;
        
        vidBlink    : in  std_logic;
         
        vidScanline : in  std_logic;
        
        vidNextLine : out std_logic;
        vidLine     : out std_logic_vector(7 downto 0);
        
        test        : out std_logic_vector(3 downto 0)
    );
end;

architecture rtl of vidgen is
    -- 1024x768 pixelclock: 65 MHz
    constant H_DISP        : integer := 1024;
    constant H_SYNC_START  : integer := 24  + H_DISP;
    constant H_SYNC_END    : integer := 136 + H_SYNC_START;
    constant H_VID_END     : integer := 160 + H_SYNC_END;
    constant H_SYNC_ACTIVE : std_logic := '0';
    constant H_DISP_START  : integer := (H_DISP-320*3)/2-3;
    
    constant V_DISP        : integer := 768;
    constant V_SYNC_START  : integer := 3   + V_DISP;
    constant V_SYNC_END    : integer := 6   + V_SYNC_START;
    constant V_VID_END     : integer := 29  + V_SYNC_END;
    constant V_SYNC_ACTIVE : std_logic := '0';

    constant SYNC_DELAY    : integer := 1;

    signal countH       : integer range 0 to H_VID_END-1 := 0;
    signal countV       : integer range 0 to V_VID_END-1 := 0;
    
    signal syncDelayH   : std_logic_vector(SYNC_DELAY downto 0);
    signal syncDelayV   : std_logic_vector(SYNC_DELAY downto 0);
    
    signal pixelShift   : std_logic_vector(7 downto 0);
    signal colorShift   : std_logic_vector(7 downto 0);
    signal colorData    : std_logic_vector(7 downto 0);
    
    signal pixelX       : integer range 0 to 2 := 0;
    signal pixelXshift  : integer range 0 to 7 := 0;
    signal pixelY       : integer range 0 to 2 := 0;
    signal displayPixel : boolean := false;
    
    signal lineAddr     : integer range 0 to 40 := 0;
    
    signal ditherFlag   : std_logic := '0';

    signal vidLineInt   : integer range 0 to 255 := 0;

begin
    vgaHSync <= syncDelayH(SYNC_DELAY);
    vgaVSync <= syncDelayV(SYNC_DELAY);

    vgaAddr <= std_logic_vector(to_unsigned(lineAddr,vgaAddr'length));
    vidLine <= std_logic_vector(to_unsigned(vidLineInt,vidLine'length));
    
    test(0) <= '1' when lineAddr mod 2 = 0 else '0';
    test(1) <= vidBlink;
    test(2) <= '0';
    test(3) <= '0';
    
    -- h-/v-counter
    vidtiming : process
    begin 
        wait until rising_edge(vidclk);
        
        ditherFlag <= not ditherFlag;
        
        if (countH < H_VID_END-1) then
            countH <= countH + 1;
        else
            countH <= 0;
            
            ditherFlag <= ditherFlag;
            
            if (countV < V_VID_END-1) then
                countV <= countV + 1;
                
                if (pixelY<2) then
                    pixelY <= pixelY + 1;
                else
                    pixelY <= 0;
                    if (vidLineInt<255) then
                        vidLineInt <= vidLineInt + 1;
                    end if;
                end if;
            else
                countV <= 0;
                pixelY <= 0;
                ditherFlag <= '0';
                vidLineInt <= 0;
            end if;
        end if;
    end process;
    
    -- vidsync + steuersignale fuer videologik
    vidsync : process 
    begin
        wait until rising_edge(vidclk);

        -- H-Sync + Ramcounter weiterzaehlen
        vidNextLine <= '0';
        if (pixelY=0 and countH<4) then
            vidNextLine <= '1';
        end if;
  
        syncDelayH <= syncDelayH(SYNC_DELAY-1 downto 0) & not H_SYNC_ACTIVE;
        if countH >= H_SYNC_START-1 and countH <= H_SYNC_END-1 then 
            syncDelayH <= syncDelayH(SYNC_DELAY-1 downto 0) & H_SYNC_ACTIVE;
        end if;
        
        -- V-Sync
        syncDelayV <= syncDelayV(SYNC_DELAY-1 downto 0) & not V_SYNC_ACTIVE;
        if countV >= V_SYNC_START-1 and countV <= V_SYNC_END-1 then
            syncDelayV <= syncDelayV(SYNC_DELAY-1 downto 0) & V_SYNC_ACTIVE;
        end if;
    end process;
    
    -- Videodaten aus Ram auslesen
    videodata : process
    begin
        wait until rising_edge(vidclk);

        if (countH = H_DISP_START) then -- Anfang des Pixelbereiches
            displayPixel <= true;
            lineAddr <= 0;
            pixelXshift <= 0;
        end if;
        
        if (displayPixel) then -- Pixel aus dem Linebuffer auslesen
            if (pixelX < 2) then
                pixelX <= pixelX + 1;
            else
                pixelX <= 0;
            end if;
                
            if pixelX = 0 then
                if pixelXshift>0 then -- Pixel shiften
                    pixelShift <= pixelShift(6 downto 0) & "0";
                    colorShift <= colorShift(6 downto 0) & "0";
                    pixelXshift <= pixelXshift - 1;
                else
                    if (lineAddr < 40) then -- neues Byte lesen
                        lineAddr <= lineAddr + 1;
                        pixelShift <= vgaData(7 downto 0);
                        colorShift <= vgaData(15 downto 8);
                        colorData <= vgaData(15 downto 8);
                        
                        pixelXshift <= 7;
                    else -- Ende erreicht
                        displayPixel <= false;
                        pixelShift <= "00000000";
                        colorShift <= "00000000";
                        colorData <= "00000000";
                    end if;
                end if;
            end if;
        end if;
    end process;
    
    -- pixel ausgeben
    colpixel : process
        variable dispColor : std_logic_vector(5 downto 0);
    begin
        wait until rising_edge(vidclk);

        dispColor := "000000";    -- schwarz
        if ((countV < V_DISP) and (countH < H_DISP) and not (vidScanline='0' and pixelY=0)) then
            if (vidHires='1') then     -- Bitmodus/Hires: color+pixel= "00" schwarz
                dispColor(5 downto 4) := (others => pixelShift(7)); -- "01" rot
                dispColor(3 downto 2) := (others => colorShift(7)); -- "10" tuerkis
                dispColor(1 downto 0) := (others => colorShift(7)); -- "11" weiss
            elsif (pixelShift(7)='1') and not (vidBlink='1' and colorData(7)='1') then -- vordergrund
                case colorData(6 downto 3) is   -- Bytemodus
                    when "0001" => dispColor := "000011"; -- blau
                    when "0010" => dispColor := "110000"; -- rot
                    when "0011" => dispColor := "110011"; -- purpur
                    when "0100" => dispColor := "001100"; -- gruen
                    when "0101" => dispColor := "001111"; -- tuerkis
                    when "0110" => dispColor := "111100"; -- gelb
                    when "0111" => dispColor := "111111"; -- weiss
                    when "1001" => dispColor := "100011"; -- violett
                    when "1010" => dispColor := "111000"; -- orange
                    when "1011" => dispColor := "110010"; -- purpurrot
                    when "1100" => dispColor := "001110"; -- gruenblau
                    when "1101" => dispColor := "001011"; -- blaugruen
                    when "1110" => dispColor := "101100"; -- gelbgruen
                    when "1111" => dispColor := "111111"; -- weiss
                    when others => dispColor := "000000"; -- schwarz
                end case;
            else -- hintergrund
                dispColor(1) := colorData(0); -- dunkelblau
                dispColor(5) := colorData(1); -- dunkelrot
                dispColor(3) := colorData(2); -- dunkelgruen
            end if;
            
            if (countH mod 16 = 0) then
 --               dispColor := "111111";
            end if;
        end if;

        if (DITHER_MODE=1) then
            if (ditherFlag = '1') then
                vgaRed   <= (others => dispColor(4));
                vgaGreen <= (others => dispColor(2));
                vgaBlue  <= (others => dispColor(0));
            else
                vgaRed   <= (others => dispColor(5));
                vgaGreen <= (others => dispColor(3));
                vgaBlue  <= (others => dispColor(1));
            end if;
        else
            -- LTSpice: 
            -- 11: 0.728V => 15
            -- 10: 0.391V => 0.391V/0.728V*15=8.06
            -- 00: 0
            vgaRed   <= dispColor(5 downto 4) & dispColor(4) & dispColor(4);
            vgaGreen <= dispColor(3 downto 2) & dispColor(2) & dispColor(2);
            vgaBlue  <= dispColor(1 downto 0) & dispColor(0) & dispColor(0);
        end if;

    end process;
end;