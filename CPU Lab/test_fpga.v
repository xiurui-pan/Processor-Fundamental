`timescale 0.01ns / 1ps

module test_fpga();
    
    reg    sysclk;
    reg    BTND;
    reg    BTNU;
    reg    SW0;
    reg    SW1;

    wire   [7:0]    LED;
    wire   [7:0]    Cathodes;
    wire   [3:0]    AN;
    
    top top(sysclk, BTND, BTNU, SW0, SW1, LED, Cathodes, AN);
    
    initial fork
        BTNU <= 1;
        sysclk <= 1;
        SW0 <= 0;
        SW1 <= 0;
        #1000 BTNU = 0;
        #50000 SW0 <= 1;
        #100000 SW1 <= 1;
        #100000 SW0 <= 0;
        #150000 SW0 <= 1;
    join
    always #50 sysclk = ~sysclk;
    
endmodule