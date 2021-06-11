module top(
    input sysclk,
    input BTND,
    input BTNU,
    input SW0,
    input SW1,
    output [7:0] LED,
    output [7:0] Cathodes,
    output [3:0] AN
);

    parameter bcd_clock_div = 32'd5000000; //1s
    //parameter bcd_clock_div = 23'd10;
    parameter an_clock_div  = 32'd500;

    wire [15:0] a0;
    wire [15:0] v0;
    wire [15:0] sp;
    wire [15:0] ra;
    wire [15:0] signal;
    wire [7:0]  lowPC;
    wire an_clko;
    wire bcd_clko;

    assign signal =  (SW0 == 0 && SW1 ==0) ? a0 : (SW0 == 1 && SW1 ==0) ? v0 : (SW0 == 0 && SW1 ==1) ? sp : ra;
    assign LED = lowPC;

    clk_gen bcd_clock(sysclk, BTNU, bcd_clock_div, bcd_clko);
    clk_gen an_clock(sysclk, BTNU, an_clock_div, an_clko);
    BCD bcd7(an_clko, signal[3:0], signal[7:4], signal[11:8], signal[15:12], 1, AN, Cathodes[6:0], Cathodes[7]);
    MultiCycleCPU MultiCycleCPU_1(BTNU, bcd_clko, a0, v0, sp, ra, lowPC);

    
endmodule