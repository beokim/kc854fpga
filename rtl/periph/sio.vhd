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
-- z80 sio
--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 

entity sio is
    port (
        clk      : in std_logic;
        res_n    : in std_logic;
        cs_n     : in std_logic;
        
        dIn      : in std_logic_vector(7 downto 0);
        dOut     : out std_logic_vector(7 downto 0);
        
        rd_n     : in std_logic;
        iorq_n   : in std_logic;
        m1_n     : in std_logic;
        baSel    : in std_logic;
        cdSel    : in std_logic;
        
        int      : out std_logic_vector(5 downto 0);
        intAck   : in std_logic_vector(5 downto 0);
        
        aRxd     : in std_logic;
        aTxd     : out std_logic;
        aRxTxClk : in std_logic;
        
        bRxd     : in std_logic;
        bTxd     : out std_logic;
        bRxTxClk : in std_logic
    );
end sio;

architecture rtl of sio is
    type byteArray is array (natural range <>) of std_logic_vector(7 downto 0);

    signal sioDataOut : byteArray(1 downto 0);
    
    signal sioIntVect : byteArray(1 downto 0);
    signal sioIntVectStatus : std_logic_vector(1 downto 0);
    
    signal sioEn    : std_logic_vector(1 downto 0);
    signal sioRxd   : std_logic_vector(1 downto 0);
    signal sioTxd   : std_logic_vector(1 downto 0);
    signal sioRxTxClk   : std_logic_vector(1 downto 0);

begin
    sioEn(0) <= '1' when baSel='0' and cs_n='0' and iorq_n='0' and m1_n='1' else '0';
    sioEn(1) <= '1' when baSel='1' and cs_n='0' and iorq_n='0' and m1_n='1' else '0';
    
    dOut <= sioIntVect(1) when intAck /="000000" else -- int vect only from sio channel b -- TODO: status affects vector
        sioDataOut(0) when (baSel='0' and rd_n='0') else
        sioDataOut(1);

    sioRxd(0) <= aRxd;
    sioRxd(1) <= bRxd;
    aTxd <= sioTxd(0);
    bTxd <= sioTxd(1);
    
    sioRxTxClk(0) <= aRxTxClk;
    sioRxTxClk(1) <= bRxTxClk;
    
    channels: for i in 0 to 1 generate
        sioChannel : entity work.sio_channel
        port map (
            clk     => clk,
            res_n   => res_n,
            en      => sioEn(i),
            
            dIn     => dIn,
            dOut    => sioDataOut(i),
            
            cdSel   => cdSel,
            
            rd_n    => rd_n,

            int     => int((i+1)*3-1 downto i*3),
            intAck  => intAck((i+1)*3-1 downto i*3),
            
           	intVect => sioIntVect(i),
           	intVectStatus => sioIntVectStatus(i),
           	
            rxd     => sioRxd(i),
            txd     => sioTxd(i),
            rxTxClk => sioRxTxClk(i)
        );
    end generate;
end;