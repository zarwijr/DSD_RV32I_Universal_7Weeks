module extend(
    input wire [1:0] ImmSrc,
    input wire [24:0] Imm,
    output reg [31:0] ImmExt);
    always @(*) begin
        case (ImmSrc)
            2'b00: ImmExt={{20{Imm[24]}},Imm[24:13]};
            2'b01: ImmExt={{20{Imm[24]}},Imm[24:18],Imm[4:0]};
            2'b10: ImmExt={{20{Imm[24]}},Imm[0],Imm[23:18],
                           Imm[4:1],1'b0};
            default: ImmExt=32'd0;
        endcase
    end
endmodule
