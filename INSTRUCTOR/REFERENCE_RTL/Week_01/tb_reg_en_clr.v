`timescale 1ns/1ps
module tb_reg_en_clr;
    reg clk, reset_n, en, clear;
    reg [31:0] d;
    wire [31:0] q;
    integer errors;

    reg_en_clr dut(clk, reset_n, en, clear, d, q);
    always #5 clk = ~clk;

    task check32;
        input [31:0] expected;
        begin
            #1;
            if (q !== expected) begin
                errors = errors + 1;
                $display("MISMATCH q=%h expected=%h", q, expected);
            end
        end
    endtask

    initial begin
        clk=0; reset_n=0; en=0; clear=0; d=0; errors=0;
        #2; check32(32'd0);
        #8; reset_n=1; d=32'h12345678; en=1;
        @(posedge clk); check32(32'h12345678);
        en=0; d=32'hAAAAAAAA;
        @(posedge clk); check32(32'h12345678);
        en=1; clear=1;
        @(posedge clk); check32(32'd0);
        if (errors==0) $display("TEST_PASS");
        else           $display("TEST_FAIL errors=%0d", errors);
        $finish;
    end
    initial begin #1000; $display("TEST_TIMEOUT"); $finish; end
endmodule
