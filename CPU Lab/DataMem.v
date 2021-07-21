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

    parameter RAM_SIZE = 32'hfff;
	parameter RAM_SIZE_BIT = 8;
    
    reg [31:0] RAM_data[RAM_SIZE - 1: 0];

	//read data
	always @(*) begin
		if(MemRead)begin
			if(Address[31:28] == 4'd4)begin
				case(Address)
					32'h4000000C: Mem_data <= {24'h0, led};
					32'h40000010: Mem_data <= {20'h0, digi};
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
			RAM_data[32'h7ff] <= 32'h0A;
			RAM_data[32'h7fe] <= 32'h0A;
			RAM_data[32'h7fd] <= 32'h02;
			RAM_data[32'h7fc] <= 32'h0C;
			RAM_data[32'h7fb] <= 32'h01;
			RAM_data[32'h7fa] <= 32'h0A;
			RAM_data[32'h7f9] <= 32'h03;
			RAM_data[32'h7f8] <= 32'h14;
			RAM_data[32'h7f7] <= 32'h02;
			RAM_data[32'h7f6] <= 32'h0F;
			RAM_data[32'h7f5] <= 32'h01;
			RAM_data[32'h7f4] <= 32'h08;
			RAM_data[32'h7f3] <= 32'h01;
			RAM_data[32'h7f2] <= 32'h0D;
			RAM_data[32'h7f1] <= 32'h03;
			RAM_data[32'h7f0] <= 32'h10;
			RAM_data[32'h7ef] <= 32'h02;
			RAM_data[32'h7ee] <= 32'h08;
			RAM_data[32'h7ed] <= 32'h05;
			RAM_data[32'h7ec] <= 32'h11;
			RAM_data[32'h7eb] <= 32'h04;
			RAM_data[32'h7ea] <= 32'h07;
			led <= 0;
			digi <= 0;
		end
        else if(MemWrite)begin
			if(Address[31:28] == 4'd4)begin
				case(Address)
					32'h4000000C: led <= Write_data[7:0];
					32'h40000010: digi <= Write_data[11:0];
					default: ;
				endcase
			end
			else if((Address+1)>>2 <= RAM_SIZE)
				RAM_data[Address[RAM_SIZE_BIT+1:2]] <= Write_data;
		end
    end

endmodule