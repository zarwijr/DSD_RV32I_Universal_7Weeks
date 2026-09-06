module hazard_datapath_connections(
    input wire [31:0] RD1E,RD2E,ResultW,ALUResultM,ImmExtE,
    input wire [1:0] ForwardAE,ForwardBE,input wire ALUSrcE,
    output reg [31:0] SrcAE,ForwardedB,
    output wire [31:0] WriteDataE,SrcBE);
    always @(*) begin
        case(ForwardAE)
          2'b01:SrcAE=ResultW; 2'b10:SrcAE=ALUResultM; default:SrcAE=RD1E;
        endcase
        case(ForwardBE)
          2'b01:ForwardedB=ResultW; 2'b10:ForwardedB=ALUResultM;
          default:ForwardedB=RD2E;
        endcase
    end
    assign WriteDataE=ForwardedB;
    assign SrcBE=ALUSrcE?ImmExtE:ForwardedB;
endmodule
