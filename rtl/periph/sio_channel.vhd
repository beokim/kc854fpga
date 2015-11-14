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
-- single sio channel
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 

entity sio_channel is
    port (
        clk     : in std_logic;
        res_n   : in std_logic;
        en      : in std_logic;
        
        dIn     : in std_logic_vector(7 downto 0);
        dOut    : out std_logic_vector(7 downto 0);
        
        rd_n    : in std_logic;
        
        cdSel   : in std_logic;
        
        int     : out std_logic_vector(2 downto 0);
        intAck  : in std_logic_vector(2 downto 0);
        intVect : out std_logic_vector(7 downto 0);
        intVectStatus : out std_logic;
        
        rxd     : in std_logic;
        txd     : out std_logic;
        rxTxClk : in std_logic
    );
end sio_channel;

architecture rtl of sio_channel is
    type regArray is array(0 to 7) of std_logic_vector(7 downto 0);

    signal regs     : regArray;
    signal preDiv   : integer range 0 to 15 := 0;
    signal rxTxClkDelay : std_logic := '0';
    
    signal txPreDiv : integer range 0 to 3 := 0;
    signal txStart  : boolean;
    signal txCnt    : integer range 0 to 11;
    signal txReg    : std_logic_vector(7 downto 0);
    signal txShift  : std_logic_vector(9 downto 0);
    signal txDone   : boolean;

    signal rxClkEn  : boolean;
    signal rxPreDiv : integer range 0 to 3 := 0;
    signal rxInShift : std_logic_vector(3 downto 0) := (others => '0');
    signal rxRcv    : boolean := false;
    signal rxShift  : std_logic_vector(8 downto 0) := (others => '1');
    
    signal rxFifoWr : std_logic := '0';
    signal rxFifoDataOut : std_logic_vector(7 downto 0);
    signal rxFifoRd : std_logic := '0';
    signal rxFifoEmpty : std_logic;
    
    signal nextReg  : integer range 0 to 7;
    signal currReg  : integer range 0 to 7;
    
    signal dataRead : boolean;
