module data_memory #(parameter WORDS=64)(
    input wire clk, MemWrite,
    input wire [31:0] addr, write_data,
    output wire [31:0] read_data);
    reg [31:0] RAM [0:WORDS-1];
    integer i;
    initial for (i=0;i<WORDS;i=i+1) RAM[i]=32'd0;
    assign read_data=(addr[31:2]<WORDS)?RAM[addr[31:2]]:32'd0;
    always @(posedge clk)
        if (MemWrite && (addr[31:2]<WORDS)) RAM[addr[31:2]]<=write_data;
endmodule
