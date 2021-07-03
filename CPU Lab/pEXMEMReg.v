module EXMEMReg(
    clk, reset, illop, xadr,
    EXrd, EXPC, EXALUOut, EXDatabus3, EXRegWrite, EXMemRead, EXMemWrite, EXMemtoReg, EXBranch_target, 
    MEMrd, MEMPC, MEMALUOut, MEMDatabus3, MEMRegWrite, MEMMemRead, MEMMemWrite, MEMMemtoReg
);
    input clk, reset, illop, xadr;
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
            MEMPC <= 32'h80000000;
            MEMALUOut <= 0;
            MEMDatabus3 <= 0;
            MEMRegWrite <= 0;
            MEMMemRead <= 0;
            MEMMemWrite <= 0;
            MEMMemtoReg <= 0;
        end
        else if(illop || xadr) begin
            MEMrd <= 5'd26;
            MEMPC <= EXBranch_target;
            MEMALUOut <= 0;
            MEMDatabus3 <= 0;
            MEMRegWrite <= (EXBranch_target==32'h4) ? 0 : 1;
            MEMMemRead <= 0;
            MEMMemWrite <= 0;
            MEMMemtoReg <= 2'b11;
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