begin
    txd <= txShift(0);
    
    intVect <= regs(2); -- Interrupt Vector
    intVectStatus <= regs(1)(2); -- Status Affects Vector
    
    interrupt : process
    begin
        wait until rising_edge(clk);
        
        if (res_n='0' or regs(0)(5 downto 3)="011") then -- reset / Channel Reset
            int <= "000";
        else
            if (regs(1)(4 downto 3) /= "00" and rxFifoWr='1') then -- rx int
                int(0) <= '1';
            end if;

            if (regs(1)(1 downto 1) = "1" and txDone) then -- tx int
                int(1) <= '1';
            end if;
            
            for i in 0 to intAck'left -- reset int on ack
            loop
                if (intAck(i)='1') then
                    int(i) <= '0';
                end if;
            end loop;
        end if;
      
    end process;
    
    -- predivider
    divider : process
        variable topCount : integer range 0 to 63;
    begin
        wait until rising_edge(clk);
        
        rxTxClkDelay <= rxTxClk;
        
        case regs(4)(7 downto 6) is
            when "00" => topCount := 0;  --  X1 Clock Mode
            when "01" => topCount := 3;  -- X16 Clock Mode
            when "10" => topCount := 7;  -- X32 Clock Mode
            when "11" => topCount := 15; -- X64 Clock Mode
            when others => null; 
        end case;
        
        rxClkEn <= false;
         
        if (rxTxClkDelay='0' and rxTxClk='1') then -- L -> H: count
            if (preDiv = 0) then
                preDiv <= topCount;
                rxClkEn <= true;
            else
                preDiv <= preDiv - 1;
            end if;
        end if;
    end process;
    
    tx : process
        variable txClkEn : boolean;
    begin
        wait until rising_edge(clk);
        
        txDone <= false;
        
        txClkEn := false;
        
        if (rxClkEn) then
            if (txPreDiv=0) then
                txPreDiv <= 3;
                txClkEn := true;
            else
                txPreDiv <= txPreDiv - 1;
            end if;
        end if;
       
        if (res_n='0') then
            txShift <= (others => '1');
            txCnt <= 0;
            txPreDiv <= 3;
        elsif (txCnt = 0) then -- not transmitting?
            if (txStart) then -- start transmit
                txCnt <= 10;
                txShift <= txReg & "01";
            end if;
        else -- transmit in progress
            if (txClkEn) then 
                if (txCnt=1) then
                    txDone <= true;
                end if;

                txShift <= '1' & txShift(txShift'left downto 1);
                txCnt <= txCnt - 1;
            end if;
        end if;
    end process;
    
    rx : process
    begin
        wait until rising_edge(clk);
        
        rxFifoWr <= '0';
                    
        if (res_n='0') then
            rxRcv <= false;
        elsif (rxClkEn) then
            -- debounce input
            rxInShift <= rxInShift(rxInShift'left-1 downto 0) & rxd;

            if (rxRcv) then -- receive in progress
                if (rxPreDiv=0) then -- next bit
                    rxShift <= rxInShift(rxInShift'left) & rxShift(rxShift'left downto 1);
                    rxPreDiv <= 3;
                    if (rxShift(0)='0') then -- receive finished
                        rxRcv <= false;
                        rxFifoWr <= '1';
                    end if;
                else
                    rxPreDiv <= rxPreDiv - 1;
                end if;
            elsif (rxInShift(rxInShift'left)='1' and rxInShift(rxInShift'left-1)='0') then -- search for start bit
                rxRcv <= true;
                rxShift <= (others => '1');
                rxPreDiv <= 1; -- sync to middle of start
            end if;
        end if;
    end process;
    
    rxFifo : entity work.sio_fifo
    port map (
        clk       => clk,
        res_n     => res_n,
        
        dataIn    => rxShift(7 downto 0),
        dataOut   => rxFifoDataOut,
        
        rd        => rxFifoRd,
        wr        => rxFifoWr,
    
        fifoEmpty => rxFifoEmpty,
        fifoFull  => open,
        fifoOver  => open
    );

    cpuDataOut : process(txCnt, cdSel, rxFifoEmpty, currReg, rxFifoDataOut)
        variable txEmpty : std_logic;
    begin
        txEmpty := '0';
        if (txCnt=0) then
            txEmpty := '1';
        end if;
        
        if (cdSel='0') then
            dOut <= rxFifoDataOut;
        elsif (currReg=0) then
            dOut <= "00" & "1" & "00" & txEmpty & "0" & not rxFifoEmpty;
        else
            dOut <= (others => '0');
        end if;
    end process;
    
    cpuDataIn : process
        variable cmd : std_logic_vector(2 downto 0);
    begin
        wait until rising_edge(clk);
        
        if (res_n='0') then
            nextReg <= 0;
            currReg <= 0;
            txStart <= false;
            rxFifoRd <= '0';
            regs(1) <= (others => '0');
            dataRead <= false;
        elsif (en='1') then
            if (cdSel='1') then -- command
                if (rd_n='1') then -- SIO Write
                    regs(currReg) <= dIn;
                    
                    if (currReg=0) then -- cmd
                        case dIn(5 downto 3) is
                            when "010"  => null; -- Reset External/Status Interrupts
                            when "011"  => -- Channel Reset
                                  regs(1) <= (others => '0'); -- disable interrups 
                            when others => null;
                        end case;
                        
                        nextReg <= to_integer(unsigned(dIn(2 downto 0)));
                    else
                        nextReg <= 0;
                    end if;
                else -- SIO Read
                    nextReg <= 0;
                end if;
            else -- data
                if (rd_n='1') then -- SIO data write
                    txReg <= dIn;
                    txStart <= true;
                else  -- SIO data read
                    dataRead <= true;
                end if;
            end if;
        else -- disabled -> set currReg
            currReg <= nextReg;

            rxFifoRd <= '0';
            if (dataRead) then -- fifo next entry
                rxFifoRd <= '1';
                dataRead <= false;
            end if;
                    
            if (txCnt /= 0) then -- reset txStart
                txStart <= false;
            end if;
        end if;
    end process;
end;

    