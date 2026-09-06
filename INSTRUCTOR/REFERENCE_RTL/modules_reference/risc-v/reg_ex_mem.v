module reg_ex_mem (
    input clk, reset,
    input RegWriteE, MemWriteE,
    input [1:0] ResultSrcE,
    input [31:0] alu_res_in, write_data_in, pc_plus4_in,
    input [4:0] rd_in,
    
    output reg RegWriteM, MemWriteM,
    output reg [1:0] ResultSrcM,
    output reg [31:0] alu_res_out, write_data_out, pc_plus4_out,
    output reg [4:0] rd_out
);
    always @(posedge clk or negedge reset) begin
        if (~reset) begin
            RegWriteM <= 0; MemWriteM <= 0; ResultSrcM <= 0;
            alu_res_out <= 0; write_data_out <= 0; pc_plus4_out <= 0; rd_out <= 0;
        end else begin
            RegWriteM <= RegWriteE; MemWriteM <= MemWriteE; ResultSrcM <= ResultSrcE;
            alu_res_out <= alu_res_in; write_data_out <= write_data_in; pc_plus4_out <= pc_plus4_in;
            rd_out <= rd_in;
        end
    end
endmodule