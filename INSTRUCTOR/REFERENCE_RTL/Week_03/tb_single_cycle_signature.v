`timescale 1ns/1ps
module tb_single_cycle_signature;
    reg clk, reset_n; reg [31:0] Instr;
    wire [31:0] PC, Result;
    integer errors;
    single_cycle_alu_datapath dut(clk,reset_n,Instr,PC,Result);
    always #5 clk=~clk;
    initial begin
        clk=0; reset_n=0; Instr=32'h00000013; errors=0;
        #12 reset_n=1;
        Instr=32'h00500093; @(posedge clk); #1; // addi x1,x0,5
        Instr=32'h00700113; @(posedge clk); #1; // addi x2,x0,7
        Instr=32'h002081B3; @(posedge clk); #1; // add x3,x1,x2
        if (dut.rf.regs[3] !== 32'd12) errors=errors+1;
        Instr=32'h00000000; @(posedge clk); #1; // illegal/unsupported: no state change
        if (dut.rf.regs[3] !== 32'd12) errors=errors+1;
        if (errors==0) $display("TEST_PASS");
        else $display("TEST_FAIL errors=%0d",errors);
        $finish;
    end
    initial begin #1000; $display("TEST_TIMEOUT"); $finish; end
endmodule
