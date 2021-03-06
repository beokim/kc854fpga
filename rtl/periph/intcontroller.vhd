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
-- more complete interrupt controller
-- currently under test
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity intController is
    generic (
        NUMINTS : integer := 8
    );
    port (
        clk       : in std_logic;
        res_n     : in std_logic;
        
        int_n     : out std_logic;
        intPeriph : in std_logic_vector(NUMINTS-1 downto 0);
        intAck    : out std_logic_vector(NUMINTS-1 downto 0);
        
        m1_n      : in std_logic;
        iorq_n    : in std_logic;
        rd_n      : in std_logic;
        reti_n    : in std_logic;
        
        intEna_n  : in std_logic
    );
end intController;

architecture rtl of intController is
    constant zeroVect   : std_logic_vector(NUMINTS-1 downto 0) := (others => '0');
    
    signal int          : std_logic_vector(NUMINTS-1 downto 0);
    signal intMask      : std_logic_vector(NUMINTS-1 downto 0);
    
    signal intAckFF     : std_logic_vector(NUMINTS-1 downto 0);
    signal intAckMask   : std_logic_vector(NUMINTS-1 downto 0);
    
    signal currentInt   : std_logic_vector(NUMINTS-1 downto 0);
--    signal currentIntAck : std_logic_vector(NUMINTS-1 downto 0);
    
--    type controllerStates is (idle, intAccepted, waitForRetiEnd, waitForM1, finishInt);
--    signal state         : controllerStates := idle;
    
    signal resetInt     : boolean := false;
    signal retiEdgeDet  : std_logic_vector(1 downto 0) := "11";
    
begin
    intAck <= currentInt when m1_n='0' and iorq_n='0' else (others => '0');
  
    int_mask : process(int,intAckFF)
    begin
        intMask <= (others => '0');
        for i in 0 to NUMINTS-1 -- 0 is highest prio
        loop
            if intAckFF(i)='1' then
                exit;
            end if;
            
            if int(i)='1' then
                intMask(i) <= '1';
                exit;
            end if;
        end loop;
    end process;
    
    ack_mask : process(intAckFF)
    begin
        intAckMask <= (others => '0');
        for i in 0 to NUMINTS-1 -- 0 is highest prio
        loop
            if intAckFF(i)='1' then
                intAckMask(i) <= '1';
                exit;
            end if;
        end loop;
    end process;
    
    process
        variable intResetMask : std_logic_vector(NUMINTS-1 downto 0);
    begin
        wait until rising_edge(clk);
    
        if (res_n='0') then
--            state <= idle;
            int_n <= '1';
            
            int <= zeroVect;
            intAckFF <= zeroVect;
            currentInt <= zeroVect;
--            currentIntAck <= zeroVect;
            
            resetInt <= false;
            
            retiEdgeDet <= "11";
            
        else
            intResetMask := (others => '1');
            
            if (m1_n='1') then
                retiEdgeDet <= retiEdgeDet(0) & reti_n;
                
                if (resetInt) then
                    int_n <= '1';
                    currentInt <= zeroVect;
                end if;
                
                if intMask /= zeroVect then -- new int + update to higher prio until int ack
                    int_n <= '0';
                    currentInt <= intMask;
                end if;
                
                if (retiEdgeDet="01") then
                    intAckFF <= intAckFF and not intAckMask;
                end if;
            else
                if iorq_n='0' then -- int ack
                    intAckFF <= intAckFF or currentInt;
                    resetInt <= true;
                    intResetMask := not currentInt; -- reset current int
                end if;
            end if;
            
            int <= (int and intResetMask) or intPeriph;
        end if;
        
    end process;
    
end;