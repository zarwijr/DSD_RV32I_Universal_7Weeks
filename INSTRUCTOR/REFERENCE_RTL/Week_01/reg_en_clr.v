`timescale 1ns/1ps
module reg_en_clr #(parameter W=32)(
    input wire clk, reset_n, en, clear,
    input wire [W-1:0] d,
    output reg [W-1:0] q);
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)   q <= {W{1'b0}};
        else if (clear) q <= {W{1'b0}};
        else if (en)    q <= d;
    end
endmodule
