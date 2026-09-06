module Hazard_Unit (
    input [4:0] rs1D, rs2D, rs1E, rs2E, rdE, rdM, rdW,
    input RegWriteM, RegWriteW, ResultSrcE0, PCSrcE,
    output reg [1:0] ForwardAE, ForwardBE,
    output StallF, StallD, FlushE, FlushD
);

    always @(*) begin
        ForwardAE = 2'b00;
        ForwardBE = 2'b00;
        
        if (((rs1E == rdM) && RegWriteM) && (rdM != 0)) ForwardAE = 2'b10;
        if (((rs2E == rdM) && RegWriteM) && (rdM != 0)) ForwardBE = 2'b10;
        
        if (((rs1E == rdW) && RegWriteW) && (rdW != 0) && ~((rs1E == rdM) && RegWriteM)) ForwardAE = 2'b01;
        if (((rs2E == rdW) && RegWriteW) && (rdW != 0) && ~((rs2E == rdM) && RegWriteM)) ForwardBE = 2'b01;
    end

    wire lwStall;
    assign lwStall = ResultSrcE0 && ((rs1D == rdE) || (rs2D == rdE));
    
    assign StallF = lwStall;
    assign StallD = lwStall;
    
    assign FlushD = PCSrcE;
    assign FlushE = lwStall || PCSrcE;
endmodule