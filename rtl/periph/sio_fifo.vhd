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
-- 3 level fifo fuer SIO
--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sio_fifo is
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
end sio_fifo;

architecture rtl of sio_fifo is
    type byteArray is array (natural range <>) of std_logic_vector(7 downto 0);
    
    signal data         : byteArray(DEPTH-1 downto 0);

    signal writePtr     : integer range 0 to DEPTH-1 := 0;
    signal readPtr      : integer range 0 to DEPTH-1 := 0;
    signal nextWritePtr : integer range 0 to DEPTH-1 := 0;
    signal nextReadPtr  : integer range 0 to DEPTH-1 := 0;
    
    signal intFifoFull  : std_logic;
    signal intFifoEmpty : std_logic;
begin
    nextWritePtr <= writePtr+1 when writePtr<DEPTH-1 else 0;
    nextReadPtr  <= readPtr+1  when readPtr <DEPTH-1 else 0;
    fifoFull  <= intFifoFull;
    
    intFifoEmpty <= '1' when readPtr=writePtr else '0';
    fifoEmpty <= intFifoEmpty;
    
    fifo : process
    begin
        wait until rising_edge(clk);
        
        if (res_n='0') then -- teh reset
            writePtr <= 0;
            readPtr <= 0;
            fifoOver <= '0';
            intFifoFull <= '0';
        else
            if (wr='1') then
                data(writePtr) <= dataIn;
                
                if (intFifoFull='1') then -- fifo overrun -> next time overwrite data at last position
                    fifoOver <= '1';
                else
                    if (nextWritePtr=readPtr) then -- fifo full check
                        intFifoFull <= '1';
                    else -- else move write pointer
                        intFifoFull <= '0';
                        writePtr <= nextWritePtr;
                    end if;
                end if;
             end if;
             
            if (rd='1') then -- read when not empty
                if (intFifoEmpty='0') then
                    readPtr <= nextReadPtr;
                end if;
                intFifoFull <= '0';
            end if;
            
            dataOut <= data(readPtr);
        end if;
    end process;  
end;


