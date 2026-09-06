module reg_if_id(
    input wire clk,reset_n,clear,en,
    input wire [31:0] pc_in,instr_in,pc_plus4_in,
    output reg [31:0] pc_out,instr_out,pc_plus4_out);
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n || clear) begin pc_out<=0;instr_out<=32'h00000013;pc_plus4_out<=0;end
        else if (en) begin pc_out<=pc_in;instr_out<=instr_in;pc_plus4_out<=pc_plus4_in;end
    end
endmodule

module reg_id_ex(
    input wire clk,reset_n,clear,
    input wire RegWriteD,ALUSrcD,MemWriteD,BranchD,
    input wire [1:0] ResultSrcD,input wire [2:0] ALUControlD,
    input wire [31:0] RD1D,RD2D,PCD,ImmExtD,PCPlus4D,
    input wire [4:0] Rs1D,Rs2D,RdD,
    output reg RegWriteE,ALUSrcE,MemWriteE,BranchE,
    output reg [1:0] ResultSrcE,output reg [2:0] ALUControlE,
    output reg [31:0] RD1E,RD2E,PCE,ImmExtE,PCPlus4E,
    output reg [4:0] Rs1E,Rs2E,RdE);
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n || clear) begin
          RegWriteE<=0;ALUSrcE<=0;MemWriteE<=0;BranchE<=0;ResultSrcE<=0;
          ALUControlE<=0;RD1E<=0;RD2E<=0;PCE<=0;ImmExtE<=0;PCPlus4E<=0;
          Rs1E<=0;Rs2E<=0;RdE<=0;
        end else begin
          RegWriteE<=RegWriteD;ALUSrcE<=ALUSrcD;MemWriteE<=MemWriteD;
          BranchE<=BranchD;ResultSrcE<=ResultSrcD;ALUControlE<=ALUControlD;
          RD1E<=RD1D;RD2E<=RD2D;PCE<=PCD;ImmExtE<=ImmExtD;PCPlus4E<=PCPlus4D;
          Rs1E<=Rs1D;Rs2E<=Rs2D;RdE<=RdD;
        end
    end
endmodule

module reg_ex_mem(
    input wire clk,reset_n,
    input wire RegWriteE,MemWriteE,input wire [1:0] ResultSrcE,
    input wire [31:0] ALUResultE,WriteDataE,PCPlus4E,input wire [4:0] RdE,
    output reg RegWriteM,MemWriteM,output reg [1:0] ResultSrcM,
    output reg [31:0] ALUResultM,WriteDataM,PCPlus4M,output reg [4:0] RdM);
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin RegWriteM<=0;MemWriteM<=0;ResultSrcM<=0;
          ALUResultM<=0;WriteDataM<=0;PCPlus4M<=0;RdM<=0;end
        else begin RegWriteM<=RegWriteE;MemWriteM<=MemWriteE;ResultSrcM<=ResultSrcE;
          ALUResultM<=ALUResultE;WriteDataM<=WriteDataE;PCPlus4M<=PCPlus4E;RdM<=RdE;end
    end
endmodule

module reg_mem_wb(
    input wire clk,reset_n,input wire RegWriteM,input wire [1:0] ResultSrcM,
    input wire [31:0] ReadDataM,ALUResultM,PCPlus4M,input wire [4:0] RdM,
    output reg RegWriteW,output reg [1:0] ResultSrcW,
    output reg [31:0] ReadDataW,ALUResultW,PCPlus4W,output reg [4:0] RdW);
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin RegWriteW<=0;ResultSrcW<=0;ReadDataW<=0;
          ALUResultW<=0;PCPlus4W<=0;RdW<=0;end
        else begin RegWriteW<=RegWriteM;ResultSrcW<=ResultSrcM;ReadDataW<=ReadDataM;
          ALUResultW<=ALUResultM;PCPlus4W<=PCPlus4M;RdW<=RdM;end
    end
endmodule
