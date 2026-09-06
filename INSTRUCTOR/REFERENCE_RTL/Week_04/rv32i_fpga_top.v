module rv32i_fpga_top(
    input wire CLOCK_50,
    input wire [3:0] KEY,
    input wire [9:0] SW,
    output wire [9:0] LEDR);
    wire reset_n=KEY[0];
    wire [31:0] PC,Instr,ALUResult,WriteData,ReadData,Result;
    wire MemWrite;
    wire [31:0] selected=SW[0]?Result:PC;
    instruction_memory imem(PC,Instr);
    data_memory dmem(CLOCK_50,MemWrite,ALUResult,WriteData,ReadData);
    single_cycle_core core(CLOCK_50,reset_n,Instr,ReadData,
      PC,ALUResult,WriteData,Result,MemWrite);
    assign LEDR=selected[9:0];
endmodule
