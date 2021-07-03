module MEMWBReg (
    clk, reset,
    MEMrd, MEMPC, MEMRead_data, MEMALUOut, MEMRegWrite, MEMMemtoReg,
    WBrd, WBPC, WBRead_data, WBALUOut, WBRegWrite, WBMemtoReg
);
    input clk, reset;
    input MEMRegWrite;
    input [1:0] MEMMemtoReg;
    input [4:0] MEMrd;
    input [31:0] MEMPC, MEMRead_data, MEMALUOut;
    output reg WBRegWrite;
    output reg [4:0] WBrd;
    output reg [1:0] WBMemtoReg;
    output reg [31:0] WBPC, WBRead_data, WBALUOut;

    always @(posedge clk or posedge reset) begin
        if(reset)begin
            WBRegWrite <= 0;
            WBrd <= 0;
            WBMemtoReg <= 0;
            WBPC <= 32'h80000000;
            WBRead_data <= 0;
            WBALUOut <= 0;
        end
        else begin
            WBRegWrite <= MEMRegWrite;
            WBrd <= MEMrd;
            WBMemtoReg <= MEMMemtoReg;
            WBPC <= MEMPC;
            WBRead_data <= MEMRead_data;
            WBALUOut <= MEMALUOut;
        end
    end

endmodule