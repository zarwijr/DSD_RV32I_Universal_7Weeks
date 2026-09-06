module Instruction_Memory (
    input [31:0] read_address,
    output [31:0] instruction
);
    reg [31:0] Imemory [63:0];
    //assign instruction = Imemory[read_address[31:2]];
    assign instruction = Imemory[read_address[31:2]];
    initial begin
        Imemory[0] = 32'h00500093; // 0x00: addi x1, x0, 5
        Imemory[1] = 32'h00a00113; // 0x04: addi x2, x0, 10
        Imemory[2] = 32'h002081b3; // 0x08: add  x3, x1, x2  (Data Hazard)
        Imemory[3] = 32'h00302223; // 0x0C: sw   x3, 4(x0)
        Imemory[4] = 32'h00402203; // 0x10: lw   x4, 4(x0)
        Imemory[5] = 32'h401202b3; // 0x14: sub  x5, x4, x1  (Load-Use Hazard)
        Imemory[6] = 32'h00228463; // 0x18: beq  x5, x2, 8   (Control Hazard)
        Imemory[7] = 32'h06300313; // 0x1C: addi x6, x0, 99  (Flush)
        Imemory[8] = 32'h00128393; // 0x20: addi x7, x5, 1   (Target)
    end
endmodule