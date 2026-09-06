`timescale 1ns/1ps
module register_file(
    input wire clk, reset_n, write_enable,
    input wire [4:0] read_addr1, read_addr2, write_addr,
    input wire [31:0] write_data,
    output wire [31:0] read_data1, read_data2);
    reg [31:0] regs [0:31];
    integer i;
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            for (i=0; i<32; i=i+1) regs[i] <= 32'd0;
        else if (write_enable && (write_addr != 5'd0))
            regs[write_addr] <= write_data;
    end
    assign read_data1 = (read_addr1==0) ? 32'd0 : regs[read_addr1];
    assign read_data2 = (read_addr2==0) ? 32'd0 : regs[read_addr2];
endmodule
