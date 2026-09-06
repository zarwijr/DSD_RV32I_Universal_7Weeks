module hazard_unit(
    input wire [4:0] Rs1D,Rs2D,Rs1E,Rs2E,RdE,RdM,RdW,
    input wire RegWriteM,RegWriteW,ResultSrcE0,PCSrcE,
    input wire UseRs1D,UseRs2D,
    output wire [1:0] ForwardAE,ForwardBE,
    output wire StallF,StallD,FlushE,FlushD);
    wire lwStall;
    forwarding_unit fw(Rs1E,Rs2E,RdM,RdW,RegWriteM,RegWriteW,
                       ForwardAE,ForwardBE);
    assign lwStall=ResultSrcE0 && (RdE!=5'd0) &&
      ((UseRs1D && Rs1D==RdE)||(UseRs2D && Rs2D==RdE));
    assign StallF=lwStall;
    assign StallD=lwStall;
    assign FlushD=PCSrcE;
    assign FlushE=lwStall|PCSrcE;
endmodule
