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
-- Bruecke zwischen Video-Timing und Pixelgenerator und dem Rest des Systems
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity video is
    generic (
        DITHER_MODE : integer := 0
    );
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
        
        vidBlank  : in  std_logic;

        vidScanline : in  std_logic;
        
        test       : out std_logic_vector(3 downto 0)
    );
end video;

architecture rtl of video is
    constant KC_VIDLINES : integer := 312;

    type   ram_type is ( ramSync, ramAddr, ramRead );
    signal ramState         : ram_type := ramAddr;

    signal lineAddr         : integer range 0 to 40 := 0;
    signal row              : std_logic_vector(7 downto 0) := (others => '0');
    signal lineAddrSLV      : std_logic_vector(5 downto 0);
    
    signal vgaAddr          : std_logic_vector(5 downto 0);
    signal vgaData          : std_logic_vector(15 downto 0);
    signal vidNextLine      : std_logic_vector(2 downto 0);
    
    signal vidBlinkDelay    : std_logic_vector(1 downto 0) := "00";
    signal blinkDiv         : std_logic := '0';
    signal blinkDivEn       : std_logic;
    
    signal vidLine          : std_logic_vector(8 downto 0);
    
    signal vDisplay         : std_logic;
    
    signal kcVidLine        : integer range 0 to KC_VIDLINES-1 := 0;
    signal kcVidLineSLV     : std_logic_vector(8 downto 0);
    signal vgaBlink         : std_logic;

begin 
    -- Adresse im SRAM
    vidAddr <= std_logic_vector(to_unsigned(lineAddr,6)) & row;

    -- Steuerung fuer Zugriff auf SRAM und Scanline-Buffer
    mem : process
    begin
        wait until rising_edge(cpuclk);

        -- Signal aus der anderen Clockdomain einsynchronisieren...
        vidNextLine(vidNextLine'left-1 downto 0) <= vidNextLine(vidNextLine'left  downto 1);
        
        if (vidNextLine(0)='1') then -- naechste Zeile starten?
            row <= vidLine(7 downto 0);
            lineAddr <= 0; -- reset linebuffer + kopieren starten
            ramState <= ramSync;
        elsif (lineAddr < 40) then -- weitere Bytes kopieren?
            case ramState is
                when ramSync => -- mit memcontroller synchronisieren
                    if (vidBusy='0') then
                        ramState <= ramRead;
                    end if;
                when ramAddr =>
                    ramState <= ramRead;
                    lineAddr <= lineAddr + 1;
                when ramRead =>
                    if (vidRead='1') then
                        ramState <= ramAddr;
                    end if;
            end case;
        end if;
    end process;
    
    lineAddrSLV <= std_logic_vector(to_unsigned(lineAddr,6));
    
    -- Buffer fuer einzelne Scanline
    --  ueberbrueckt die beiden Clockdomains
    linebuffer : entity work.dualsram
    generic map (
        ADDRWIDTH => 6,
        DATAWIDTH => 16
    )
    port map (
        clk1   => cpuclk,
        clk2   => vidclk,
        addr1  => lineAddrSLV,
        addr2  => vgaAddr,
        din1   => vidData,
--        din1   => (others => '1'),
        din2   => "0000000000000000",
        dout1  => open,
        dout2  => vgaData,
        wr1_n  => '0',
        wr2_n  => '1',
        cs1_n  => '0',
        cs2_n  => '0'
    );
    
    vidBlinkDelay(0) <= vidBlink;

    -- Flankenerkennung und Flip-/Flop fuer Halbierung des Blinktaktes
    blink : process
    begin
        wait until rising_edge(cpuclk);
        vidBlinkDelay(1) <= vidBlinkDelay(0);
        
        if (vidBlinkEn='1') then
            if (vidBlinkDelay="01") then
                blinkDiv <= not blinkDiv;
            end if;
        else
            blinkDiv <= '1';
        end if;
    end process;
    
    -- Zeilenzaehler fuer KC-Seite
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
    
    vidLine(8) <= '0'; -- Zeilen auf VGA-Seite gehen nur von 0..255
    kcVidLineSLV <= std_logic_vector(to_unsigned(kcVidLine,kcVidLineSLV'length));
    
    -- Puffer fuer Blinksignal pro Videozeile
    blinkbuffer : entity work.dualsram
    generic map (
        ADDRWIDTH => 9,
        DATAWIDTH => 1
    )
    port map (
        clk1   => cpuclk,
        clk2   => vidclk,
        addr1  => kcVidLineSLV,
        addr2  => vidLine,
        din1(0) => blinkDiv,
        din2   => "0",
        dout1  => open,
        dout2(0)  => vgaBlink,
        wr1_n  => not vidH5ClkEn,
        wr2_n  => '1',
        cs1_n  => '0',
        cs2_n  => '0'
    );
    
 --   vgaRed <= (others => vidLine(0));
    -- Timing- und Pixelgenerator instanziieren
    vidgen : entity work.vidgen
    generic map (
        DITHER_MODE => DITHER_MODE
    )
    port map (
        vidclk   => vidclk,
        
        vgaRed   => vgaRed,
        vgaGreen => vgaGreen,
        vgaBlue  => vgaBlue,
        vgaHSync => vgaHSync,
        vgaVSync => vgaVSync,
        
        vgaAddr  => vgaAddr,
        vgaData  => vgaData,
        
        vidHires => vidHires,
        
        vidBlink => vgaBlink,
        
        vidBlank => vidBlank,
        
        vidScanline => vidScanline,
        
        vidNextLine => vidNextLine(vidNextLine'left),
        
        vidLine  => vidLine(7 downto 0),
        
        test => test
    );
    
end;