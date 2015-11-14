library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fifo is
    generic(
        DEPTH : integer := 3
    );
    port (
        clk       : in std_logic;
        res_n     : in std_logic;
        
        dataIn    : in std_logic_vector(7 downto 0);
        dataOut   : out std_logic_vector(7 downto 0);
        rd        : in std_logic;
        wr        : in std_logic;
        
        fifoEmpty : out std_logic;
        fifoFull  : out std_logic;
        fifoOver  : out std_logic
    );
end fifo;

architecture rtl of fifo is
    type byteArray is array (natural range <>) of std_logic_vector(7 downto 0);
    
    signal data         : byteArray(DEPTH-1 downto 0);

    signal writePtr     : integer range 0 to DEPTH-1 := 0;
    signal readPtr      : integer range 0 to DEPTH-1 := 0;
    signal nextWritePtr : integer range 0 to DEPTH-1 := 0;
    signal nextReadPtr  : integer range 0 to DEPTH-1 := 0;

    signal intFifoFull  : std_logic;
    signal intFifoLast : std_logic;
begin
    nextWritePtr <= writePtr+1 when writePtr<DEPTH-1 else 0;
    nextReadPtr  <= readPtr+1  when readPtr <DEPTH-1 else 0;
    
    intFifoLast <= '1' when writePtr=readPtr else '0';

    fifoFull  <= intFifoFull;
    
    fifo : process
    begin
        wait until rising_edge(clk);
        
        if (res_n='0') then -- teh reset
            writePtr <= 0;
            readPtr <= 0;
            fifoOver <= '0';
            intFifoFull <= '0';
            fifoEmpty <= '0';
        else
            if (wr='1') then
                data(writePtr) <= dataIn;
                fifoEmpty <= '0';
                
                if (intFifoFull='1') then -- fifo overrun -> overwrite data at last position
                    fifoOver <= '1';
                else
                    if nextWritePtr=readPtr then -- fifo full check
                        intFifoFull <= '1';
                    else -- else move write pointer
                        intFifoFull <= '0'; 
                        writePtr <= nextWritePtr;
                    end if;
                end if;
             end if;
             
            if (rd='1') then -- read when not empty
                if (intFifoLast='0') then
                    readPtr <= nextReadPtr;
                else
                    fifoEmpty <= '1';
                end if;
                dataOut <= data(readPtr);
                intFifoFull <= '0';
            end if;
        end if;
    end process;  
end;
