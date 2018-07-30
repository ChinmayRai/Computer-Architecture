## This file is a general .xdc for the Basys3 rev B board
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

# Clock signal
# Bank = 34, Pin name = ,	Sch name = CLK100MHZ
	set_property PACKAGE_PIN W5 [get_ports clk]
	set_property IOSTANDARD LVCMOS33 [get_ports clk]
	create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clk]

# Switches
set_property PACKAGE_PIN W17 [get_ports show_add[3]]
set_property IOSTANDARD LVCMOS33 [get_ports show_add[3]]

set_property PACKAGE_PIN W16 [get_ports show_add[2]]
set_property IOSTANDARD LVCMOS33 [get_ports show_add[2]]

set_property PACKAGE_PIN V16 [get_ports show_add[1]]
set_property IOSTANDARD LVCMOS33 [get_ports show_add[1]]

set_property PACKAGE_PIN V17 [get_ports show_add[0]]
set_property IOSTANDARD LVCMOS33 [get_ports show_add[0]]

#Push Buttons
set_property PACKAGE_PIN U18 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports reset]

#LEDs
set_property PACKAGE_PIN L1 [get_ports show_data[15]]
set_property IOSTANDARD LVCMOS33 [get_ports show_data[15]]
set_property PACKAGE_PIN P1 [get_ports show_data[14]]
set_property IOSTANDARD LVCMOS33 [get_ports show_data[14]]
set_property PACKAGE_PIN N3 [get_ports show_data[13]]
set_property IOSTANDARD LVCMOS33 [get_ports show_data[13]]
set_property PACKAGE_PIN P3 [get_ports show_data[12]]
set_property IOSTANDARD LVCMOS33 [get_ports show_data[12]]
set_property PACKAGE_PIN U3 [get_ports show_data[11]]
set_property IOSTANDARD LVCMOS33 [get_ports show_data[11]]
set_property PACKAGE_PIN W3 [get_ports show_data[10]]
set_property IOSTANDARD LVCMOS33 [get_ports show_data[10]]
set_property PACKAGE_PIN V3 [get_ports show_data[9]]
set_property IOSTANDARD LVCMOS33 [get_ports show_data[9]]
set_property PACKAGE_PIN V13 [get_ports show_data[8]]
set_property IOSTANDARD LVCMOS33 [get_ports show_data[8]]
set_property PACKAGE_PIN V14 [get_ports show_data[7]]
set_property IOSTANDARD LVCMOS33 [get_ports show_data[7]]
set_property PACKAGE_PIN U14 [get_ports show_data[6]]
set_property IOSTANDARD LVCMOS33 [get_ports show_data[6]]
set_property PACKAGE_PIN U15 [get_ports show_data[5]]
set_property IOSTANDARD LVCMOS33 [get_ports show_data[5]]
set_property PACKAGE_PIN W18 [get_ports show_data[4]]
set_property IOSTANDARD LVCMOS33 [get_ports show_data[4]]
set_property PACKAGE_PIN V19 [get_ports show_data[3]]
set_property IOSTANDARD LVCMOS33 [get_ports show_data[3]]
set_property PACKAGE_PIN U19 [get_ports show_data[2]]
set_property IOSTANDARD LVCMOS33 [get_ports show_data[2]]
set_property PACKAGE_PIN E19 [get_ports show_data[1]]
set_property IOSTANDARD LVCMOS33 [get_ports show_data[1]]
set_property PACKAGE_PIN U16 [get_ports show_data[0]]
set_property IOSTANDARD LVCMOS33 [get_ports show_data[0]]

# Cathodes
set_property PACKAGE_PIN W7 [get_ports Cathode[0]]
set_property IOSTANDARD LVCMOS33 [get_ports Cathode[0]]

set_property PACKAGE_PIN W6 [get_ports Cathode[1]]
set_property IOSTANDARD LVCMOS33 [get_ports Cathode[1]]

set_property PACKAGE_PIN U8 [get_ports Cathode[2]]
set_property IOSTANDARD LVCMOS33 [get_ports Cathode[2]]

set_property PACKAGE_PIN V8 [get_ports Cathode[3]]
set_property IOSTANDARD LVCMOS33 [get_ports Cathode[3]]

set_property PACKAGE_PIN U5 [get_ports Cathode[4]]
set_property IOSTANDARD LVCMOS33 [get_ports Cathode[4]]

set_property PACKAGE_PIN V5 [get_ports Cathode[5]]
set_property IOSTANDARD LVCMOS33 [get_ports Cathode[5]]

set_property PACKAGE_PIN U7 [get_ports Cathode[6]]
set_property IOSTANDARD LVCMOS33 [get_ports Cathode[6]]

#Anodes
set_property PACKAGE_PIN U2 [get_ports Anode[0]]
set_property IOSTANDARD LVCMOS33 [get_ports Anode[0]]

set_property PACKAGE_PIN U4 [get_ports Anode[1]]
set_property IOSTANDARD LVCMOS33 [get_ports Anode[1]]

set_property PACKAGE_PIN V4 [get_ports Anode[2]]
set_property IOSTANDARD LVCMOS33 [get_ports Anode[2]]

set_property PACKAGE_PIN W4 [get_ports Anode[3]]
set_property IOSTANDARD LVCMOS33 [get_ports Anode[3]]

# Others (BITSTREAM, CONFIG)
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]

set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]

set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]