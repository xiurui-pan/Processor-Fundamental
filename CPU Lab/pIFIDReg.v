module IFIDReg(IFInstruction, IFPC, IDInstruction, IDPC, clk, reset, flush, stall);
    input clk, reset;
    input flush, stall;
    input [31:0] IFInstruction, IFPC;
    output reg [31:0] IDInstruction, IDPC;

    always @(posedge clk or posedge reset) begin
        if(reset) begin
            IDPC <= 32'h00000000;
            IDInstruction <= 0;
        end
        else if(flush)begin
            IDPC <= 0;
            IDInstruction <= 0;
        end
        else begin
            IDInstruction <= stall ? IDInstruction : IFInstruction;
            IDPC <= stall ? IDPC : IFPC;
        end
    end

endmodule