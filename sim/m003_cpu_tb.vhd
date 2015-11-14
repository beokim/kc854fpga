library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity m003_cpu_tb is
end m003_cpu_tb;

architecture sim of m003_cpu_tb is
    signal cpuReset_n   : std_logic := '0';
    
    signal cpuclk       : std_logic := '0';
    signal sysclk       : std_logic := '0';
  
    signal cpuAddr      : std_logic_vector(15 downto 0);
    signal cpuDataIn    : std_logic_vector(7 downto 0);
    signal cpuDataOut   : std_logic_vector(7 downto 0);
    signal cpuEn        : std_logic;
    signal cpuWait      : std_logic;
    
    signal cpuInt_n     : std_logic;
    signal cpuM1_n      : std_logic;
    signal cpuMReq_n    : std_logic;
    signal cpuRfsh_n    : std_logic;
    signal cpuIorq_n    : std_logic;
    signal cpuRD_n      : std_logic;
    signal cpuWR_n      : std_logic;
    signal cpuRETI      : std_logic;
    
    signal romData      : std_logic_vector(7 downto 0);
    
    signal m003DataOut  : std_logic_vector(7 downto 0);
    signal m003Sel      : std_logic;

    
    signal intPeriph    : std_logic_vector(15 downto 0) := (others => '0');
    signal intAckPeriph : std_logic_vector(15 downto 0) := (others => '0');
    
    signal LEDR         : std_logic_vector(9 downto 0);
    signal UART_RXD     : std_logic;
    signal UART_TXD     : std_logic;
    
begin
    cpuclk <= not cpuclk after 10 ns;
    sysclk <= not sysclk after 20 ns;
    
    cpuReset_n <= '0' , '1' after 30 ns;
    
    cpuEn <= '1';
    cpuWait <= '1';
    cpuInt_n  <= '1';
    
    UART_RXD <= UART_TXD;
    
    cpu : entity work.T80se
    generic map(Mode => 1, T2Write => 1, IOWait => 0)
    port map(
        RESET_n => cpuReset_n,
        CLK_n   => cpuclk,
        CLKEN   => cpuEn,
        WAIT_n  => cpuWait,
        INT_n   => cpuInt_n,
        NMI_n   => '1',
        BUSRQ_n => '1',
        M1_n    => cpuM1_n,
        MREQ_n  => cpuMReq_n,
        IORQ_n  => cpuIorq_n,
        RD_n    => cpuRD_n,
        WR_n    => cpuWR_n,
        RFSH_n  => cpuRfsh_n,
        HALT_n  => open,
        BUSAK_n => open,
        A       => cpuAddr,
        DI      => cpuDataIn,
--        DI      => cpuDataIn,
        DO      => cpuDataOut,
        RETI_n  => cpuRETI
    );
    
    cpuDataIn <= 
            m003DataOut when m003Sel='1' or intAckPeriph(15 downto 6) /= "0000000000" else
            romData;
    
    bootrom : entity work.bootrom
    port map (
        clk      => cpuclk,
        addr     => cpuAddr(6 downto 0),
        data     => romData
    );
    
    m003 : entity work.m003
    port map (
        clk      => cpuclk,
        sysClkEn => sysclk,
        
        res_n    => cpuReset_n,
        
        addr     => cpuAddr,
        dIn      => cpuDataOut,
        dOut     => m003DataOut,
        
        modSel   => m003Sel,
        modEna   => LEDR(9),
        
        m1_n     => cpuM1_n,
        mreq_n   => cpuMREQ_n,
        iorq_n   => cpuIORQ_n,
        rd_n     => cpuRD_n,
        
        int      => intPeriph(15 downto 6),
        intAck   => intAckPeriph(15 downto 6),
        
        aRxd     => '1',
        aTxd     => open,
        bRxd     => UART_RXD,
        bTxd     => UART_TXD
    );
end;