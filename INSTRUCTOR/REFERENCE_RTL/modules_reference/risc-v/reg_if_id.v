module reg_if_id (
    input clk, reset, clear, en,
    input [31:0] pc_in, instr_in, pc_plus4_in,
    output reg [31:0] pc_out, instr_out, pc_plus4_out
);
    always @(posedge clk or negedge reset) begin
        if (~reset) begin
            pc_out <= 0; instr_out <= 0; pc_plus4_out <= 0;
        end else if (clear) begin
            pc_out <= 0; instr_out <= 0; pc_plus4_out <= 0;
        end else if (en) begin
            pc_out <= pc_in; instr_out <= instr_in; pc_plus4_out <= pc_plus4_in;
        end
    end
endmodule