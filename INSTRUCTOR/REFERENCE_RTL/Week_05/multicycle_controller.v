module multicycle_controller(
    input wire clk, reset_n,
    input wire [6:0] op, input wire [2:0] funct3, input wire funct7_5,
    input wire zero,
    output reg PCWrite, PCSrc, IRWrite, RegWrite, MemWrite,
    output reg AWrite, BWrite, ALUOutWrite, MDRWrite,
    output reg AdrSrc,
    output reg [1:0] ALUSrcA, ALUSrcB, ResultSrc,
    output reg [2:0] ImmSrc, ALUControl,
    output reg [3:0] state);
    localparam IFETCH=4'd0, IDECODE=4'd1, MEMADR=4'd2, MEMRD=4'd3,
               MEMWB=4'd4, MEMWR=4'd5, EXEC_R=4'd6, ALUWB=4'd7,
               EXEC_I=4'd8, BRANCH=4'd9;
    reg [3:0] next_state;
    always @(posedge clk or negedge reset_n)
        if (!reset_n) state<=IFETCH; else state<=next_state;

    always @(*) begin
        next_state=IFETCH;
        case (state)
            IFETCH: next_state=IDECODE;
            IDECODE: case(op)
                7'b0000011,7'b0100011: next_state=MEMADR;
                7'b0110011: next_state=EXEC_R;
                7'b0010011: next_state=EXEC_I;
                7'b1100011: next_state=BRANCH;
                default: next_state=IFETCH;
            endcase
            MEMADR: next_state=(op==7'b0000011)?MEMRD:MEMWR;
            MEMRD: next_state=MEMWB;
            MEMWB,MEMWR,ALUWB,BRANCH: next_state=IFETCH;
            EXEC_R,EXEC_I: next_state=ALUWB;
            default: next_state=IFETCH;
        endcase
    end

    always @(*) begin
        PCWrite=0; PCSrc=0; IRWrite=0; RegWrite=0; MemWrite=0; AdrSrc=0;
        AWrite=0; BWrite=0; ALUOutWrite=0; MDRWrite=0;
        // ALUSrcA: 00=PC, 01=OldPC, 10=A.
        ALUSrcA=2'b00; ALUSrcB=2'b00; ResultSrc=2'b00;
        ImmSrc=3'b000; ALUControl=3'b000;
        case (state)
            IFETCH: begin IRWrite=1; PCWrite=1; ALUSrcB=2'b10; end
            IDECODE: begin
                AWrite=1; BWrite=1; ALUSrcA=2'b01; ALUSrcB=2'b01;
                if (op==7'b1100011) ImmSrc=3'b010;
                else if (op==7'b0100011) ImmSrc=3'b001;
                else ImmSrc=3'b000;
                ALUOutWrite=1;
            end
            MEMADR: begin ALUSrcA=2'b10; ALUSrcB=2'b01; ALUOutWrite=1;
                ImmSrc=(op==7'b0100011)?3'b001:3'b000; end
            MEMRD: begin AdrSrc=1; MDRWrite=1; end
            MEMWB: begin RegWrite=1; ResultSrc=2'b01; end
            MEMWR: begin AdrSrc=1; MemWrite=1; end
            EXEC_R: begin
                ALUSrcA=2'b10; ALUSrcB=2'b00; ALUOutWrite=1;
                case(funct3)
                  3'b000: ALUControl=funct7_5?3'b001:3'b000;
                  3'b111: ALUControl=3'b010;
                  3'b110: ALUControl=3'b011;
                  3'b010: ALUControl=3'b101;
                  default: ALUControl=3'b000;
                endcase
            end
            EXEC_I: begin ALUSrcA=2'b10; ALUSrcB=2'b01; ALUControl=3'b000;
                ALUOutWrite=1; end
            ALUWB: begin RegWrite=1; ResultSrc=2'b00; end
            BRANCH: begin ALUSrcA=2'b10; ALUSrcB=2'b00; ALUControl=3'b001;
                PCSrc=1; if (zero) PCWrite=1; end
            default: begin end
        endcase
    end
endmodule
