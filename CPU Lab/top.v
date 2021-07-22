module top(
    input sysclk,
    input BTNU,
    output [7:0] LED,
    output [7:0] Cathodes,
    output [3:0] AN
);

    parameter bcd_clock_div = 32'd5000000; 

    wire [7:0]  lowPC;
    wire bcd_clko;

    assign LED = lowPC;

    clk_gen clock(sysclk, BTNU, bcd_clock_div, bcd_clko);
    Pipeline_CPU Pipeline_CPU_1(BTNU, bcd_clko, LED, {AN, Cathodes}, lowPC);
    
endmodule
