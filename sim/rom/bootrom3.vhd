library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bootrom is
    generic(
        ADDR_WIDTH   : integer := 6
    );
    port (
        clk  : in std_logic;
        addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        data : out std_logic_vector(7 downto 0)
    );
end bootrom;

architecture rtl of bootrom is
    type rom64x8 is array (0 to 2**ADDR_WIDTH-1) of std_logic_vector(7 downto 0); 
    constant romData : rom64x8 := (
         x"c3",  x"03",  x"40",  x"31",  x"00",  x"c0",  x"3e",  x"4f", -- 0000
         x"d3",  x"8a",  x"3e",  x"1f",  x"d3",  x"88",  x"3e",  x"0f", -- 0008
         x"d3",  x"8a",  x"3e",  x"08",  x"d3",  x"84",  x"3e",  x"80", -- 0010
         x"d3",  x"86",  x"3e",  x"01",  x"21",  x"00",  x"00",  x"77", -- 0018
         x"7e",  x"3c",  x"26",  x"80",  x"77",  x"7e",  x"3c",  x"26", -- 0020
         x"c0",  x"77",  x"7e",  x"3c",  x"26",  x"e0",  x"77",  x"7e", -- 0028
         x"3e",  x"9f",  x"d3",  x"88",  x"3c",  x"26",  x"c0",  x"77", -- 0030
         x"7e",  x"3c",  x"26",  x"e0",  x"77",  x"7e",  x"18",  x"fe"  -- 0038
        );
    
begin
    process begin
        wait until rising_edge(clk);
        data <= romData(to_integer(unsigned(addr)));
    end process;
end;
