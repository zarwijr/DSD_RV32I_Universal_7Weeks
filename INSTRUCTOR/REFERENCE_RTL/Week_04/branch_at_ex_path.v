module branch_at_ex_path(
    input wire [31:0] PCE, ImmExtE,
    input wire BranchE, ZeroE, JumpE,
    output wire [31:0] PCTargetE,
    output wire BranchTakenE, PCSrcE);
    assign PCTargetE=PCE+ImmExtE;
    assign BranchTakenE=BranchE&ZeroE;
    assign PCSrcE=BranchTakenE|JumpE;
endmodule
