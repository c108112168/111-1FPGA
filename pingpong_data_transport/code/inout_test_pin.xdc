
set_property IOSTANDARD LVCMOS25 [get_ports clk]
set_property PACKAGE_PIN Y9 [get_ports clk]
set_property CLOCK_DEDICATED_ROUTE TRUE   [get_ports "clk         "]

# "SW7"#
set_property IOSTANDARD LVCMOS25 [get_ports {rst}]
set_property PACKAGE_PIN M15 [get_ports {rst}]


# "SW7"#
set_property IOSTANDARD LVCMOS25 [get_ports {Button}]
set_property PACKAGE_PIN P16 [get_ports {Button}]
# "SW7"#
set_property IOSTANDARD LVCMOS25 [get_ports {start_btn}]
set_property PACKAGE_PIN T18 [get_ports {start_btn}]


set_property PACKAGE_PIN T22  [get_ports {LED[0]}]  
set_property IOSTANDARD LVCMOS25 [get_ports {LED[0]}];

set_property PACKAGE_PIN T21  [get_ports {LED[1]}]  
set_property IOSTANDARD LVCMOS25 [get_ports {LED[1]}];

set_property PACKAGE_PIN U22  [get_ports {LED[2]}]  
set_property IOSTANDARD LVCMOS25 [get_ports {LED[2]}];

set_property PACKAGE_PIN U21  [get_ports {LED[3]}]  
set_property IOSTANDARD LVCMOS25 [get_ports {LED[3]}];

set_property PACKAGE_PIN V22  [get_ports {LED[4]}]  
set_property IOSTANDARD LVCMOS25 [get_ports {LED[4]}];

set_property PACKAGE_PIN W22  [get_ports {LED[5]}]  
set_property IOSTANDARD LVCMOS25 [get_ports {LED[5]}];

set_property PACKAGE_PIN U19  [get_ports {LED[6]}]  
set_property IOSTANDARD LVCMOS25 [get_ports {LED[6]}];

set_property PACKAGE_PIN U14  [get_ports {LED[7]}]  
set_property IOSTANDARD LVCMOS25 [get_ports {LED[7]}];



# "inout"#
set_property IOSTANDARD LVCMOS25 [get_ports {data}]
set_property PACKAGE_PIN AB10 [get_ports {data}]