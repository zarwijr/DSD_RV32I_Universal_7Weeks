module control_unit_alu_subset(
    input wire [6:0] op,
    input wire [2:0] funct3,
    input wire funct7_5,
    output reg RegWrite, ALUSrc,
    output reg [1:0] ImmSrc, ResultSrc,
    output reg [2:0] ALUControl);
    always @(*) begin
        RegWrite=0; ALUSrc=0; ImmSrc=2'b00;
        ResultSrc=2'b00; ALUControl=3'b000;
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
            7'b0010011: begin
                if (funct3==3'b000) begin
                    RegWrite=1; ALUSrc=1; ImmSrc=2'b00; ALUControl=3'b000;
                end
            end
            default: begin end
        endcase
    end
endmodule
