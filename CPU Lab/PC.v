`timescale 1ns / 1ps

module PC(reset, clk, PC_i, PC_o);
    //Input Clock Signals
    input reset;             
    input clk;
    //Input PC             
    input [31:0] PC_i;
    //Output PC  
    output reg [31:0] PC_o; 

    parameter RESET = 32'h00000000;

    always@(posedge reset or posedge clk)
    begin
        if(reset) begin
            PC_o <= RESET;
        end else begin
            PC_o <= PC_i;
        end
    end
endmodule