library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bootrom is
    generic(
        ADDR_WIDTH   : integer := 7
    );
    port (
        clk  : in std_logic;
        addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        data : out std_logic_vector(7 downto 0)
    );
end bootrom;

architecture rtl of bootrom is
    type rom128x8 is array (0 to 2**ADDR_WIDTH-1) of std_logic_vector(7 downto 0); 
    constant romData : rom128x8 := (
         x"01",  x"80",  x"08",  x"3e",  x"01",  x"ed",  x"79",  x"3e", -- 0000
         x"47",  x"d3",  x"0c",  x"3e",  x"01",  x"d3",  x"0c",  x"3e", -- 0008
         x"04",  x"d3",  x"0a",  x"3e",  x"03",  x"d3",  x"0a",  x"3e", -- 0010
         x"20",  x"d3",  x"0a",  x"3e",  x"05",  x"d3",  x"0a",  x"3e", -- 0018
         x"0a",  x"d3",  x"0a",  x"3e",  x"47",  x"d3",  x"0d",  x"3e", -- 0020
         x"01",  x"d3",  x"0d",  x"3e",  x"18",  x"d3",  x"0b",  x"3e", -- 0028
         x"02",  x"d3",  x"0b",  x"3e",  x"e2",  x"d3",  x"0b",  x"3e", -- 0030
         x"14",  x"d3",  x"0b",  x"3e",  x"44",  x"d3",  x"0b",  x"3e", -- 0038
         x"03",  x"d3",  x"0b",  x"3e",  x"e1",  x"d3",  x"0b",  x"3e", -- 0040
         x"05",  x"d3",  x"0b",  x"3e",  x"ea",  x"d3",  x"0b",  x"3e", -- 0048
         x"11",  x"d3",  x"0b",  x"3e",  x"18",  x"d3",  x"0b",  x"3e", -- 0050
         x"01",  x"d3",  x"09",  x"db",  x"0b",  x"cb",  x"57",  x"28", -- 0058
         x"fa",  x"3e",  x"80",  x"d3",  x"09",  x"0e",  x"a0",  x"db", -- 0060
         x"0b",  x"cb",  x"57",  x"28",  x"fa",  x"79",  x"d3",  x"09", -- 0068
         x"db",  x"0b",  x"cb",  x"47",  x"28",  x"fa",  x"db",  x"09", -- 0070
         x"4f",  x"0c",  x"18",  x"eb",  x"00",  x"00",  x"00",  x"00"  -- 0078
        );
    
begin
    process begin
        wait until rising_edge(clk);
        data <= romData(to_integer(unsigned(addr)));
    end process;
end;
