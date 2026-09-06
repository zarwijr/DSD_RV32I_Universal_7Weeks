`timescale 1ns/1ps
module tb_hazard_unit;
    reg [4:0] Rs1D,Rs2D,Rs1E,Rs2E,RdE,RdM,RdW;
    reg RegWriteM,RegWriteW,ResultSrcE0,PCSrcE,UseRs1D,UseRs2D;
    wire [1:0] ForwardAE,ForwardBE; wire StallF,StallD,FlushE,FlushD;
    integer errors;
    hazard_unit dut(Rs1D,Rs2D,Rs1E,Rs2E,RdE,RdM,RdW,RegWriteM,RegWriteW,
      ResultSrcE0,PCSrcE,UseRs1D,UseRs2D,ForwardAE,ForwardBE,
      StallF,StallD,FlushE,FlushD);
    initial begin
      errors=0;Rs1D=0;Rs2D=0;Rs1E=5;Rs2E=0;RdE=0;RdM=5;RdW=5;
      RegWriteM=1;RegWriteW=1;ResultSrcE0=0;PCSrcE=0;UseRs1D=1;UseRs2D=1;#1;
      if(ForwardAE!==2'b10)errors=errors+1;
      RdM=0;Rs1D=7;RdE=7;ResultSrcE0=1;#1;
      if(!(StallF&&StallD&&FlushE))errors=errors+1;
      RdE=0;#1;if(StallF)errors=errors+1;
      PCSrcE=1;#1;if(!(FlushD&&FlushE))errors=errors+1;
      if(errors==0)$display("TEST_PASS");else $display("TEST_FAIL errors=%0d",errors);
      $finish;
    end
    initial begin #1000;$display("TEST_TIMEOUT");$finish;end
endmodule
