`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Class: Fundamentals of Digital Logic and Processor
// Designer: Shulin Zeng
// 
// Create Date: 2021/04/30
// Design Name: MultiCycleCPU
// Module Name: MultiCycleCPU
// Project Name: Multi-cycle-cpu
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module MultiCycleCPU (reset, clk);
    //Input Clock Signals
    input reset;
    input clk;

    reg  [31:0] PC;
    wire [31:0] PC_next;

    wire PCWrite;
    wire PCWriteCond;
    wire IorD;
    wire MemWrite;
    wire MemRead;
    wire IRWrite;
    wire RegDst;
    wire RegWrite;
    wire ExtOp;
    wire LuiOp;
    wire [1:0] MemtoReg;
    wire [1:0] ALUSrcA;
    wire [1:0] ALUSrcB;
    wire [3:0] ALUOp;
    wire [1:0] PCSrc;
    wire [4:0] ALUConf;

    wire [31:0] Address;
    wire [31:0] MemData;

    PC PCCtrl(reset, clk, PCWrite, PC_next, PC);

    Controller control(
        .reset(reset), .clk(clk), .OpCode(MemData[31:26]), .Funct(MemData[5:0]), .PCSrc(PCSrc),
        .PCWrite(PCWrite), .PCWriteCond(PCWriteCond), .IorD(IorD), .MemWrite(MemWrite),.MemRead(MemRead), 
        .IRWrite(IRWrite), .MemtoReg(MemtoReg), .RegDst(RegDst), .RegWrite(RegWrite), .ExtOp(ExtOp), 
        .LuiOp(LuiOp), .ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB), .ALUOp(ALUOp), .PCSource(PCSrc));


    assign address = IorD ? ALU_outo : PC;
    InstAndDataMemory Memory(.reset(reset), .clk(clk), .Address(address), .WriteData(RF2o),
                             .MemRead(MemRead), .MemWrite(MemWrite), .Mem_Data(MemData));

    wire [5:0] OpCode, Funct;
    wire [4:0] rs, rt, rd, Shamt;
    InstReg InstReg(.reset(reset), .clk(clk), .IRWrite(IRWrite), .Instruction(MemData), 
                    .OpCode(OpCode), .rs(rs), .rt(rt), .rd(rd), .Shamt(Shamt), .Funct(Funct));
    wire [31:0] MDRo;
    RegTemp MDR(reset, clk, MemData, MDRo);

    wire [31:0] Databus1, Databus2, Databus3;
    wire [4:0]  Write_reg;
    wire [31:0] RF1o, RF2o;
    assign Write_reg = (RegDst == 2'b00) ? rt :  (RegDst == 2'b01) ? rd : 5'b11111;
    assign Databus3 = (MemtoReg == 2'b00) ? MDRo : (MemtoReg == 2'b01) ? ALU_outo : (MemtoReg == 2'b10) ? PC : LUI_out;
    RegisterFile RF(.reset(reset), .clk(clk), .RegWrite(RegWrite), 
                    .Read_register1(rs), .Read_register2(rt), .Write_register(Write_reg), 
                    .Write_data(Databus3), .Read_data1(Databus1), .Read_data2(Databus2));
    RegTemp rRF_A(reset, clk, Databus1, RF1o);
    RegTemp rRF_B(reset, clk, Databus2, RF2o);

    wire [31:0] Ext_out;
    wire [31:0] LUI_out;
    ImmProcess ImmProcess(ExtOp, LuiOp, MemData[15:0], Ext_out, LUI_out);

    RegTemp rALUOut(reset, clk, ALU_outi, ALU_outo);
    wire [31:0] ALU_in1;
	wire [31:0] ALU_in2;
	wire [31:0] ALU_outi;
    wire [31:0] ALU_outo;
    wire zero, sign;
    ALUControl ALUControl(.ALUOp(ALUOp), .Funct(Funct), .ALUConf(ALUConf), .Sign(sign));

    assign ALU_in1 = (ALUSrcA == 2'b01) ? RF1o : (ALUSrcA == 2'b00) ? PC : Shamt;
    assign ALU_in2 = (ALUSrcB == 2'b00) ? RF2o : (ALUSrcB == 2'b01) ? 32'd4 : (ALUSrcB == 2'b10) ? Ext_out : LUI_out;
    ALU ALU(.ALUConf(ALUConf), .Sign(sign), .In1(ALU_in1), .In2(ALU_in2), .Zero(zero), .Result(ALU_outi));

    wire [31:0] Jump_target, Branch_target;
    assign Jump_target = (OpCode == 6'h00) ? RF1o : {PC[31:28], {MemData[25:0]}, 2'b00};
    assign Branch_target = zero ? (ALU_outo) : (PC + 4); 
    assign PC_next = (PCSrc == 2'b00) ? ALU_outi : (PCSrc == 2'b01) ? Branch_target : Jump_target;

endmodule