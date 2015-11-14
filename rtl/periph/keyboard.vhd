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
-- Keyboard Keymapping und Transmit-Logik
--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 

entity keyboard is
    generic (
        SYS_CLK : integer := 50_000_0
    );
    port (
        clk     : in std_logic;
        res_n   : in std_logic;
        
        ps2clk  : inout std_logic;
        ps2data : inout std_logic;
        
        remo    : out std_logic;
        
        ps2code : out std_logic_vector(7 downto 0);
        kcKey   : out std_logic_vector(7 downto 0);
        kcKeydown : out std_logic;
        ps2shift : out std_logic
        
    );
end keyboard;

architecture rtl of keyboard is
    constant MAX_DIV : integer := SYS_CLK / (62_5) * 64 - 1;
    
    signal clockDiv  : integer range 0 to MAX_DIV := 0;
    --  5: 0 Bit
    --  7: 1 Bit
    -- 14: Wortabstand
    -- 19: Doppelwortabstand
    signal pulseCnt  : integer range 0 to 18 := 0;
    
    signal keyClockEn : boolean;
    
    signal scancode  : std_logic_vector(7 downto 0);
    signal keyShift  : std_logic_vector(7 downto 0) := "00000000";
    signal key       : std_logic_vector(7 downto 0) := "10000000";
    
    signal rcvd      : std_logic;
    
    signal rshift    : boolean := false;
    signal lshift    : boolean := false;
    signal altkey    : boolean := false;

    
    signal breakcode : boolean;
    signal keydown   : boolean;
    signal keydownDelayed : boolean;
    signal keyRepeat : boolean := false;
    signal keycode   : std_logic_vector(7 downto 0);

    signal iKey      : integer range 0 to 128 := 0;
begin
    key <= std_logic_vector(to_unsigned(iKey,8));
--    kcKey <= std_logic_vector(to_unsigned(iKey / 10,4)) & std_logic_vector(to_unsigned(iKey mod 10,4));
    kcKey <= std_logic_vector(to_unsigned(iKey, 8));
    kcKeydown <= '1' when keydown else '0';
    ps2code <= keycode;
    ps2shift <= '1' when lshift or rshift else '0';
    
    ps2if : entity work.ps2if
    generic map (
        SYS_CLK => SYS_CLK * 100
    )
    port map (
        clk     => clk,
        res     => '1',
        ps2clk  => ps2clk,
        ps2data => ps2data,
        data    => scancode,
        error   => open,
        rcvd    => rcvd
    );
    
    keystates : process
    begin
        wait until rising_edge(clk);

        if (rcvd='1') then
            if scancode=x"F0" then -- keyup => break-code
                breakcode <= true;
                keydown <= false; 
            else -- keyevent
                breakcode <= false;
        
                if (scancode = x"59") then -- shift rechts
                    rshift <= not breakcode;
                elsif (scancode = x"12") then -- shift links
                    lshift <= not breakcode;
                elsif (scancode = x"11") then -- alt / alt gr
                    altkey <= not breakcode;
                elsif (scancode /= x"e0" and scancode /= x"e1") then -- e0/e1 ignorieren
                    keydown <= not breakcode;
                    keycode <= scancode;
                end if;
            end if;
        end if;
    end process;
    
    decodekeys : process(keycode,rshift,lshift,keydown,altkey)
--    decodekeys : process
        variable shift : std_logic;
        variable alt   : std_logic;
    begin
