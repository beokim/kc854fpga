library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fifo_tb is
end fifo_tb;

architecture sim of fifo_tb is
    signal clk        : std_logic := '0';
    signal res_n      : std_logic;
    signal dataIn     : std_logic_vector(7 downto 0);
    signal rd         : std_logic;
    signal wr         : std_logic;
    
    type testVectDataType is record 
        res_n  : std_logic;
        rd     : std_logic;
        wr     : std_logic;
        dataIn : std_logic_vector(7 downto 0);
    end record;
    
    type testVectType is array(0 to 27) of testVectDataType;
    signal testVect : testVectType;
    signal testVectIdx : integer := 0;
begin
    testVect <= (
      ( '0', '0', '0', x"00" ),
      ( '1', '0', '0', x"00" ),
      ( '1', '0', '1', x"00" ),
      ( '1', '0', '0', x"00" ),
      ( '1', '0', '1', x"01" ),
      ( '1', '0', '1', x"02" ),
      ( '1', '0', '0', x"00" ),
      ( '1', '1', '0', x"00" ),
      ( '1', '0', '0', x"00" ),
      ( '1', '0', '1', x"03" ),
      ( '1', '0', '1', x"04" ),
      ( '1', '0', '0', x"00" ),
      ( '1', '0', '1', x"05" ),
      ( '1', '0', '1', x"06" ),
      ( '1', '0', '0', x"00" ),
      ( '1', '0', '1', x"07" ),
      ( '1', '0', '1', x"08" ),
      ( '1', '0', '0', x"00" ),
      ( '1', '0', '0', x"00" ),
      ( '1', '1', '0', x"00" ),
      ( '1', '0', '0', x"00" ),
      ( '1', '1', '0', x"00" ),
      ( '1', '0', '0', x"00" ),
      ( '1', '1', '0', x"00" ),
      ( '1', '1', '0', x"00" ),
      ( '1', '0', '0', x"00" ),
      ( '1', '1', '0', x"00" ),
      ( '1', '0', '0', x"00" )
    );
    
    clk <= not clk after 10 ns;
    
    process
    begin
        wait until rising_edge(clk);
        
        if (testVectIdx<testVect'right) then
            testVectIdx <= testVectIdx + 1;
        else
            testVectIdx <= 0;
        end if;  
    end process;
    
    res_n  <= testVect(testVectIdx).res_n;
    rd     <= testVect(testVectIdx).rd;
    wr     <= testVect(testVectIdx).wr;
    dataIn <= testVect(testVectIdx).dataIn;
    
    fifo1 : entity work.fifo
    port map (
        clk       => clk,
        res_n     => res_n,
        
        dataIn    => dataIn,
        dataOut   => open,
        rd        => rd,
        wr        => wr,
        
        fifoEmpty => open,
        fifoFull  => open,
        fifoOver  => open
     );
     
    fifo2 : entity work.sio_fifo
    port map (
        clk       => clk,
        res_n     => res_n,
        
        dataIn    => dataIn,
        dataOut   => open,
        rd        => rd,
        wr        => wr,
        
        fifoEmpty => open,
        fifoFull  => open,
        fifoOver  => open
     );  
end;