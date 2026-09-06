module reg_mem_wb (
    input clk, reset,
    input RegWriteM,
    input [1:0] ResultSrcM,
    input [31:0] read_data_in, alu_res_in, pc_plus4_in,
    input [4:0] rd_in,
    
    output reg RegWriteW,
    output reg [1:0] ResultSrcW,
    output reg [31:0] read_data_out, alu_res_out, pc_plus4_out,
    output reg [4:0] rd_out
);
    always @(posedge clk or negedge reset) begin
        if (~reset) begin
            RegWriteW <= 0; ResultSrcW <= 0;
            read_data_out <= 0; alu_res_out <= 0; pc_plus4_out <= 0; rd_out <= 0;
        end else begin
            RegWriteW <= RegWriteM; ResultSrcW <= ResultSrcM;
            read_data_out <= read_data_in; alu_res_out <= alu_res_in; pc_plus4_out <= pc_plus4_in;
            rd_out <= rd_in;
        end
    end
endmodule