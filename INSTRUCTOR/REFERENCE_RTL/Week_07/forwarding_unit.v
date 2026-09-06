module forwarding_unit(
    input wire [4:0] Rs1E,Rs2E,RdM,RdW,
    input wire RegWriteM,RegWriteW,
    output reg [1:0] ForwardAE,ForwardBE);
    always @(*) begin
        ForwardAE=2'b00; ForwardBE=2'b00;
        if (RegWriteM && RdM!=0 && RdM==Rs1E) ForwardAE=2'b10;
        else if (RegWriteW && RdW!=0 && RdW==Rs1E) ForwardAE=2'b01;
        if (RegWriteM && RdM!=0 && RdM==Rs2E) ForwardBE=2'b10;
        else if (RegWriteW && RdW!=0 && RdW==Rs2E) ForwardBE=2'b01;
    end
endmodule
