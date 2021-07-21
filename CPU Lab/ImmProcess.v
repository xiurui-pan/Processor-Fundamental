`timescale 1ns / 1ps

module ImmProcess(ExtOp, LuiOp, Immediate, ImmExtOut, branch); 
    //Input Control Signals
    input ExtOp; //'0'-zero extension, '1'-signed extension
    input LuiOp; //for lui instruction
    input [2:0] branch;
    //Input
    input [15:0] Immediate;
    //Output
    output [31:0] ImmExtOut;

    wire [31:0] ImmExt;
    wire [31:0] ImmExtShift;

    assign ImmExt = {ExtOp? {16{Immediate[15]}}: 16'h0000, Immediate};
    assign ImmExtShift = ImmExt << 2;
    assign ImmExtOut = (branch!=0) ? ImmExtShift : LuiOp? {Immediate, 16'h0000}: ImmExt;


endmodule
