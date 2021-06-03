`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Class: Fundamentals of Digital Logic and Processor
// Designer: Shulin Zeng
// 
// Create Date: 2021/04/30
// Design Name: MultiCycleCPU
// Module Name: InstAndDataMemory
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


module InstAndDataMemory(reset, clk, Address, Write_data, MemRead, MemWrite, Mem_data);
	//Input Clock Signals
	input reset;
	input clk;
	//Input Data Signals
	input [31:0] Address;
	input [31:0] Write_data;
	//Input Control Signals
	input MemRead;
	input MemWrite;
	//Output Data
	output [31:0] Mem_data;
	
	parameter RAM_SIZE = 256;
	parameter RAM_SIZE_BIT = 8;
	parameter RAM_INST_SIZE = 32;
	
	reg [31:0] RAM_data[RAM_SIZE - 1: 0];

	//read data
	assign Mem_data = MemRead? RAM_data[Address[RAM_SIZE_BIT + 1:2]]: 32'h00000000;
	
	//write data
	integer i;
	always @(posedge reset or posedge clk) begin
		if (reset) begin
		    // init instruction memory
            //0 : addi $a0, $zero, 5 
            RAM_data[8'd0] <= {6'h08 , 5'd0 , 5'd4 , 16'h5};
            //1 : xor $v0, $zero, $zero 
            RAM_data[8'd1] <= {6'h00 , 5'd0 , 5'd0 , 5'd2 , 5'd0 , 6'h26};
            //2 : jal sum 
            RAM_data[8'd2] <= {6'h03 , 26'h0000004};
            //Loop: 3 : beq $zero, $zero, Loop 
            RAM_data[8'd3] <= {6'h04 , 5'd0 , 5'd0 , 16'hffff};
            //sum:  4 : addi $sp, $sp, -8 
            RAM_data[8'd4] <= {6'h08 , 5'd29 , 5'd29 , 16'hfff8};
            //5 : sw $ra, 4($sp) 
            RAM_data[8'd5] <= {6'h2b , 5'd29 , 5'd31 , 16'd4};
            //6 : sw $a0, 0($sp) 
            RAM_data[8'd6] <= {6'h2b , 5'd29 , 5'd4 , 16'd0};
            //7 : slti $t0, $a0, 1 
            RAM_data[8'd7] <= {6'h0a , 5'd4 , 5'd8 , 16'd1};
            //8 : beq $t0, $zero, L1 
            RAM_data[8'd8] <= {6'h04 , 5'd8 , 5'd0 , 16'h2};
            //9 : addi $sp, $sp, 8 
            RAM_data[8'd9] <= {6'h08 , 5'd29 , 5'd29 , 16'd8};
            //10 : jr $ra 
            RAM_data[8'd10] <= {6'h00 , 5'd31 , 15'd0 , 6'h08};
            //L1: 11 : add $v0, $a0, $v0 
            RAM_data[8'd11] <= {6'h00 , 5'd4 , 5'd2 , 5'd2 , 5'd0 , 6'h20}; 
            //12 : addi $a0, $a0, -1 
            RAM_data[8'd12] <= {6'h08 , 5'd4 , 5'd4 , 16'hffff};
            //13 : jal sum 
            RAM_data[8'd13] <= {6'h03 , 26'd4};
            //14 : lw $a0, 0($sp)
            RAM_data[8'd14] <= {6'h23 , 5'd29 , 5'd4 , 16'd0};
            //15: lw $ra, 4($sp) 
            RAM_data[8'd15] <= {6'h23 , 5'd29 , 5'd31 , 16'd4};
            //16 : addi $sp, $sp, 8 
            RAM_data[8'd16] <= {6'h08 , 5'd29 , 5'd29 , 16'd8};
            //17 : add $v0, $a0, $v0 
            RAM_data[8'd17] <= {6'h00 , 5'd4 , 5'd2 , 5'd2 , 5'd0 , 6'h20}; 
            //18 : jr $ra 
            RAM_data[8'd18] <= {6'h00 , 5'd31 , 15'd0 , 6'h08};
       
            //init instruction memory
            //reset data memory		  
			for (i = RAM_INST_SIZE - 1; i < RAM_SIZE; i = i + 1)
				RAM_data[i] <= 32'h00000000;
		end else if (MemWrite) begin
			RAM_data[Address[RAM_SIZE_BIT + 1:2]] <= Write_data;
		end
	end

endmodule
