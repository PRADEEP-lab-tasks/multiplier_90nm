# constraints/constraints.sdc

create_clock -name clk -period 5.000 [get_ports clk]

set_input_delay  1.000 -clock clk \
  [remove_from_collection [all_inputs] [get_ports {clk rst_n}]]

set_output_delay 1.000 -clock clk [all_outputs]

set_false_path -from [get_ports rst_n]

set_clock_uncertainty -setup 0.050 [get_clocks clk]
set_clock_uncertainty -hold  0.020 [get_clocks clk]

set_input_transition 0.100 \
  [remove_from_collection [all_inputs] [get_ports {clk rst_n}]]

set_load 0.010 [all_outputs]
