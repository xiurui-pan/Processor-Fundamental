`timescale 1ns / 1ps

module DataMem(reset, clk, Address, Write_data, MemRead, MemWrite, Mem_data, led, digi);
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
	output reg [31:0] Mem_data;
	output reg [7:0]  led;
	output reg [11:0] digi;

    parameter RAM_SIZE = 32'h200;
	parameter RAM_SIZE_BIT = 10;
    
    reg [31:0] RAM_data[RAM_SIZE - 1: 0];

	//read data
	always @(*) begin
		if(MemRead)begin
			if(Address[31:28] == 4'd4)begin
				case(Address)
					default: Mem_data <= 32'h0;
				endcase
			end
			else if((Address+1)>>2 <= RAM_SIZE) 
				Mem_data <= RAM_data[Address[RAM_SIZE_BIT+1:2]];
		end
	end

	//write data
	integer i;
    always @(posedge reset or posedge clk) begin
        if(reset)begin
            for(i = 0; i < RAM_SIZE; i = i + 1)
                RAM_data[i] <= 32'h0;
			RAM_data[32'h00f] <= 32'h0A;
			RAM_data[32'h010] <= 32'h0A;
			RAM_data[32'h011] <= 32'h02;
			RAM_data[32'h012] <= 32'h0C;
			RAM_data[32'h013] <= 32'h01;
			RAM_data[32'h014] <= 32'h0A;
			RAM_data[32'h015] <= 32'h03;
			RAM_data[32'h016] <= 32'h14;
			RAM_data[32'h017] <= 32'h02;
			RAM_data[32'h018] <= 32'h0F;
			RAM_data[32'h019] <= 32'h01;
			RAM_data[32'h01a] <= 32'h08;
			RAM_data[32'h01b] <= 32'h01;
			RAM_data[32'h01c] <= 32'h0D;
			RAM_data[32'h01d] <= 32'h03;
			RAM_data[32'h01e] <= 32'h10;
			RAM_data[32'h01f] <= 32'h02;
			RAM_data[32'h020] <= 32'h08;
			RAM_data[32'h021] <= 32'h05;
			RAM_data[32'h022] <= 32'h11;
			RAM_data[32'h023] <= 32'h04;
			RAM_data[32'h024] <= 32'h07;
			//led <= 0;
			digi <= 0;
		end
        else if(MemWrite)begin
			if(Address[31:28] == 4'd4)begin
				case(Address)
					//32'h4000000C: led <= Write_data[7:0];
					32'h40000010: digi <= Write_data[11:0];
					default: ;
				endcase
			end
			else if((Address+1)>>2 <= RAM_SIZE)
				RAM_data[Address[RAM_SIZE_BIT+1:2]] <= Write_data;
		end
    end

endmodule