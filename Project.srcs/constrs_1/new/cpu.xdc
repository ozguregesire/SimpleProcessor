# Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]							
	set_property IOSTANDARD LVCMOS33 [get_ports clk]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]
 
# Switches
set_property PACKAGE_PIN V17 [get_ports {switch[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {switch[0]}]
set_property PACKAGE_PIN V16 [get_ports {switch[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {switch[1]}]
set_property PACKAGE_PIN W16 [get_ports {switch[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {switch[2]}]
set_property PACKAGE_PIN W17 [get_ports {switch[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {switch[3]}]
set_property PACKAGE_PIN W15 [get_ports {switch[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {switch[4]}]
set_property PACKAGE_PIN V15 [get_ports {switch[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {switch[5]}]
set_property PACKAGE_PIN W14 [get_ports {switch[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {switch[6]}]
set_property PACKAGE_PIN W13 [get_ports {switch[7]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {switch[7]}]
set_property PACKAGE_PIN V2 [get_ports {switch[8]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {switch[8]}]
set_property PACKAGE_PIN T3 [get_ports {switch[9]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {switch[9]}]
set_property PACKAGE_PIN T2 [get_ports {switch[10]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {switch[10]}]
set_property PACKAGE_PIN R3 [get_ports {switch[11]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {switch[11]}]
set_property PACKAGE_PIN W2 [get_ports {switch[12]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {switch[12]}]
set_property PACKAGE_PIN U1 [get_ports {switch[13]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {switch[13]}]
set_property PACKAGE_PIN T1 [get_ports {switch[14]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {switch[14]}]
set_property PACKAGE_PIN R2 [get_ports {switch[15]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {switch[15]}]
 
#7 segment display
set_property PACKAGE_PIN W7 [get_ports {LED_out[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {LED_out[6]}]
set_property PACKAGE_PIN W6 [get_ports {LED_out[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {LED_out[5]}]
set_property PACKAGE_PIN U8 [get_ports {LED_out[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {LED_out[4]}]
set_property PACKAGE_PIN V8 [get_ports {LED_out[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {LED_out[3]}]
set_property PACKAGE_PIN U5 [get_ports {LED_out[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {LED_out[2]}]
set_property PACKAGE_PIN V5 [get_ports {LED_out[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {LED_out[1]}]
set_property PACKAGE_PIN U7 [get_ports {LED_out[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {LED_out[0]}]

set_property PACKAGE_PIN U2 [get_ports {Anode_Activate[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Anode_Activate[0]}]
set_property PACKAGE_PIN U4 [get_ports {Anode_Activate[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Anode_Activate[1]}]
set_property PACKAGE_PIN V4 [get_ports {Anode_Activate[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Anode_Activate[2]}]
set_property PACKAGE_PIN W4 [get_ports {Anode_Activate[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Anode_Activate[3]}]

##Buttons
set_property PACKAGE_PIN U18 [get_ports mid_in]						
	set_property IOSTANDARD LVCMOS33 [get_ports mid_in]
set_property PACKAGE_PIN T18 [get_ports upper_in]						
	set_property IOSTANDARD LVCMOS33 [get_ports upper_in]
set_property PACKAGE_PIN W19 [get_ports left_in]						
	set_property IOSTANDARD LVCMOS33 [get_ports left_in]
set_property PACKAGE_PIN T17 [get_ports right_in]						
	set_property IOSTANDARD LVCMOS33 [get_ports right_in]
set_property PACKAGE_PIN U17 [get_ports lower_in]						
	set_property IOSTANDARD LVCMOS33 [get_ports lower_in]
 
