module reg_id_ex (
    input clk, reset, clear,
    input RegWriteD, ALUSrcD, MemWriteD, BranchD,
    input [1:0] ResultSrcD,
    input [2:0] ALUControlD,
    input [31:0] rd1_in, rd2_in, pc_in, imm_ext_in, pc_plus4_in,
    input [4:0] rs1_in, rs2_in, rd_in,
    
    output reg RegWriteE, ALUSrcE, MemWriteE, BranchE,
    output reg [1:0] ResultSrcE,
    output reg [2:0] ALUControlE,
    output reg [31:0] rd1_out, rd2_out, pc_out, imm_ext_out, pc_plus4_out,
    output reg [4:0] rs1_out, rs2_out, rd_out
);
    always @(posedge clk or negedge reset) begin
        if (~reset) begin
            RegWriteE <= 0; ALUSrcE <= 0; MemWriteE <= 0; BranchE <= 0; ResultSrcE <= 0; ALUControlE <= 0;
            rd1_out <= 0; rd2_out <= 0; pc_out <= 0; imm_ext_out <= 0; pc_plus4_out <= 0;
            rs1_out <= 0; rs2_out <= 0; rd_out <= 0;
        end else if (clear) begin
            RegWriteE <= 0; ALUSrcE <= 0; MemWriteE <= 0; BranchE <= 0; ResultSrcE <= 0; ALUControlE <= 0;
            rd1_out <= 0; rd2_out <= 0; pc_out <= 0; imm_ext_out <= 0; pc_plus4_out <= 0;
            rs1_out <= 0; rs2_out <= 0; rd_out <= 0;
        end else begin
            RegWriteE <= RegWriteD; ALUSrcE <= ALUSrcD; MemWriteE <= MemWriteD; BranchE <= BranchD;
            ResultSrcE <= ResultSrcD; ALUControlE <= ALUControlD;
            rd1_out <= rd1_in; rd2_out <= rd2_in; pc_out <= pc_in; imm_ext_out <= imm_ext_in; pc_plus4_out <= pc_plus4_in;
            rs1_out <= rs1_in; rs2_out <= rs2_in; rd_out <= rd_in;
        end
    end
endmodule