module holding_registers(
    input wire clk, reset_n, IRWrite,AWrite,BWrite,ALUOutWrite,MDRWrite,
    input wire [31:0] MemData, PC, RD1, RD2, ALUResult,
    output reg [31:0] IR, OldPC, A, B, ALUOut, MDR);
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin IR<=0; OldPC<=0; A<=0; B<=0; ALUOut<=0; MDR<=0; end
        else begin
            if (IRWrite) begin IR<=MemData; OldPC<=PC; end
            if (AWrite) A<=RD1;
            if (BWrite) B<=RD2;
            if (ALUOutWrite) ALUOut<=ALUResult;
            if (MDRWrite) MDR<=MemData;
        end
    end
endmodule
