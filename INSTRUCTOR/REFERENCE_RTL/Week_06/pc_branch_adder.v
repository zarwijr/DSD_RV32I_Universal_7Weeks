module pc_branch_adder(
    input wire [31:0] PCE,ImmExtE,
    output wire [31:0] PCTargetE);
    assign PCTargetE=PCE+ImmExtE;
endmodule
