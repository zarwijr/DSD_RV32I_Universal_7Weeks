module Data_Memory (
    input clk, MemWrite,
    input [31:0] addr, write_data,
    output [31:0] read_data
);
    reg [31:0] RAM [63:0];
    integer i;

    initial begin
        for (i = 0; i < 64; i = i + 1) RAM[i] = 32'd0;
    end

    assign read_data = RAM[addr[31:2]];

    always @(posedge clk) begin
        if (MemWrite)
            RAM[addr[31:2]] <= write_data;
    end
endmodule