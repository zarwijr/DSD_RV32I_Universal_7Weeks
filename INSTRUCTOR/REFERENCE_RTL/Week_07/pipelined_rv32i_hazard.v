module pipelined_rv32i_hazard(
    input wire clk, reset_n,
    output wire [31:0] PCF,ResultW,
    output wire [1:0] ForwardAE,ForwardBE,
    output wire StallF,StallD,FlushD,FlushE);
    wire [31:0] PCNext,PCPlus4F,InstrF,PCD,InstrD,PCPlus4D;
    wire [31:0] RD1D,RD2D,ImmExtD,PCE,RD1E,RD2E,ImmExtE,PCPlus4E;
    wire [31:0] SrcAE,ForwardedB,SrcBE,WriteDataE,ALUResultE,PCTargetE;
    wire [31:0] ALUResultM,WriteDataM,ReadDataM,PCPlus4M;
    wire [31:0] ReadDataW,ALUResultW,PCPlus4W;
    wire [4:0] Rs1E,Rs2E,RdE,RdM,RdW;
    wire RegWriteD,ALUSrcD,MemWriteD,BranchD;
    wire RegWriteE,ALUSrcE,MemWriteE,BranchE;
    wire RegWriteM,MemWriteM,RegWriteW,ZeroE,PCSrcE;
    wire UseRs1D,UseRs2D;
    wire [1:0] ImmSrcD,ResultSrcD,ResultSrcE,ResultSrcM,ResultSrcW;
    wire [2:0] ALUControlD,ALUControlE;

    assign PCPlus4F=PCF+32'd4;
    assign PCTargetE=PCE+ImmExtE;
    assign PCSrcE=BranchE&ZeroE;
    assign PCNext=PCSrcE?PCTargetE:PCPlus4F;
    program_counter pc0(clk,reset_n,~StallF,PCNext,PCF);
    instruction_memory imem(PCF,InstrF);
    reg_if_id fd(clk,reset_n,FlushD,~StallD,PCF,InstrF,PCPlus4F,
      PCD,InstrD,PCPlus4D);

    control_unit_full cu(InstrD[6:0],InstrD[14:12],InstrD[30],
      RegWriteD,ALUSrcD,MemWriteD,BranchD,ImmSrcD,ResultSrcD,ALUControlD);
    register_file rf(clk,reset_n,RegWriteW,InstrD[19:15],InstrD[24:20],
      RdW,ResultW,RD1D,RD2D);
    extend ext(ImmSrcD,InstrD[31:7],ImmExtD);
    reg_id_ex de(clk,reset_n,FlushE,RegWriteD,ALUSrcD,MemWriteD,BranchD,
      ResultSrcD,ALUControlD,RD1D,RD2D,PCD,ImmExtD,PCPlus4D,
      InstrD[19:15],InstrD[24:20],InstrD[11:7],RegWriteE,ALUSrcE,
      MemWriteE,BranchE,ResultSrcE,ALUControlE,RD1E,RD2E,PCE,ImmExtE,
      PCPlus4E,Rs1E,Rs2E,RdE);

    hazard_datapath_connections fwd_data(RD1E,RD2E,ResultW,ALUResultM,
      ImmExtE,ForwardAE,ForwardBE,ALUSrcE,SrcAE,ForwardedB,WriteDataE,SrcBE);
    alu alu0(ALUControlE,SrcAE,SrcBE,ALUResultE,ZeroE);
    reg_ex_mem em(clk,reset_n,RegWriteE,MemWriteE,ResultSrcE,
      ALUResultE,WriteDataE,PCPlus4E,RdE,RegWriteM,MemWriteM,ResultSrcM,
      ALUResultM,WriteDataM,PCPlus4M,RdM);
    data_memory dmem(clk,MemWriteM,ALUResultM,WriteDataM,ReadDataM);
    reg_mem_wb mw(clk,reset_n,RegWriteM,ResultSrcM,ReadDataM,ALUResultM,
      PCPlus4M,RdM,RegWriteW,ResultSrcW,ReadDataW,ALUResultW,PCPlus4W,RdW);
    assign ResultW=(ResultSrcW==2'b01)?ReadDataW:
                   (ResultSrcW==2'b10)?PCPlus4W:ALUResultW;

    assign UseRs1D=(InstrD[6:0]==7'b0110011)||(InstrD[6:0]==7'b0010011)||
                   (InstrD[6:0]==7'b0000011)||(InstrD[6:0]==7'b0100011)||
                   (InstrD[6:0]==7'b1100011);
    assign UseRs2D=(InstrD[6:0]==7'b0110011)||(InstrD[6:0]==7'b0100011)||
                   (InstrD[6:0]==7'b1100011);
    hazard_unit hz(InstrD[19:15],InstrD[24:20],Rs1E,Rs2E,RdE,RdM,RdW,
      RegWriteM,RegWriteW,ResultSrcE[0],PCSrcE,UseRs1D,UseRs2D,
      ForwardAE,ForwardBE,StallF,StallD,FlushE,FlushD);
endmodule
