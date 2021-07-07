module IDEXReg (
    clk, reset, flush, stall, illop, xadr,
    IDrs, IDrt, IDrd, IDShamt, IDFunct, IDPC, IDDatabus1, IDDatabus2, IDExt_out, IDBranch, IDRegWrite, IDRegDst, IDMemRead, IDMemWrite, IDMemtoReg, IDALUSrcA, IDALUSrcB, IDALUOp,
    EXrs, EXrt, EXrd, EXShamt, EXFunct, EXPC, EXDatabus1, EXDatabus2, EXExt_out, EXBranch, EXRegWrite, EXRegDst, EXMemRead, EXMemWrite, EXMemtoReg, EXALUSrcA, EXALUSrcB, EXALUOp
);
    input clk, reset;
    input flush, stall, illop, xadr;
    input [4:0] IDrs, IDrt, IDrd, IDShamt;
    input [5:0] IDFunct;
    input [31:0] IDPC, IDDatabus1, IDDatabus2, IDExt_out;
    input [2:0] IDBranch;
    input [1:0] IDRegDst, IDMemtoReg;
    input [3:0] IDALUOp;
    input IDRegWrite, IDMemRead, IDMemWrite;
    input IDALUSrcA, IDALUSrcB;
    output reg [4:0] EXrs, EXrt, EXrd, EXShamt;
    output reg [5:0] EXFunct;
    output reg [31:0] EXPC, EXDatabus1, EXDatabus2, EXExt_out;
    output reg [2:0] EXBranch;
    output reg [1:0] EXRegDst, EXMemtoReg;
    output reg [3:0] EXALUOp;
    output reg EXRegWrite, EXMemRead, EXMemWrite;
    output reg EXALUSrcA, EXALUSrcB;

    always @(posedge clk or posedge reset) begin
        if(reset || flush || stall || illop || xadr)begin
            EXrs <= 0;
            EXrt <= 0;
            EXrd <= 0;
            EXShamt <= 0;
            EXFunct <= 0;
            EXDatabus1 <= 0;
            EXDatabus2 <= 0;
            EXExt_out <= 0;
            EXBranch <= 0;
            EXRegDst <= 0;
            EXMemtoReg <= 0;
            EXALUOp <= 0;
            EXRegWrite <= 0;
            EXMemRead <= 0;
            EXMemWrite <= 0;
            EXALUSrcA <= 0;
            EXALUSrcB <= 0;
            if(reset)
                EXPC <= 32'h00000000;
            else
                EXPC <= 0;
        end
        else begin
            EXrs <= IDrs;
            EXrt <= IDrt;
            EXrd <= IDrd;
            EXPC <= IDPC;
            EXShamt <= IDShamt;
            EXFunct <= IDFunct;
            EXDatabus1 <= IDDatabus1;
            EXDatabus2 <= IDDatabus2;
            EXExt_out <= IDExt_out;
            EXBranch <= IDBranch;
            EXRegDst <= IDRegDst;
            EXMemtoReg <= IDMemtoReg;
            EXALUOp <= IDALUOp;
            EXRegWrite <= IDRegWrite;
            EXMemRead <= IDMemRead;
            EXMemWrite <= IDMemWrite;
            EXALUSrcA <= IDALUSrcA;
            EXALUSrcB <= IDALUSrcB;
        end

    end
    
endmodule