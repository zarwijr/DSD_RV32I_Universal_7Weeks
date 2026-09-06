module single_cycle_alu_datapath(
    input wire clk, reset_n,
    input wire [31:0] Instr,
    output wire [31:0] PC,
    output wire [31:0] Result);
    wire [31:0] PCPlus4, ImmExt, RD1, RD2, SrcB, ALUResult;
    wire [4:0] Rs1, Rs2, Rd;
    wire RegWrite, ALUSrc, Zero;
    wire [1:0] ImmSrc, ResultSrc;
    wire [2:0] ALUControl;

    assign PCPlus4=PC+32'd4;
    assign Rs1=Instr[19:15]; assign Rs2=Instr[24:20]; assign Rd=Instr[11:7];
    assign SrcB=ALUSrc?ImmExt:RD2;
    assign Result=ALUResult;

    program_counter pc0(clk,reset_n,1'b1,PCPlus4,PC);
    control_unit_alu_subset cu(Instr[6:0],Instr[14:12],Instr[30],
        RegWrite,ALUSrc,ImmSrc,ResultSrc,ALUControl);
    register_file rf(clk,reset_n,RegWrite,Rs1,Rs2,Rd,Result,RD1,RD2);
    extend ext(ImmSrc,Instr[31:7],ImmExt);
    alu alu0(ALUControl,RD1,SrcB,ALUResult,Zero);
endmodule
