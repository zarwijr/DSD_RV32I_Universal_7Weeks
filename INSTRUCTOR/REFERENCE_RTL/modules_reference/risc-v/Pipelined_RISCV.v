module Pipelined_RISCV (
    input clk, reset,
    output [31:0] PCF, ALUResultW, 
    output [1:0] ForwardAE, ForwardBE, 
    output StallD, FlushE,
    
    output [31:0] InstrD_out,       
    output [31:0] RD1_out, RD2_out, 
    output [31:0] SrcAE_out, SrcBE_out,
    output [31:0] ReadDataM_out,  
    output [31:0] ResultW_out 
);

    wire [31:0] PCNext, PCPlus4F, InstrF; 
    wire [31:0] PCD, InstrD, PCPlus4D, RD1D, RD2D, ImmExtD;
    wire [31:0] PCE, RD1E, RD2E, ImmExtE, PCPlus4E, SrcAE, SrcBE, WriteDataE, ALUResultE, PCTargetE;
    wire [31:0] ALUResultM, WriteDataM, ReadDataM, PCPlus4M;
    wire [31:0] ReadDataW, PCPlus4W, ResultW; 
    
    wire [4:0] rs1E, rs2E, rdE, rdM, rdW;
    wire StallF, FlushD; 
    
    wire RegWriteD, ALUSrcD, MemWriteD, BranchD;
    wire [1:0] ResultSrcD;
    wire [2:0] ALUControlD;
    wire [1:0] ImmSrcD;
    
    wire RegWriteE, ALUSrcE, MemWriteE, BranchE;
    wire [1:0] ResultSrcE;
    wire [2:0] ALUControlE;
    wire ZeroE, PCSrcE;
    
    wire RegWriteM, MemWriteM;
    wire [1:0] ResultSrcM;
    
    wire RegWriteW;
    wire [1:0] ResultSrcW;

    // --- FETCH ---
    assign PCNext = PCSrcE ? PCTargetE : PCPlus4F;
    Program_Counter_Pipe PC_Register (.clk(clk), .reset(reset), .en(~StallF), .d(PCNext), .q(PCF));
    assign PCPlus4F = PCF + 32'd4;
    Instruction_Memory IMEM (.read_address(PCF), .instruction(InstrF));
    reg_if_id REG_IF_ID (.clk(clk), .reset(reset), .clear(FlushD), .en(~StallD), .pc_in(PCF), .instr_in(InstrF), .pc_plus4_in(PCPlus4F), .pc_out(PCD), .instr_out(InstrD), .pc_plus4_out(PCPlus4D));

    // --- INSTRUCTON DECODE ---
    Control_Unit Control (.op(InstrD[6:0]), .funct3(InstrD[14:12]), .funct7_5(InstrD[30]), .Zero(1'b0), .RegWrite(RegWriteD), .ImmSrc(ImmSrcD), .ALUSrc(ALUSrcD), .MemWrite(MemWriteD), .ResultSrc(ResultSrcD), .ALUControl(ALUControlD), .Branch(BranchD), .PCSrc());
    Register_File RegFiles (.clk(clk), .RegWrite(RegWriteW), .read_addr_1(InstrD[19:15]), .read_addr_2(InstrD[24:20]), .write_addr(rdW), .write_data(ResultW), .read_data_1(RD1D), .read_data_2(RD2D));
    Extend Imm_Ext (.ImmSrc(ImmSrcD), .Imm(InstrD[31:7]), .ImmExt(ImmExtD));
    reg_id_ex REG_ID_EX (.clk(clk), .reset(reset), .clear(FlushE), .RegWriteD(RegWriteD), .ALUSrcD(ALUSrcD), .MemWriteD(MemWriteD), .BranchD(BranchD), .ResultSrcD(ResultSrcD), .ALUControlD(ALUControlD), .rd1_in(RD1D), .rd2_in(RD2D), .pc_in(PCD), .imm_ext_in(ImmExtD), .pc_plus4_in(PCPlus4D), .rs1_in(InstrD[19:15]), .rs2_in(InstrD[24:20]), .rd_in(InstrD[11:7]), .RegWriteE(RegWriteE), .ALUSrcE(ALUSrcE), .MemWriteE(MemWriteE), .BranchE(BranchE), .ResultSrcE(ResultSrcE), .ALUControlE(ALUControlE), .rd1_out(RD1E), .rd2_out(RD2E), .pc_out(PCE), .imm_ext_out(ImmExtE), .pc_plus4_out(PCPlus4E), .rs1_out(rs1E), .rs2_out(rs2E), .rd_out(rdE));

    // --- EXECUTE ---
    mux3_1 Mux_ForwardA (.sel(ForwardAE), .in0(RD1E), .in1(ResultW), .in2(ALUResultM), .out(SrcAE));
    mux3_1 Mux_ForwardB (.sel(ForwardBE), .in0(RD2E), .in1(ResultW), .in2(ALUResultM), .out(WriteDataE));
    assign SrcBE = ALUSrcE ? ImmExtE : WriteDataE;
    alu Core_ALU (.alu_op(ALUControlE), .src_a(SrcAE), .src_b(SrcBE), .alu_result(ALUResultE), .Zero(ZeroE));
    assign PCTargetE = PCE + ImmExtE;
    assign PCSrcE = BranchE & ZeroE;
    reg_ex_mem REG_EX_MEM (.clk(clk), .reset(reset), .RegWriteE(RegWriteE), .MemWriteE(MemWriteE), .ResultSrcE(ResultSrcE), .alu_res_in(ALUResultE), .write_data_in(WriteDataE), .pc_plus4_in(PCPlus4E), .rd_in(rdE), .RegWriteM(RegWriteM), .MemWriteM(MemWriteM), .ResultSrcM(ResultSrcM), .alu_res_out(ALUResultM), .write_data_out(WriteDataM), .pc_plus4_out(PCPlus4M), .rd_out(rdM));

    // --- MEMORY ACCESS ---
    Data_Memory DMEM (.clk(clk), .MemWrite(MemWriteM), .addr(ALUResultM), .write_data(WriteDataM), .read_data(ReadDataM));
    reg_mem_wb REG_MEM_WB (.clk(clk), .reset(reset), .RegWriteM(RegWriteM), .ResultSrcM(ResultSrcM), .read_data_in(ReadDataM), .alu_res_in(ALUResultM), .pc_plus4_in(PCPlus4M), .rd_in(rdM), .RegWriteW(RegWriteW), .ResultSrcW(ResultSrcW), .read_data_out(ReadDataW), .alu_res_out(ALUResultW), .pc_plus4_out(PCPlus4W), .rd_out(rdW));

    // ---WRITE BACK ---
    assign ResultW = (ResultSrcW == 2'b01) ? ReadDataW :
                     (ResultSrcW == 2'b10) ? PCPlus4W : ALUResultW;

    Hazard_Unit Hazard_Controller (.rs1D(InstrD[19:15]), .rs2D(InstrD[24:20]), .rs1E(rs1E), .rs2E(rs2E), .rdE(rdE), .rdM(rdM), .rdW(rdW), .RegWriteM(RegWriteM), .RegWriteW(RegWriteW), .ResultSrcE0(ResultSrcE[0]), .PCSrcE(PCSrcE), .ForwardAE(ForwardAE), .ForwardBE(ForwardBE), .StallF(StallF), .StallD(StallD), .FlushE(FlushE), .FlushD(FlushD));

    // ======== DEBUG ========
    assign InstrD_out = InstrD;
    assign RD1_out = RD1D;
    assign RD2_out = RD2D;
    assign SrcAE_out = SrcAE;
    assign SrcBE_out = SrcBE;
    assign ReadDataM_out = ReadDataM;
    assign ResultW_out = ResultW;

endmodule