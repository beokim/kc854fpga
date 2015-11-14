library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity m003_tb is
end m003_tb;

architecture sim of m003_tb is
    type testVectDataType is record 
        addr : std_logic_vector(15 downto 0);
        data : std_logic_vector(7 downto 0);
        wr   : std_logic;
    end record;
   
    type testVectType is array(0 to 29) of testVectDataType;
    
    signal testVect : testVectType;
    
    signal testVectIdx : integer := 0;
    
    signal clk    : std_logic := '0';
    signal sysclk : std_logic := '0';
    signal reset_n : std_logic := '0';
    signal iorq_n : std_logic := '1';
    signal rd_n   : std_logic := '1'; 
    signal m1_n   : std_logic := '1'; 
    signal mreq_n : std_logic := '1'; 
    
    signal intPeriph : std_logic_vector(15 downto 0) := (others => '0');
    signal intAckPeriph : std_logic_vector(15 downto 0) := (others => '0');
    
    signal m003DataOut : std_logic_vector(7 downto 0);
    signal m003Sel : std_logic;
    signal m003Ena : std_logic;
    signal UART_RXD : std_logic := '1';
    signal UART_TXD : std_logic;
    
    signal testAddr : std_logic_vector(15 downto 0);
    signal testData : std_logic_vector(7 downto 0);
    signal testRd   : std_logic;
    
    signal finished : boolean := false;
    
begin
    testVect <= (
        (x"0880", x"01", '1'), -- modul einschalten
        (x"000c", x"47", '1'), -- counter + tc follows + reset
--        (x"000c", x"5b", '1'), -- tc
        (x"000c", x"01", '1'), -- tc
        (x"000e", x"05", '1'), -- timer + tc follows + reset
        (x"000e", x"21", '1'), -- tc
        (x"000a", x"04", '1'), -- write reg 4
        (x"000a", x"04", '1'), -- x1 clock mode + + 1 stop bit + no parity
        (x"000a", x"03", '1'), -- write reg 3
        (x"000a", x"20", '1'), -- 5 bit + auto enables 
        (x"000a", x"05", '1'), -- write reg 5
        (x"000a", x"0a", '1'), -- TX en + RTS en
        (x"000d", x"47", '1'), -- counter + tc follows + reset
--        (x"000d", x"2e", '1'), -- tc
        (x"000d", x"01", '1'), -- tc
        (x"000b", x"18", '1'), -- cmd: channel reset
        (x"000b", x"02", '1'), -- write reg 2
        (x"000b", x"e2", '1'), -- int vector
        (x"000b", x"14", '1'), -- reset ext/channel int + write reg 4
        (x"000b", x"44", '1'), -- 16x clock mode + 1 stop bit + no parity
        (x"000b", x"03", '1'), -- write reg 3
        (x"000b", x"e1", '1'), -- 8 bit + auto enables + rx enable
        (x"000b", x"05", '1'), -- write reg 5
        (x"000b", x"ea", '1'), -- DTR en + external sync mode + Tx en + RTS
        (x"000b", x"11", '1'), -- cmd: reset ext/channel int + write reg 1
        (x"000b", x"18", '1'), -- INT on All Rx Characters (Parity Does Not Affect Vector) + status affects vector off + tx int off
        (x"000b", x"18", '0'), -- rr0 lesen -> 0x24
        (x"0009", x"01", '1'), -- zeichen versenden
        (x"000b", x"18", '0'), -- rr0 lesen -> 0x24
        (x"0009", x"02", '1'), -- zeichen versenden
        (x"000b", x"18", '0'), -- rr0 lesen -> 0x24
--        (x"0009", x"00", '0')  -- zeichen lesen 
        (x"0009", x"00", '1')  -- zeichen versenden
    );
    
    intPeriph(5 downto 0) <= (others => '0');
    
    intAckPeriph(9) <= '1' after 20000 ns,
             	         '0' after 20100 ns,
             	         '1' after 45000 ns,
             	         '0' after 45100 ns;
    
    clk <= not clk after 10 ns;
    sysclk <= not sysclk after 20 ns;
    
    reset_n <= '1' after 40 ns;
    
    process
    begin
        if (reset_n='1') then
        
            wait for 20 ns;
            rd_n   <= '0';
            iorq_n <= '0';
            m1_n   <= '1';
            
            wait for 20 ns;
            rd_n   <= '1';
            m1_n   <= '1';
            iorq_n <= '1';
            
            wait for 20 ns;
        
            if (testVectIdx<testVect'right) then
                testVectIdx <= testVectIdx + 1;
            else
                finished <= true;
                testVectIdx <= testVectIdx - 3;
            end if;
        end if;
        
        wait for 40 ns;
    end process;

    testAddr <= testVect(testVectIdx).addr;
    testData <= testVect(testVectIdx).data;
    testRd   <= testVect(testVectIdx).wr or rd_n;
    
    m003 : entity work.m003
    port map (
        clk      => clk,
        sysClkEn => sysclk,
        
        res_n    => reset_n,
        
        addr     => testAddr,
        dIn      => testData,
        dOut     => m003DataOut,
        
        modSel   => m003Sel,
        modEna   => m003Ena,
        
        m1_n     => m1_n,
        mreq_n   => mreq_n,
        iorq_n   => iorq_n,
        rd_n     => testRd,
        
        int      => intPeriph(15 downto 6),
        intAck   => intAckPeriph(15 downto 6),
        
        aRxd     => '1',
        aTxd     => open,
        bRxd     => UART_TXD,
        bTxd     => UART_TXD
    );
end;
  