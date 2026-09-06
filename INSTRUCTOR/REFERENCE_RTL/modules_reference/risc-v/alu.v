module alu (
    input [2:0] alu_op,
    input [31:0] src_a, src_b,
    output reg [31:0] alu_result,
    output Zero
);
    assign Zero = (alu_result == 32'd0) ? 1'b1 : 1'b0;

    always @(*) begin
        case (alu_op)
            3'b000: alu_result = src_a + src_b;  // ADD
            3'b001: alu_result = src_a - src_b;  // SUB
            3'b010: alu_result = src_a & src_b;  // AND
            3'b011: alu_result = src_a | src_b;  // OR
            3'b101: alu_result = (src_a < src_b) ? 32'd1 : 32'd0; // SLT
            default: alu_result = 32'd0;
        endcase
    end
endmodule