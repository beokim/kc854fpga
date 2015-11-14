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
-- TB fuer Speichercontroller mit CPU
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memcontrol_cpu_tb is
end memcontrol_cpu_tb;

architecture sim of memcontrol_cpu_tb is
    signal clk      : std_logic := '0';
    signal reset_n  : std_logic := '0';

    signal int_n    : std_logic := '1';
    signal m1_n     : std_logic;
    signal mreq_n   : std_logic;
    signal rfsh_n   : std_logic;
    signal iorq_n   : std_logic;
    signal rd_n     : std_logic;
    signal wr_n     : std_logic;
    
    signal cpu_addr : std_logic_vector(15 downto 0);
    signal cpu_di   : std_logic_vector(7 downto 0);
    signal cpu_do   : std_logic_vector(7 downto 0);
    signal cpuEn    : std_logic;
    signal cpuWait  : std_logic;
    
    signal sramAddr : std_logic_vector(17 downto 0);
    signal sramDataIn : std_logic_vector(15 downto 0);
    signal sramDataOut : std_logic_vector(15 downto 0);
    signal sramDQ   : std_logic_vector(15 downto 0);
    signal sramOE_n : std_logic;
    signal sramCE_n : std_logic;
    signal sramWE_n : std_logic;
    signal sramLB_n : std_logic;
    signal sramUB_n : std_logic;
    
    signal vidData  : std_logic_vector(15 downto 0);
    signal vidBusy  : std_logic;
    signal vidRead  : std_logic;
    
    signal cpuTick  : std_logic;
    
    signal counter  : integer range 0 to 19 := 0;
    
    signal ioSel    : boolean;
    
    signal pio_cs_n : std_logic;
    
    signal pio_aIn  : std_logic_vector(7 downto 0);
    signal pio_aOut : std_logic_vector(7 downto 0);
    signal pio_aRdy : std_logic;
    signal pio_aStb : std_logic;
        
    signal pio_bIn  : std_logic_vector(7 downto 0);
    signal pio_bOut : std_logic_vector(7 downto 0);
    signal pio_bRdy : std_logic;
    signal pio_bStb : std_logic;
    
    constant SRAM_ADDR_BITS : integer := 18;

begin
    clk <= not clk after 10 ns;

    process
    begin
        wait until rising_edge(clk);
        
        if (counter<19) then
            counter <= counter + 1;
        else
            counter <= 0;
        end if;
      
        cpuTick <= '0';
        
        if (counter=9 or counter=11 or counter=14) then
            cpuTick <= '1';
        end if;
        
        if (counter=19) then
            cpuTick <= '1';
        end if;
    end process;
  
    reset_n <= '1' after 100 ns; 
    
    memcontrol : entity work.memcontrol
    port map (
        clk          => clk,
        reset_n      => reset_n,

        sramAddr     => sramAddr,
        sramDataIn   => sramDataIn,
        sramDataOut  => sramDataOut,
        sramOE_n     => sramOE_n,
        sramCE_n     => sramCE_n,
        sramWE_n     => sramWE_n,
        sramLB_n     => sramLB_n,
        sramUB_n     => sramUB_n,
         
        cpuAddr      => cpu_addr,

        cpuDOut      => cpu_di,
        cpuDIn       => cpu_do,
         
        cpuWR_n      => wr_n,
        cpuRD_n      => rd_n,
        cpuMREQ_n    => mreq_n,
        cpuM1_n      => m1_n,
        cpuIORQ_n    => iorq_n,
        
        cpuEn        => cpuEn,
        cpuWait      => cpuWait,
        
        cpuTick      => cpuTick,
         
        pioPortA     => pio_aOut,
        pioPortB     => pio_bOut,
        
        vidAddr      => "00000000000010",
        vidData      => vidData,
        vidRead      => vidRead
    ); 
     
     
    cpu : entity work.T80se
        generic map(Mode => 1, T2Write => 1, IOWait => 0)
        port map(
            RESET_n => reset_n,
            CLK_n   => clk,
            CLKEN   => cpuEn,
            WAIT_n  => cpuWait,
            INT_n   => int_n,
            NMI_n   => '1',
            BUSRQ_n => '1',
            M1_n    => m1_n,
            MREQ_n  => mreq_n,
            IORQ_n  => iorq_n,
            RD_n    => rd_n,
            WR_n    => wr_n,
            RFSH_n  => rfsh_n,
            HALT_n  => open,
            BUSAK_n => open,
            A       => cpu_addr,
--            DI      => "00000000",
            DI      => cpu_di,
            DO      => cpu_do
        ); 
     

    ioSel    <= iorq_n = '0' and m1_n='1';
    pio_cs_n   <= '0' when cpu_addr(7 downto 3) = "10001"  and ioSel else '1';
    
    pio : entity work.pio
        port map (
            clk   => clk,
            res_n => reset_n,
            en    => '1',
            dIn   => cpu_do,
            dOut  => open,
            baSel => cpu_addr(0),
            cdSel => cpu_addr(1),
            ce    => pio_cs_n,
            m1    => m1_n,
            iorq  => iorq_n,
            rd    => rd_n,
            intAck => "00",
            int   => open,
            aIn   => pio_aIn,
            aOut  => pio_aOut,
            aRdy  => pio_aRdy,
            aStb  => pio_aStb,
            bIn   => pio_bIn,
            bOut  => pio_bOut,
            bRdy  => pio_bRdy,
            bStb  => '1'
        );
    
    sramDQ <= sramDataOut when sramOE_n='1' else
        "ZZZZZZZZZZZZZZZZ";
    sramDataIn <= sramDQ;
    
	  sram : entity work.sram_d
		generic map (
			-- Configuring RAM size
			size 			=>  2**SRAM_ADDR_BITS-1,  -- number of memory words
			adr_width 	=>  SRAM_ADDR_BITS,  -- number of address bits
			width 		=>  16,  -- number of bits per memory word
			-- READ-cycle timing parameters
			tAA_max     => 10 ns, -- Address Access Time
			tOHA_min    =>  3 ns, -- Output Hold Time
			tACE_max    => 10 ns, -- nCE/CE2 Access Time
			tDOE_max    =>  4 ns, -- nOE Access Time
			tLZOE_min   =>  0 ns, -- nOE to Low-Z Output
			tHZOE_max   =>  4 ns, --  OE to High-Z Output
			tLZCE_min   =>  3 ns, -- nCE/CE2 to Low-Z Output
			tHZCE_max   => 10 ns, --  CE/nCE2 to High Z Output
			-- WRITE-cycle timing parameters
			tWC_min     => 10 ns, -- Write Cycle Time
			tSCE_min    =>  8 ns, -- nCE/CE2 to Write End
			tAW_min     =>  8 ns, -- tAW Address Set-up Time to Write End
			tHA_min     =>  0 ns, -- tHA Address Hold from Write End
			tSA_min     =>  0 ns, -- Address Set-up Time
			tPWE_min    =>  8 ns, -- nWE Pulse Width
			tSD_min     =>  6 ns, -- Data Set-up to Write End
			tHD_min     =>  0 ns, -- Data Hold from Write End
			tHZWE_max   =>  5 ns, -- nWE Low to High-Z Output
			tLZWE_min   =>  2 ns  -- nWE High to Low-Z Output
		) 
		port map (
			nCE => sramCE_n,
			nOE => sramOE_n,
			nWE => sramWE_n,
			A   => sramAddr,
			D   => sramDQ
		); 
end;