`timescale 1ns/1ps

module Pipelined_RISCV_tb;

    reg clk;
    reg reset;


    wire [31:0] PCF;
    wire [31:0] ALUResultW;
    wire [1:0] ForwardAE, ForwardBE;
    wire StallD, FlushE;
    
    wire [31:0] InstrD_out;
    wire [31:0] RD1_out, RD2_out;
    wire [31:0] SrcAE_out, SrcBE_out;
    wire [31:0] ReadDataM_out;
    wire [31:0] ResultW_out;


    Pipelined_RISCV uut (
        .clk(clk), 
        .reset(reset),
        .PCF(PCF), 
        .ALUResultW(ALUResultW), 
        .ForwardAE(ForwardAE), 
        .ForwardBE(ForwardBE), 
        .StallD(StallD), 
        .FlushE(FlushE),
        .InstrD_out(InstrD_out),
        .RD1_out(RD1_out),
        .RD2_out(RD2_out),
        .SrcAE_out(SrcAE_out),
        .SrcBE_out(SrcBE_out),
        .ReadDataM_out(ReadDataM_out),
        .ResultW_out(ResultW_out)
    );

    always #5 clk = ~clk;

    initial begin

        clk = 0;
        reset = 0; 
        
        #12;
        reset = 1; 
        

        #200;
        $stop;
    end

endmodule