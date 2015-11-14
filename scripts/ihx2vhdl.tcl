#!/usr/bin/tclsh
# ihx2vhdl [entityname] <rom.ihx >rom.vhdl

while {[gets stdin line]  >= 0} {
    if {[scan $line {:%2x%4x%2x%s} reclen offset rectype data]} {
        switch $rectype {
            0 {
                set data_len [string length $data]

                if {![info exists last]} {
                    set last $offset
                }

                for {set x 0} {$x < $data_len - 2} {incr x 2} {
                    set mem([expr $offset + $x/2]) [string range $data $x $x+1]
                }
            }
            1 {
            }
        }
    }
}

set entityName "rom"
if { $::argc > 0 } {
    set entityName [lindex $::argv 0]
} 

set addr [lsort -integer [array names mem]]

set minAddr [lindex $addr 0]
set numBits [expr int(ceil(log([lindex $addr end] - $minAddr) / log(2)))]
set numBytes [expr int(pow(2,$numBits))]

puts "library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity $entityName is
    generic(
        ADDR_WIDTH   : integer := [expr $numBits]
    );
    port (
        clk  : in std_logic;
        addr : in std_logic_vector(ADDR_WIDTH-1 downto 0);
        data : out std_logic_vector(7 downto 0)
    );
end $entityName;

architecture rtl of $entityName is
    type rom[expr $numBytes]x8 is array (0 to 2**ADDR_WIDTH-1) of std_logic_vector(7 downto 0); 
    constant romData : rom[expr $numBytes]x8 := ("
puts -nonewline "        "
for {set i 0} {$i < $numBytes} {incr i} {
    set addr [expr $minAddr + $i]
    if {[info exists mem($addr)]} {
        puts -nonewline " x\"$mem($addr)\""
    } else {
        puts -nonewline " x\"00\""
    }
    
    if {$i < $numBytes - 1} {
        puts  -nonewline ", "
    } else {
        puts  -nonewline "  "
    }
    
    if {$i % 8 == 7} {
        puts -nonewline "-- [format %4.4X [expr $addr - 7]]\n        "
    }   
}
puts ");
    
begin
    process begin
        wait until rising_edge(clk);
        data <= romData(to_integer(unsigned(addr)));
    end process;
end;"