--        wait until rising_edge(clk);
        
        shift := '1';
        if (lshift or rshift) then
            shift := '0';
        end if;
     
        alt := '0';
        if (altkey) then
            alt := '1';
        end if;
        
        keydownDelayed <= keydown;
     
        case alt & shift & keycode is
            when '0' & '0' & x"1d"  => iKey <= 0;   -- W
            when '0' & '1' & x"1d"  => iKey <= 1;   -- w
            when '0' & '0' & x"1c"  => iKey <= 2;   -- A
            when '0' & '1' & x"1c"  => iKey <= 3;   -- a
            when '0' & '0' & x"1e"  => iKey <= 4;   -- 2
            when '0' & '1' & x"1e"  => iKey <= 5;   -- "
            when '0' & '0' & x"6b"  => iKey <= 6;   -- Cursor links
            when '0' & '1' & x"6b"  => iKey <= 7;   -- CCR
            when '0' & '0' & x"6c"  => iKey <= 8;   -- Home
            when '0' & '1' & x"6c"  => iKey <= 9;   -- CLS
            when '0' & '0' & x"07"  => iKey <= 8;   -- F12 -> Home
            when '0' & '1' & x"07"  => iKey <= 9;   -- F12 -> CLS
            when '0' & '0' & x"45"  => iKey <= 10;  -- =
            when '0' & '1' & x"4a"  => iKey <= 11;  -- -
            when '0' & '0' & x"06"  => iKey <= 12;  -- F2
            when '0' & '1' & x"06"  => iKey <= 13;  -- F8
            when '0' & '0' & x"1a"  => iKey <= 14;  -- Y
            when '0' & '1' & x"1a"  => iKey <= 15;  -- y
            when '0' & '0' & x"24"  => iKey <= 16;  -- E
            when '0' & '1' & x"24"  => iKey <= 17;  -- e
            when '0' & '0' & x"1b"  => iKey <= 18;  -- S
            when '0' & '1' & x"1b"  => iKey <= 19;  -- s
            when '0' & '1' & x"5d"  => iKey <= 20;  -- #
            when '0' & '1' & x"26"  => iKey <= 21;  -- 3
            when '0' & '0' & x"0e"  => iKey <= 22;  -- ]
            when '0' & '1' & x"0e"  => iKey <= 23;  -- ^
            when '0' & '0' & x"78"  => iKey <= 24;  -- CLR -> F11
            when '0' & '1' & x"78"  => iKey <= 25;  -- CLR -> F11
            when '0' & '0' & x"5b"  => iKey <= 26;  -- *
            when '0' & '0' & x"49"  => iKey <= 27;  -- :
            when '0' & '0' & x"04"  => iKey <= 28;  -- F3
            when '0' & '1' & x"04"  => iKey <= 29;  -- F3
            when '0' & '0' & x"22"  => iKey <= 30;  -- X
            when '0' & '1' & x"22"  => iKey <= 31;  -- x
            when '0' & '0' & x"2c"  => iKey <= 32;  -- T
            when '0' & '1' & x"2c"  => iKey <= 33;  -- t
            when '0' & '0' & x"2b"  => iKey <= 34;  -- F
            when '0' & '1' & x"2b"  => iKey <= 35;  -- f
            when '0' & '0' & x"2e"  => iKey <= 36;  -- 5
            when '0' & '1' & x"2e"  => iKey <= 37;  -- %
            when '0' & '0' & x"4d"  => iKey <= 38;  -- P
            when '0' & '1' & x"4d"  => iKey <= 39;  -- p
            when '0' & '0' & x"71"  => iKey <= 40;  -- DEL (ENTF)
            when '0' & '1' & x"71"  => iKey <= 41;  -- 
            when '0' & '0' & x"66"  => iKey <= 40;  -- DEL (Backspace)
            when '0' & '1' & x"66"  => iKey <= 41;  --
            when '0' & '0' & x"09"  => iKey <= 40;  -- F10 -> DEL
            when '0' & '1' & x"09"  => iKey <= 41;  --
            when '1' & '1' & x"15"  => iKey <= 42;  -- @ (Alt (Gr)+Q)
            when '0' & '1' & x"45"  => iKey <= 43;  -- 0
            when '0' & '0' & x"03"  => iKey <= 44;  -- F5
            when '0' & '1' & x"03"  => iKey <= 45;  --  
            when '0' & '0' & x"2a"  => iKey <= 46;  -- V
            when '0' & '1' & x"2a"  => iKey <= 47;  -- v
            when '0' & '0' & x"3c"  => iKey <= 48;  -- U
            when '0' & '1' & x"3c"  => iKey <= 49;  -- u
            when '0' & '0' & x"33"  => iKey <= 50;  -- H
            when '0' & '1' & x"33"  => iKey <= 51;  -- h
            when '0' & '1' & x"55"  => iKey <= 52;  -- ´            
            when '0' & '1' & x"3d"  => iKey <= 53;  -- 7
            when '0' & '0' & x"44"  => iKey <= 54;  -- O
            when '0' & '1' & x"44"  => iKey <= 55;  -- o
            when '0' & '0' & x"70"  => iKey <= 56;  -- INS
            when '0' & '1' & x"70"  => iKey <= 57;  --
            when '0' & '0' & x"01"  => iKey <= 56;  -- F9 -> INS
            when '0' & '1' & x"01"  => iKey <= 57;  -- 
            when '0' & '0' & x"46"  => iKey <= 58;  -- 9
            when '0' & '1' & x"46"  => iKey <= 59;  -- )
            when '0' & '0' & x"77"  => iKey <= 60;  -- BRK
            when '0' & '1' & x"77"  => iKey <= 61;  --
            when '0' & '0' & x"83"  => iKey <= 60;  -- F7 -> BRK
            when '0' & '1' & x"83"  => iKey <= 61;  -- 
            when '0' & '0' & x"31"  => iKey <= 62;  -- N
            when '0' & '1' & x"31"  => iKey <= 63;  -- n
            when '0' & '0' & x"43"  => iKey <= 64;  -- I
            when '0' & '1' & x"43"  => iKey <= 65;  -- i
            when '0' & '0' & x"3b"  => iKey <= 66;  -- J
            when '0' & '1' & x"3b"  => iKey <= 67;  -- j
            when '0' & '0' & x"3e"  => iKey <= 68;  -- 8
            when '0' & '1' & x"3e"  => iKey <= 69;  -- (
            when '0' & '0' & x"29"  => iKey <= 70;  -- SPC
            when '0' & '1' & x"29"  => iKey <= 71;  -- 
            when '0' & '0' & x"42"  => iKey <= 72;  -- K
            when '0' & '1' & x"42"  => iKey <= 73;  -- k
            when '0' & '1' & x"61"  => iKey <= 74;  -- <            
            when '0' & '1' & x"41"  => iKey <= 75;  -- ,
            when '0' & '0' & x"76"  => iKey <= 76;  -- ESC
            when '0' & '1' & x"76"  => iKey <= 77;  -- STOP
            when '0' & '0' & x"0a"  => iKey <= 76;  -- F8 (STOP/ESC)
            when '0' & '1' & x"0a"  => iKey <= 77;  -- 
            when '0' & '0' & x"3a"  => iKey <= 78;  -- M
            when '0' & '1' & x"3a"  => iKey <= 79;  -- m
            when '0' & '0' & x"35"  => iKey <= 80;  -- Z
            when '0' & '1' & x"35"  => iKey <= 81;  -- z
            when '0' & '0' & x"34"  => iKey <= 82;  -- G
            when '0' & '1' & x"34"  => iKey <= 83;  -- g
            when '0' & '0' & x"36"  => iKey <= 84;  -- 6
            when '0' & '1' & x"36"  => iKey <= 85;  -- &
     --           when '0' & '0' & x"??"  => iKey <= 86;  -- 
     --           when '0' & '1' & x"??"  => iKey <= 87;  -- 
            when '0' & '0' & x"4b"  => iKey <= 88;  -- L
            when '0' & '1' & x"4b"  => iKey <= 89;  -- l
            when '0' & '0' & x"61"  => iKey <= 90;  -- >            
            when '0' & '1' & x"49"  => iKey <= 91;  -- .
            when '0' & '0' & x"0b"  => iKey <= 92;  -- F6
            when '0' & '1' & x"0b"  => iKey <= 93;  -- 
            when '0' & '0' & x"32"  => iKey <= 94;  -- B
            when '0' & '1' & x"32"  => iKey <= 95;  -- b
            when '0' & '0' & x"2d"  => iKey <= 96;  -- R
            when '0' & '1' & x"2d"  => iKey <= 97;  -- r
            when '0' & '0' & x"23"  => iKey <= 98;  -- D
            when '0' & '1' & x"23"  => iKey <= 99;  -- d
            when '0' & '0' & x"25"  => iKey <= 100; -- 4
            when '0' & '1' & x"25"  => iKey <= 101; -- $
            when '0' & '0' & x"5d"  => iKey <= 102; -- |
            when '1' & '1' & x"61"  => iKey <= 102; -- |           
            when '0' & '0' & x"4a"  => iKey <= 103; -- _
            when '0' & '0' & x"41"  => iKey <= 104; -- ;            
            when '0' & '1' & x"5b"  => iKey <= 105; -- +
            when '0' & '0' & x"4e"  => iKey <= 106; -- ?
            when '0' & '0' & x"3d"  => iKey <= 107; -- /
            when '0' & '0' & x"0c"  => iKey <= 108; -- F4
            when '0' & '1' & x"0c"  => iKey <= 109; -- 
            when '0' & '0' & x"21"  => iKey <= 110; -- C
            when '0' & '1' & x"21"  => iKey <= 111; -- c
            when '0' & '0' & x"15"  => iKey <= 112; -- Q
            when '0' & '1' & x"15"  => iKey <= 113; -- q
            when '0' & '0' & x"58"  => iKey <= 114; -- Shift Lock
            when '0' & '1' & x"58"  => iKey <= 115; -- 
            when '0' & '0' & x"16"  => iKey <= 116; -- 1
            when '0' & '1' & x"16"  => iKey <= 117; -- !
            when '0' & '0' & x"72"  => iKey <= 118; -- Cursor down
            when '0' & '1' & x"72"  => iKey <= 119; -- 
            when '0' & '0' & x"75"  => iKey <= 120; -- Cursor up
            when '0' & '1' & x"75"  => iKey <= 121; -- 
            when '0' & '0' & x"74"  => iKey <= 122; -- Cursor rechts
            when '0' & '1' & x"74"  => iKey <= 123; -- 
            when '0' & '0' & x"05"  => iKey <= 124; -- F1
            when '0' & '1' & x"05"  => iKey <= 125; -- 
            when '0' & '0' & x"5a"  => iKey <= 126; -- <Enter>
            when '0' & '1' & x"5a"  => iKey <= 127; -- 
            when others => iKey <= 128; -- no key
        end case;
    end process;
    
    -- clock fuer ausgang -> 1024Hz
    divider : process
    begin
        wait until rising_edge(clk);

        if (clockDiv < MAX_DIV) then
            clockDiv <= clockDiv + 1;
            keyClockEn <= false;
        else
            clockDiv <= 0;
            keyClockEn <= true;
        end if;
    end process;
    
    -- keycode auf den ausgang schieben
    shiftout : process
    begin
        wait until rising_edge(clk);
        
        if (keyClockEn) then
            if (pulseCnt>0) then
                pulseCnt <= pulseCnt - 1;
                remo <= '0';
            elsif (keyShift /= "00000000") then
                if (keyShift="00000001") then -- letztes bit
                    pulseCnt <= 13; -- -> Wortabstand
                elsif (keyShift(0)='1') then
                    pulseCnt <= 6; -- 1 Bit
                else
                    pulseCnt <= 4; -- 0 Bit
                end if;
                
                keyShift <= '0' & keyShift(7 downto 1);
                remo <= '1';
            elsif ((keydownDelayed and key(7)='0') or keyRepeat) then
                keyShift <= '1' & key(6 downto 0);
                keyRepeat <= keydownDelayed;
            end if;
        end if;
    end process;
end;