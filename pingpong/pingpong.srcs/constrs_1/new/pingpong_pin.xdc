set_property PACKAGE_PIN Y9 [get_ports {clk}];  
set_property IOSTANDARD LVCMOS33 [get_ports {clk}];

set_property -dict {PACKAGE_PIN P16 IOSTANDARD LVCMOS33} [get_ports {rst}]

set_property -dict {PACKAGE_PIN T18 IOSTANDARD LVCMOS33} [get_ports {Button_L}]

set_property -dict {PACKAGE_PIN R16 IOSTANDARD LVCMOS33} [get_ports {Button_R}]



set_property PACKAGE_PIN T22  [get_ports {LED[0]}]  
set_property IOSTANDARD LVCMOS33 [get_ports {LED[0]}];

set_property PACKAGE_PIN T21  [get_ports {LED[1]}]  
set_property IOSTANDARD LVCMOS33 [get_ports {LED[1]}];

set_property PACKAGE_PIN U22  [get_ports {LED[2]}]  
set_property IOSTANDARD LVCMOS33 [get_ports {LED[2]}];

set_property PACKAGE_PIN U21  [get_ports {LED[3]}]  
set_property IOSTANDARD LVCMOS33 [get_ports {LED[3]}];

set_property PACKAGE_PIN V22  [get_ports {LED[4]}]  
set_property IOSTANDARD LVCMOS33 [get_ports {LED[4]}];

set_property PACKAGE_PIN W22  [get_ports {LED[5]}]  
set_property IOSTANDARD LVCMOS33 [get_ports {LED[5]}];

set_property PACKAGE_PIN U19  [get_ports {LED[6]}]  
set_property IOSTANDARD LVCMOS33 [get_ports {LED[6]}];

set_property PACKAGE_PIN U14  [get_ports {LED[7]}]  
set_property IOSTANDARD LVCMOS33 [get_ports {LED[7]}];


set_property PACKAGE_PIN F22  [get_ports {mode[0]}]  
set_property IOSTANDARD LVCMOS33 [get_ports {mode[0]}];
set_property PACKAGE_PIN G22  [get_ports {mode[1]}]  
set_property IOSTANDARD LVCMOS33 [get_ports {mode[1]}];

set_property PACKAGE_PIN M15  [get_ports {L_mode3}]  
set_property IOSTANDARD LVCMOS33 [get_ports {L_mode3}];

set_property PACKAGE_PIN H22  [get_ports {R_mode3}]  
set_property IOSTANDARD LVCMOS33 [get_ports {R_mode3}];