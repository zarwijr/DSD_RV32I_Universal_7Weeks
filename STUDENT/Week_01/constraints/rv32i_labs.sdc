# DSD RV32I Labs — common timing constraints
# Contract: CLOCK_50 is the only primary clock.
create_clock -name CLOCK_50 -period 20.000 [get_ports {CLOCK_50}]

# If reset_n is exposed as a top-level port and its deassertion is synchronized,
# the instructor may enable the following project-specific exception:
# set_false_path -from [get_ports {reset_n}]
