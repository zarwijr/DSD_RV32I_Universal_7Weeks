module Register_File (
    input clk,
    input RegWrite,
    input [4:0] read_addr_1, read_addr_2, write_addr,
    input [31:0] write_data,
    output [31:0] read_data_1, read_data_2
);
    reg [31:0] Regfile [31:0];
    integer k;

    initial begin
        for (k = 0; k < 32; k = k + 1) Regfile[k] = 32'd0;
    end

    assign read_data_1 = (read_addr_1 == 5'd0) ? 32'd0 : Regfile[read_addr_1];
    assign read_data_2 = (read_addr_2 == 5'd0) ? 32'd0 : Regfile[read_addr_2];

    always @(posedge clk) begin
        if (RegWrite) begin
            Regfile[write_addr] <= write_data;
        end
    end
endmodule