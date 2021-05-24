`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Class: Fundamentals of Digital Logic and Processor
// Designer: Shulin Zeng
// 
// Create Date: 2021/04/30
// Design Name: MultiCycleCPU
// Module Name: Controller
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


module Controller(reset, clk, OpCode, Funct, 
                PCWrite, PCWriteCond, IorD, MemWrite, MemRead,
                IRWrite, MemtoReg, RegDst, RegWrite, ExtOp, LuiOp,
                ALUSrcA, ALUSrcB, ALUOp, PCSource);
    //Input Clock Signals
    input reset;
    input clk;
    //Input Signals
    input  [5:0] OpCode;
    input  [5:0] Funct;
    //Output Control Signals
    output reg PCWrite;
    output reg PCWriteCond;
    output reg IorD;
    output reg MemWrite;
    output reg MemRead;
    output reg IRWrite;
    output reg [1:0] MemtoReg;
    output reg [1:0] RegDst;
    output reg RegWrite;
    output reg ExtOp;
    output reg LuiOp;
    output reg [1:0] ALUSrcA;
    output reg [1:0] ALUSrcB;
    output reg [3:0] ALUOp;
    output reg [1:0] PCSource;

    reg [3:0] state;
    parameter sIF = 0;
    parameter sID = 1;
    parameter sMemAddrComp = 2;
    parameter sMemRead = 3;
    parameter sRegWriteBack = 4;
    parameter sMemWrite = 5;
    parameter sExe = 6;
    parameter sBranchComp = 7;
    parameter sJumpComp = 8;

    parameter lw = 6'h23, sw = 6'h2b, lui = 6'h0f, R_type = 6'h00;
    parameter addi = 6'h08, addiu = 6'h09, andi = 6'h0c, slti = 6'h0a, sltiu = 6'h0b;
    parameter beq = 6'h04, j = 6'h02, jal = 6'h03;

    parameter add_f = 6'h20, addu_f = 6'h21, sub_f = 6'h22, subu_f = 6'h23, and_f = 6'h24, or_f = 6'h25, xor_f = 6'h26, nor_f = 6'h27, sll_f = 6'h0, srl_f = 6'h02, sra_f = 6'h03, slt_f = 6'h2a, sltu_f = 6'h2b, jr_f = 6'h08, jalr_f = 6'h09;

    always @(posedge clk or posedge reset) begin
        if(reset)begin
            PCWrite <= 0;
            PCWriteCond <= 0;
            IorD = 0;
            MemWrite <= 0;
            MemRead <= 0;
            IRWrite <= 0;
            MemtoReg <= 0;
            RegDst <= 2'b00;
            RegWrite <= 0;
            ExtOp <= 0;
            LuiOp <= 0;
            ALUSrcA <= 0;
            ALUSrcB <= 2'b00;
            PCSource <= 2'b00;
            state <= 0;
        end
        else begin
            case(state)
            sIF: begin
                MemRead <= 1;
                IRWrite <= 1;
                PCWrite <= 1;
                PCSource <= 2'b00;
                ALUSrcA <= 0;
                IorD <= 0;
                ALUSrcB <= 2'b01;
                state <= sID;
            end
            sID: begin
                ALUSrcA <= 0;
                ALUSrcB <= 2'b11;
                ALUOp <= 4'b0000;
                case(OpCode)
                    R_type, addi, addiu, andi, slti, sltiu: state <= sExe;
                    j: state <= sJumpComp;
                    jal: state <= sRegWriteBack;
                    beq: state <= sBranchComp;
                    lw, sw: state <= sMemAddrComp;
                    lui: 
                endcase
            end
            sRegWriteBack: begin
                RegWrite <= 1;
                case(OpCode)
                    jal: begin
                        RegDst <= 2'b10;
                        MemtoReg <= 2'b10;
                    end


                endcase

            end
            endcase
        end
    end

    //ALUOp
    always @(*) begin
        ALUOp[3] = OpCode[0];
        if (state == sIF || state == sID) begin
            ALUOp[2:0] = 3'b000;
        end else if (OpCode == 6'h00) begin 
            ALUOp[2:0] = 3'b010;
        end else if (OpCode == 6'h04) begin
            ALUOp[2:0] = 3'b001;
        end else if (OpCode == 6'h0c) begin
            ALUOp[2:0] = 3'b100;
        end else if (OpCode == 6'h0a || OpCode == 6'h0b) begin
            ALUOp[2:0] = 3'b101;
        end else begin
            ALUOp[2:0] = 3'b000;
        end
    end

endmodule