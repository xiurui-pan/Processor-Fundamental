module Hazard (IDrs, IDrt, EXrs, EXrt, EXrd, EXMemRead, MEMRegWrite, MEMrd, WBRegWrite, WBrd, ForwardA, ForwardB, stall);
    input EXMemRead, MEMRegWrite, WBRegWrite;
    input[4:0] IDrs, IDrt, IDrd, EXrs, EXrt, EXrd, MEMrd, WBrd;
    output [1:0] ForwardA, ForwardB;
    output stall;

    assign ForwardA = (MEMRegWrite && MEMrd && MEMrd==EXrs) ? 2'b10 : (WBRegWrite && WBrd && WBrd==EXrs && (MEMrd!=EXrd || ~MEMRegWrite)) ? 2'b01 : 2'b00;

    assign ForwardB = (MEMRegWrite && MEMrd && MEMrd==EXrt) ? 2'b10 : (WBRegWrite && WBrd && WBrd==EXrt && (MEMrd!=EXrd || ~MEMRegWrite)) ? 2'b01 : 2'b00;

    assign stall = (EXMemRead && (EXrt==IDrs || EXrt==IDrt)) ? 1 : 0;
endmodule