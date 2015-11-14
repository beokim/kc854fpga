## Generated SDC file "kc854.sdc"

## Copyright (C) 1991-2013 Altera Corporation
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, Altera MegaCore Function License 
## Agreement, or other applicable license agreement, including, 
## without limitation, that your use is for the sole purpose of 
## programming logic devices manufactured by Altera and sold by 
## Altera or its authorized distributors.  Please refer to the 
## applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Web Edition"

## DATE    "Tue Aug 11 22:34:38 2015"

##
## DEVICE  "EP2C20F484C7"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {CLOCK_50} -period 20.000 -waveform { 0.000 5.000 } [get_ports { CLOCK_50 }]


#**************************************************************
# Create Generated Clock
#**************************************************************

derive_pll_clocks
# create_generated_clock -source {clockgen|pllinst|altpll_component|pll|inclk[0]} -duty_cycle 50.00 -name {clockgen|pllinst|altpll_component|pll|clk[0]} {clockgen|pllinst|altpll_component|pll|clk[0]}
# create_generated_clock -source {clockgen|pllinst|altpll_component|pll|inclk[0]} -divide_by 10 -multiply_by 13 -duty_cycle 50.00 -name {clockgen|pllinst|altpll_component|pll|clk[1]} {clockgen|pllinst|altpll_component|pll|clk[1]}
    
create_generated_clock -name cpuclk -source [get_pins {clockgen|pllinst|altpll_component|pll|clk[0]}]
create_generated_clock -name vgaclk -source [get_pins {clockgen|pllinst|altpll_component|pll|clk[1]}]

# create_generated_clock -name {clockgen|pllinst|altpll_component|pll|clk[0]} -source [get_pins {clockgen|pllinst|altpll_component|pll|inclk[0]}] -duty_cycle 50.000 -multiply_by 1 -master_clock {CLOCK_50} [get_pins {clockgen|pllinst|altpll_component|pll|clk[0]}] 
# create_generated_clock -name {clockgen|pllinst|altpll_component|pll|clk[1]} -source [get_pins {clockgen|pllinst|altpll_component|pll|inclk[0]}] -duty_cycle 50.000 -multiply_by 13 -divide_by 10 -master_clock {CLOCK_50} [get_pins {clockgen|pllinst|altpll_component|pll|clk[1]}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************



#**************************************************************
# Set Input Delay
#**************************************************************

# set_input_delay -clock cpuclk 1.5 [all_inputs]
set_input_delay -clock cpuclk 1.5 [get_ports SRAM_DQ*]
# set_input_delay -add_delay -clock cpuclk -1.500 [get_ports {SRAM_DQ*}]

#**************************************************************
# Set Output Delay
#**************************************************************

# set_output_delay -clock CLOCK_50 1.5 [all_outputs]
# set_output_delay -clock cpuclk -min 0.5 [all_outputs]
# set_output_delay -clock cpuclk -max 0.5 [all_outputs]

set_output_delay -clock cpuclk 0.5 [get_ports SRAM_DQ*]
set_output_delay -clock cpuclk 0.5 [get_ports {LED*}]
set_output_delay -clock cpuclk 0.5 [get_ports {HEX*}]
set_output_delay -clock vgaclk 0.5 [get_ports {VGA_*}]

#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

