`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Class: Fundamentals of Digital Logic and Processor Lab
// Designer: Xiurui Pan
// 
// Create Date: 2021/06/30
// Design Name: Pipeline CPU
// Module Name: Pipeline CPU
// Project Name: pipeline-cpu
// Revision:
// Revision 1.00 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Pipeline_CPU (reset, clk);
    //Input Clock Signals
    input reset;
    input clk;

    wire [31:0] PC_now;
    wire [31:0] PC_next;

    wire realPCWrite;

    wire IFFulsh, IDFlush;
    wire flush, stall, illop, xadr;
    wire [1:0] ForwardA, ForwardB;

    PC PCCtrl(reset, clk, illop, xadr, PC_next, PC_now);

    // IF
    wire [31:0] IFInstruction;
    InstructionMem InstructionMem(.Address(PC_next), .Instruction(IFInstruction));

    // IF/ID
    wire [31:0] IDInstruction;
    wire [31:0] IDPC;
    IFIDReg IFIDReg(.IFInstruction(IFInstruction), .IFPC(PC_now), .IDInstruction(IDInstruction), .IDPC(IDPC),
                    .clk(clk), .reset(reset), .flush(flush), .stall(stall), .illop(illop), .xadr(xadr));

    // ID
    wire IDRegWrite;
    wire IDMemWrite;
    wire IDMemRead;
    wire [1:0] IDPCSrc;
    wire [1:0] IDALUSrcA;
    wire [1:0] IDALUSrcB;
    wire [1:0] IDMemtoReg;
    wire [1:0] IDRegDst;
    wire [2:0] IDBranch;
    wire [3:0] IDALUOp;
    wire [31:0] IDDatabus1, IDDatabus2;
    wire ExtOp, LuiOp;

    //assign realPCWrite = PCWrite ? 1 : (PCWriteCond == 1 & zero == 1) ? 1 : 0; 

    Controller control(
        .reset(reset), .clk(clk), .OpCode(IDInstruction[31:26]), .Funct(IDInstruction[5:0]),
        .Branch(IDBranch), .MemWrite(IDMemWrite),.MemRead(IDMemRead), .xadr(xadr),
        .MemtoReg(IDMemtoReg), .RegDst(IDRegDst), .RegWrite(IDRegWrite), .ExtOp(ExtOp), 
        .LuiOp(LuiOp), .ALUSrcA(IDALUSrcA), .ALUSrcB(IDALUSrcB), .ALUOp(IDALUOp), .PCSource(IDPCSrc));

    wire [31:0] IDExt_out;
    ImmProcess ImmProcess(ExtOp, LuiOp, IDInstruction[15:0], IDExt_out);

    wire [31:0] Jump_target, Branch_target;
    assign Jump_target = (IDPCSrc==2'b10 && IDInstruction[31:26]==0) ? IDDatabus1 : (IDPCSrc==2'b10) ? {IDPC[31:28], IDInstruction[25:0], 2'b00} : PC_now + 4;


    wire [31:0] WBMDRo;

    //WB
    wire [31:0] WBDatabus3, WBALU_out, WBPC;
    wire [4:0] WBWrite_Reg;
    wire [1:0] WBMemtoReg;
    wire WBRegWrite;

    assign WBDatabus3 = (WBMemtoReg == 2'b00) ? WBMDRo : (WBMemtoReg == 2'b01) ? WBALU_out : (WBMemtoReg == 2'b10) ? {1'b0, WBPC[30:0]} + 32'd8 : WBPC;
    RegisterFile RF(.reset(reset), .clk(clk), .RegWrite(WBRegWrite), 
                    .Read_register1(IDInstruction[25:21]), .Read_register2(IDInstruction[20:16]), .Write_register(WBWrite_Reg), 
                    .Write_data(WBDatabus3), .Read_data1(IDDatabus1), .Read_data2(IDDatabus2));

    // ID/EX
    wire EXRegWrite;
    wire EXMemRead, EXMemWrite;
    wire EXALUSrcA, EXALUSrcB;
    wire [1:0] EXRegDst;
    wire [1:0] EXMemtoReg;
    wire [2:0] EXBranch;
    wire [3:0] EXALUOp;
    wire [4:0] EXrs, EXrt, EXrd, EXShamt;
    wire [5:0] EXFunct;
    wire [31:0] EXPC, EXDatabus1, EXDatabus2, EXExt_out;

    IDEXReg IDEXReg(.clk(clk), .reset(reset), .flush(flush), .stall(stall), .illop(illop),. xadr(xadr), 
    .IDrs(IDInstruction[25:21]), .IDrt(IDInstruction[20:16]), .IDrd(IDInstruction[15:11]), .IDShamt(IDInstruction[10:6]), .IDFunct(IDInstruction[5:0]), .IDPC(IDPC), .IDDatabus1(IDDatabus1), .IDDatabus2(IDDatabus2), .IDExt_out(IDExt_out), .IDBranch(IDBranch), .IDRegDst(IDRegDst), .IDMemtoReg(IDMemtoReg), .IDALUOp(IDALUOp), .IDRegWrite(IDRegWrite), .IDMemRead(IDMemRead), .IDMemWrite(IDMemWrite), .IDALUSrcA(IDALUSrcA), .IDALUSrcB(IDALUSrcB),
    .EXrs(EXrs), .EXrt(EXrt), .EXrd(EXrd), .EXShamt(EXShamt), .EXFunct(EXFunct), .EXPC(EXPC), .EXDatabus1(EXDatabus1), .EXDatabus2(EXDatabus2), .EXExt_out(EXExt_out), .EXBranch(EXBranch), .EXRegDst(EXRegDst), .EXMemtoReg(EXMemtoReg), .EXALUOp(EXALUOp), .EXRegWrite(EXRegWrite), .EXMemRead(EXMemRead), .EXMemWrite(EXMemWrite), .EXALUSrcA(EXALUSrcA), .EXALUSrcB(EXALUSrcB));

    // EX
    wire sign, comp;
    wire [4:0] EXWrite_Reg;
    wire [4:0] ALUConf;
    wire [31:0] ALU_in1, ALU_in2;
    wire [31:0] EXALUOut;
    wire [31:0] MEMALUOut;
    wire [31:0] ForwardAIn, ForwardBIn;

    assign Branch_target = (EXBranch==1 && comp==1) ? EXPC + 32'b100 + {EXExt_out[29:0], 2'b00} : EXPC; //这里�?对劲，ID阶段？
    
    assign EXWrite_Reg = (EXRegDst == 2'b00) ? EXrt :  (EXRegDst == 2'b01) ? EXrd : 5'b11111;
    ALUControl ALUControl(.ALUOp(EXALUOp), .Funct(EXFunct), .ALUConf(ALUConf), .Sign(sign));

    assign ForwardAIn = ForwardA[1] ? MEMALUOut : ForwardA[0] ? WBDatabus3 : EXDatabus1;
    assign ForwardBIn = ForwardB[1] ? MEMALUOut : ForwardB[0] ? WBDatabus3 : EXDatabus1;
    assign ALU_in1 = EXALUSrcA ? {27'h0, EXShamt} : ForwardAIn;
    assign ALU_in2 = EXALUSrcB ? EXExt_out : ForwardBIn;

    ALU ALU(.ALUConf(ALUConf), .Sign(sign), .In1(ALU_in1), .In2(ALU_in2), .Comp(comp), .Result(EXALUOut), .Branch(EXBranch));

    assign PC_next = (comp == 1) ? Branch_target : (IDPCSrc == 2'b10) ? Jump_target : (stall == 1) ? PC_now : PC_now + 4;
    assign IFFulsh = (comp == 1 || IDPCSrc != 0) ? 1 : 0;
    assign IDFlush = (comp == 1) ? 1 : 0;

    // EX/MEM
    wire MEMRegWrite;
    wire MEMMemRead, MEMMemWrite;
    wire [1:0] MEMMemtoReg;
    wire [4:0] MEMWrite_Reg;
    wire [31:0] MEMPC, MDRi, MDRo, MEMDatabus3;

    EXMEMReg EXMEMReg(.clk(clk), .reset(reset), .illop(illop), .xadr(xadr), .EXrd(EXrd), .EXPC(EXPC), .EXALUOut(EXALUOut), .EXDatabus3(ForwardBIn), .EXRegWrite(EXRegWrite), .EXMemRead(EXMemRead), .EXMemWrite(EXMemWrite), .EXMemtoReg(EXMemtoReg), .EXBranch_target(Branch_target), .MEMrd(MEMWrite_Reg), .MEMPC(MEMPC), .MEMALUOut(MEMALUOut), .MEMDatabus3(MEMDatabus3), .MEMRegWrite(MEMRegWrite), .MEMMemRead(MEMMemRead), .MEMMemWrite(MEMMemWrite), .MEMMemtoReg(MEMMemtoReg));

    // MEM
    wire [7:0] UART_RXD;
    wire [7:0] UART_TXD;
    wire [4:0] UART_CON;
    DataMem DataMem(.clk(clk), .reset(reset), .Address(MEMALUOut), .Write_data(MDRi), .MemRead(MEMMemRead), .MemWrite(MEMMemWrite), .Mem_data(MDRo)); //暂时没有外设

    // MEM/WB
    MEMWBReg MEMWBReg(.clk(clk), .reset(reset), .MEMrd(MEMWrite_Reg), .MEMPC(MEMPC), .MEMRead_data(MDRo), .MEMALUOut(MEMALUOut), .MEMRegWrite(MEMRegWrite), .WBrd(WBWrite_Reg), .WBPC(WBPC), .WBRead_data(WBMDRo), .WBALUOut(WBALU_out), .WBRegWrite(WBRegWrite), .WBMemtoReg(WBMemtoReg));

    Hazard Hazard(.IDrs(IDInstruction[25:21]), .IDrt(IDInstruction[20:16]), .IDrd(IDInstruction[15:11]), .EXrs(EXrs), .EXrt(EXrt), .EXrd(EXrd), .EXMemRead(EXMemRead), .MEMRegWrite(MEMRegWrite), .MEMrd(MEMWrite_Reg), .WBRegWrite(WBRegWrite), .WBrd(WBWrite_Reg), .ForwardA(ForwardA), .ForwardB(ForwardB), .stall(stall));


endmodule