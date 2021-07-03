`timescale 1ns / 1ps

module DataMem(reset, clk, Address, Write_data, MemRead, MemWrite, Mem_data, led, digi);
	//Input Clock Signals
	input reset;
	input clk;
	//Input Data Signals
	input [31:0] Address;
	input [31:0] Write_data;
	input [7:0]  UART_RXD;
	input [4:0]  UART_CON;  
	//Input Control Signals
	input MemRead;
	input MemWrite;
	//Output Data
	output reg [31:0] Mem_data;
	output reg [7:0]  led;
	output reg [11:0] digi;
	output reg [7:0]  UART_TXD;

    parameter RAM_SIZE = 256;
	parameter RAM_SIZE_BIT = 8;
    
    reg [31:0] RAM_data[RAM_SIZE - 1: 0];

	//read data
	always @(*) begin
		if(MemRead)begin
			if(Address[31:28] == 4'd4)begin
				case(Address)
					32'h4000000C: Mem_data <= {24'h0, led};
					32'h40000010: Mem_data <= {20'h0, digi};
					//32'h40000018: Mem_data <= {24'h0, UART_TXD};
					32'h4000001C: Mem_data <= {24'h0, UART_RXD};
					32'h40000020: Mem_data <= {27'h0, UART_CON};
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
			led <= 0;
			digi <= 0;
		end
        else if(MemWrite)begin
			if(Address[31:28] == 4'd4)begin
				case(Address)
					32'h4000000C: led <= Write_data[7:0];
					32'h40000010: digi <= Write_data[11:0];
					32'h40000018: UART_TXD <= Write_data[7:0];
					//32'h3000001C:
					//32'h40000020:
					default: ;
				endcase
			end
			else if((Address+1)>>2 <= RAM_SIZE)
				RAM_data[Address[RAM_SIZE_BIT+1:2]] <= Write_data;
		end
    end

endmodule