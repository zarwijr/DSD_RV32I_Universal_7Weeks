module baseline_signature_monitor(
    input wire clk, reset_n,
    input wire [31:0] x1,x2,x3,x4,x5,x6,x7,x8,x9,mem0,
    output reg done, pass);
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin done<=0; pass<=0; end
        else if (!done && x9==32'd1) begin
            done<=1;
            pass<=(x1==5 && x2==7 && x3==12 && mem0==12 && x4==12 &&
                   x5==0 && x6==7 && x7==4 && x8==7);
        end
    end
endmodule
