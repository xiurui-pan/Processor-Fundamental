`timescale 1ns / 1ps

module test_cpu();
    
    reg reset;
    reg clk;
    
    Pipeline_CPU PipelineCPU(reset, clk);
    
    initial begin
        reset = 1;
        clk = 1;
        #100 reset = 0;
    end
    
    always #50 clk = ~clk;
    
endmodule
