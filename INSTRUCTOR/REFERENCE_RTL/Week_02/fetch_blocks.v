`timescale 1ns/1ps
module program_counter(
    input wire clk, reset_n, enable,
    input wire [31:0] next_pc,
    output reg [31:0] pc);
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)  pc <= 32'd0;
        else if (enable) pc <= next_pc;
    end
endmodule

module instruction_memory #(parameter DEPTH=64)(
    input wire [31:0] address,
    output wire [31:0] instruction);
    reg [31:0] memory [0:DEPTH-1];
    integer i;
    initial begin
        for (i=0; i<DEPTH; i=i+1) memory[i]=32'h00000013;
        $readmemh("program.hex", memory);
    end
    assign instruction = (address[31:2] < DEPTH) ?
                         memory[address[31:2]] : 32'h00000013;
endmodule
