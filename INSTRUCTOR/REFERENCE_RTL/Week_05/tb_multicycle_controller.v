`timescale 1ns/1ps
module tb_multicycle_controller;
    reg clk,reset_n,zero,funct7_5; reg [6:0] op; reg [2:0] funct3; integer errors;
    wire PCWrite,PCSrc,IRWrite,RegWrite,MemWrite,AWrite,BWrite,ALUOutWrite,MDRWrite,AdrSrc;
    wire [1:0] ALUSrcA,ALUSrcB,ResultSrc; wire [2:0] ImmSrc,ALUControl;
    wire [3:0] state;
    multicycle_controller dut(.clk(clk),.reset_n(reset_n),.op(op),.funct3(funct3),
      .funct7_5(funct7_5),.zero(zero),.PCWrite(PCWrite),.PCSrc(PCSrc),
      .IRWrite(IRWrite),
      .RegWrite(RegWrite),.MemWrite(MemWrite),.AWrite(AWrite),.BWrite(BWrite),
      .ALUOutWrite(ALUOutWrite),.MDRWrite(MDRWrite),.AdrSrc(AdrSrc),
      .ALUSrcA(ALUSrcA),.ALUSrcB(ALUSrcB),.ResultSrc(ResultSrc),
      .ImmSrc(ImmSrc),.ALUControl(ALUControl),.state(state));
    always #5 clk=~clk;
    initial begin
        clk=0;reset_n=0;zero=0;funct3=0;funct7_5=0;op=7'b0000011;errors=0;
        #12 reset_n=1;
        @(posedge clk); #1;
        if (state!==4'd1 || ALUSrcA!==2'b01) errors=errors+1;
        @(posedge clk); #1;
        if (state!==4'd2 || ALUSrcA!==2'b10) errors=errors+1;
        repeat(3) @(posedge clk); #1;
        if (state!==4'd0) errors=errors+1;

        reset_n=0; #2; reset_n=1;
        op=7'b1100011; zero=1;
        @(posedge clk); #1;
        if (state!==4'd1 || ImmSrc!==3'b010) errors=errors+1;
        @(posedge clk); #1;
        if (state!==4'd9 || !PCWrite || !PCSrc) errors=errors+1;
        @(posedge clk); #1;
        if (state!==4'd0) errors=errors+1;
        if (errors==0) $display("TEST_PASS"); else $display("TEST_FAIL");
        $finish;
    end
    initial begin #1000;$display("TEST_TIMEOUT");$finish;end
endmodule
