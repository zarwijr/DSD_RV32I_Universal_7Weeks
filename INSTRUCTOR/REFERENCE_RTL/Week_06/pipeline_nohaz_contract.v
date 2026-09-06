module pipeline_nohaz_contract(
    input wire [31:0] PCE,ImmExtE,
    input wire BranchE,ZeroE,
    output wire [31:0] PCTargetE,
    output wire PCSrcE);
    assign PCTargetE=PCE+ImmExtE;
    assign PCSrcE=BranchE&ZeroE;
endmodule
