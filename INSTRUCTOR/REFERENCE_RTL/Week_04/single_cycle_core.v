module control_unit_full(
    input wire [6:0] op,
    input wire [2:0] funct3,
    input wire funct7_5,
    output reg RegWrite, ALUSrc, MemWrite, Branch,
    output reg [1:0] ImmSrc, ResultSrc,
    output reg [2:0] ALUControl);
    always @(*) begin
        RegWrite=0; ALUSrc=0; MemWrite=0; Branch=0;
        ImmSrc=2'b00; ResultSrc=2'b00; ALUControl=3'b000;
        case (op)
          7'b0110011: begin
            case (funct3)
              3'b000: begin RegWrite=1; ALUControl=funct7_5?3'b001:3'b000; end
              3'b111: begin RegWrite=1; ALUControl=3'b010; end
              3'b110: begin RegWrite=1; ALUControl=3'b011; end
              3'b010: begin RegWrite=1; ALUControl=3'b101; end
              default: begin end
            endcase
          end
          7'b0010011: if (funct3==3'b000) begin
            RegWrite=1; ALUSrc=1; ImmSrc=2'b00; ALUControl=3'b000;
          end
          7'b0000011: if (funct3==3'b010) begin
            RegWrite=1; ALUSrc=1; ImmSrc=2'b00;
            ResultSrc=2'b01; ALUControl=3'b000;
          end
          7'b0100011: if (funct3==3'b010) begin
            MemWrite=1; ALUSrc=1; ImmSrc=2'b01; ALUControl=3'b000;
          end
          7'b1100011: if (funct3==3'b000) begin
            Branch=1; ImmSrc=2'b10; ALUControl=3'b001;
          end
          default: begin end
        endcase
    end
endmodule

module single_cycle_core(
    input wire clk, reset_n,
    input wire [31:0] Instr, ReadData,
    output wire [31:0] PC, ALUResult, WriteData, Result,
    output wire MemWrite);
    wire [31:0] PCPlus4, PCTarget, PCNext, ImmExt, RD1, RD2, SrcB;
    wire [1:0] ImmSrc, ResultSrc;
    wire [2:0] ALUControl;
    wire RegWrite, ALUSrc, Branch, Zero, PCSrc;

    assign PCPlus4=PC+32'd4;
    assign PCTarget=PC+ImmExt;
    assign PCSrc=Branch&Zero;
    assign PCNext=PCSrc?PCTarget:PCPlus4;
    assign SrcB=ALUSrc?ImmExt:RD2;
    assign WriteData=RD2;
    assign Result=(ResultSrc==2'b01)?ReadData:
                  (ResultSrc==2'b10)?PCPlus4:ALUResult;

    program_counter pc0(clk,reset_n,1'b1,PCNext,PC);
    control_unit_full cu(Instr[6:0],Instr[14:12],Instr[30],
      RegWrite,ALUSrc,MemWrite,Branch,ImmSrc,ResultSrc,ALUControl);
    register_file rf(clk,reset_n,RegWrite,Instr[19:15],Instr[24:20],
      Instr[11:7],Result,RD1,RD2);
    extend ext(ImmSrc,Instr[31:7],ImmExt);
    alu alu0(ALUControl,RD1,SrcB,ALUResult,Zero);
endmodule
