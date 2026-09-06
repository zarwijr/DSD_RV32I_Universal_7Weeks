module nop_scheduled_program(input wire [31:0] PC,output reg [31:0] Instr);
    always @(*) begin
        case (PC[6:2])
          0:Instr=32'h00500093; // addi x1,x0,5
          1:Instr=32'h00000013; 2:Instr=32'h00000013; 3:Instr=32'h00000013;
          4:Instr=32'h00700113; // addi x2,x0,7
          5:Instr=32'h00000013; 6:Instr=32'h00000013; 7:Instr=32'h00000013;
          8:Instr=32'h002081B3; // add x3,x1,x2
          default:Instr=32'h00000013;
        endcase
    end
endmodule
