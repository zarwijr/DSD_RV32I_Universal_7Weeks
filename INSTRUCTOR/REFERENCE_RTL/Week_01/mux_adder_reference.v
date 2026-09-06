`timescale 1ns/1ps
module mux2_dataflow #(parameter W=32)(
    input wire [W-1:0] a, b, input wire sel,
    output wire [W-1:0] y);
    assign y = sel ? b : a;
endmodule

module mux2_behavioral #(parameter W=32)(
    input wire [W-1:0] a, b, input wire sel,
    output reg [W-1:0] y);
    always @(*) begin
        if (sel) y = b;
        else     y = a;
    end
endmodule

module adder32(input wire [31:0] a, b, output wire [31:0] sum);
    assign sum = a + b;
endmodule
