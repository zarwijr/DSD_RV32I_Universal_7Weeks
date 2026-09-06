module fpga_clock_enable_demo(
    input wire CLOCK_50, input wire reset_n,
    output wire [9:0] LEDR);
    reg [25:0] counter;
    always @(posedge CLOCK_50 or negedge reset_n) begin
        if (!reset_n) counter <= 26'd0;
        else          counter <= counter + 1'b1;
    end
    assign LEDR = counter[25:16];
endmodule
