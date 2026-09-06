module Control_Unit (
    input [6:0] op,
    input [2:0] funct3,
    input funct7_5,
    input Zero,
    output reg RegWrite, ALUSrc, MemWrite,
    output reg [1:0] ImmSrc, ResultSrc,
    output reg [2:0] ALUControl,
    output reg Branch,
    output PCSrc
);

    assign PCSrc = Branch & Zero;

    always @(*) begin
        RegWrite   = 0;
        ImmSrc     = 2'b00;
        ALUSrc     = 0;
        MemWrite   = 0;
        ResultSrc  = 2'b00;
        Branch     = 0;
        ALUControl = 3'b000;

        case (op)
            7'b0000011: begin // Load Word (lw)
                RegWrite   = 1;
                ImmSrc     = 2'b00;
                ALUSrc     = 1;
                ResultSrc  = 2'b01; 
                ALUControl = 3'b000;
            end
            
            7'b0100011: begin // Store Word (sw)
                ImmSrc     = 2'b01;
                ALUSrc     = 1;
                MemWrite   = 1;
                ALUControl = 3'b000;
            end

            7'b0110011: begin // R-Type (add, sub, and, or)
                RegWrite   = 1;
                ALUSrc     = 0; 
                ResultSrc  = 2'b00; 
                case (funct3)
                    3'b000: ALUControl = (funct7_5) ? 3'b001 : 3'b000; // 001: SUB, 000: ADD
                    3'b111: ALUControl = 3'b010; // AND
                    3'b110: ALUControl = 3'b011; // OR
                    3'b010: ALUControl = 3'b101; // SLT
                    default: ALUControl = 3'b000;
                endcase
            end

            7'b0010011: begin // I-Type (addi)
                RegWrite   = 1;
                ImmSrc     = 2'b00;
                ALUSrc     = 1; 
                ResultSrc  = 2'b00;
                case (funct3)
                    3'b000: ALUControl = 3'b000; // addi
                    default: ALUControl = 3'b000;
                endcase
            end

            7'b1100011: begin // B-Type (beq)
                ImmSrc     = 2'b10;
                ALUSrc     = 0;
                Branch     = 1;
                ALUControl = 3'b001;
            end
            
            default: begin
                RegWrite = 0; MemWrite = 0; Branch = 0;
            end
        endcase
    end
endmodule