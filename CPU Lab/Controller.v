`timescale 1ns / 1ps

module Controller(reset, clk, OpCode, Funct, 
                Branch, MemWrite, MemRead,
                MemtoReg, RegDst, RegWrite, ExtOp, LuiOp,
                ALUSrcA, ALUSrcB, ALUOp, PCSource);
    //Input Clock Signals
    input reset;
    input clk;
    //Input Signals
    input  [5:0] OpCode;
    input  [5:0] Funct;
    //Output Control Signals
    output [2:0] Branch;
    output MemWrite;
    output MemRead;
    output [1:0] MemtoReg;
    output [1:0] RegDst;
    output RegWrite;
    output ExtOp;
    output LuiOp;
    output ALUSrcA;
    output ALUSrcB;
    output [3:0] ALUOp;
    output [1:0] PCSource;

    parameter lw = 6'h23, sw = 6'h2b, lui = 6'h0f, R_type = 6'h00;
    parameter addi = 6'h08, addiu = 6'h09, andi = 6'h0c, slti = 6'h0a, sltiu = 6'h0b;
    parameter beq = 6'h04, bne = 6'h05, blez = 6'h06, bgtz = 6'h07, bltz = 6'h01, j = 6'h02, jal = 6'h03;

    parameter add_f = 6'h20, addu_f = 6'h21, sub_f = 6'h22, subu_f = 6'h23, and_f = 6'h24, or_f = 6'h25, xor_f = 6'h26, nor_f = 6'h27, sll_f = 6'h0, srl_f = 6'h02, sra_f = 6'h03, slt_f = 6'h2a, sltu_f = 6'h2b, jr_f = 6'h08, jalr_f = 6'h09;

    assign PCSource = ((OpCode==R_type && (Funct==jr_f || Funct==jalr_f)) || OpCode==j || OpCode == jal) ? 2'b10 : (OpCode==beq) ? 2'b01 : 2'b00;
    assign Branch = (OpCode==beq || OpCode==bne || OpCode==blez || OpCode==bltz || OpCode==bgtz) ? OpCode[2:0] : 3'b0;
    assign RegWrite = (OpCode==sw || OpCode==j || OpCode==beq || OpCode==bne || OpCode==blez || OpCode==bltz || OpCode==bgtz || (OpCode==R_type && Funct==jr_f)) ? 0 : 1;
    assign RegDst = (OpCode==jal) ? 2'b10 : (OpCode==addi || OpCode==addiu || OpCode==andi || OpCode==slti || OpCode==sltiu || OpCode==lui || OpCode==lw || OpCode==sw) ? 2'b00 : 2'b01;
    assign MemRead = (OpCode==lw) ? 1 : 0;
    assign MemWrite = (OpCode==sw) ? 1 : 0;
    assign MemtoReg = ((OpCode==R_type && Funct==jalr_f) || OpCode==jal) ? 2'b10 : (OpCode==lw) ? 2'b00 : 2'b01;
    assign ALUSrcA = (OpCode==R_type && (Funct==sll_f || Funct==sra_f || Funct==srl_f)) ? 1 : 0;
    assign ALUSrcB = (OpCode==R_type || Branch!=0) ? 0 : 1;
    assign ExtOp = (OpCode==R_type && (Funct==sll_f || Funct==srl_f || Funct==sra_f)) ? 0 : 1;
    assign LuiOp = (OpCode==lui) ? 1 : 0;

    assign ALUOp[3] = OpCode[0];
    assign ALUOp[2:0] = 
        (OpCode == 6'h00)? 3'b010: 
        (OpCode == 6'h04)? 3'b001: 
        (OpCode == 6'h0c)? 3'b100: 
        (OpCode == 6'h0a || OpCode == 6'h0b)? 3'b101: 3'b000;

endmodule