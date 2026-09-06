module alu(
    input wire [2:0] alu_control,
    input wire [31:0] src_a, src_b,
    output reg [31:0] alu_result,
    output wire zero);
    always @(*) begin
        case (alu_control)
            3'b000: alu_result=src_a+src_b;
            3'b001: alu_result=src_a-src_b;
            3'b010: alu_result=src_a&src_b;
            3'b011: alu_result=src_a|src_b;
            3'b101: alu_result=($signed(src_a)<$signed(src_b))?32'd1:32'd0;
            default: alu_result=32'd0;
        endcase
    end
    assign zero=(alu_result==32'd0);
endmodule
