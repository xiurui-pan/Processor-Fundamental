module EXMEMReg(
    clk, reset,
    EXrd, EXPC, EXALUOut, EXDatabus3, EXRegWrite, EXMemRead, EXMemWrite, EXMemtoReg, EXBranch_target, 
    MEMrd, MEMPC, MEMALUOut, MEMDatabus3, MEMRegWrite, MEMMemRead, MEMMemWrite, MEMMemtoReg
);
    input clk, reset;
    input EXRegWrite, EXMemWrite, EXMemRead;
    input [1:0] EXMemtoReg;
    input [4:0] EXrd;
    input [31:0] EXPC, EXALUOut, EXDatabus3, EXBranch_target;
    output reg MEMRegWrite, MEMMemWrite, MEMMemRead;
    output reg [1:0] MEMMemtoReg;
    output reg [4:0] MEMrd;
    output reg [31:0] MEMPC, MEMALUOut, MEMDatabus3;

    always @(posedge clk or posedge reset) begin
        if(reset)begin
            MEMrd <= 0;
            MEMPC <= 32'h00000000;
            MEMALUOut <= 0;
            MEMDatabus3 <= 0;
            MEMRegWrite <= 0;
            MEMMemRead <= 0;
            MEMMemWrite <= 0;
            MEMMemtoReg <= 0;
        end
        else begin
            MEMrd <= EXrd;
            MEMPC <= EXPC;
            MEMALUOut <= EXALUOut;
            MEMDatabus3 <= EXDatabus3;
            MEMRegWrite <= EXRegWrite;
            MEMMemRead <= EXMemRead;
            MEMMemWrite <= EXMemWrite;
            MEMMemtoReg <= EXMemtoReg;
        end
    end

endmodule