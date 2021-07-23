`timescale 1ns/1ps

module InstructionMem (
    input [31:0] Address,
    output reg [31:0] Instruction
);

always @(*) begin
    // init instruction memory
    case (Address[9:2])
   8'd0 : Instruction <= 32'h2004004e
;   8'd1 : Instruction <= 32'h3c104000
;   8'd2 : Instruction <= 32'h308bf000
;   8'd3 : Instruction <= 32'h000b5b02
;   8'd4 : Instruction <= 32'h308a0f00
;   8'd5 : Instruction <= 32'h000a5202
;   8'd6 : Instruction <= 32'h308900f0
;   8'd7 : Instruction <= 32'h00094902
;   8'd8 : Instruction <= 32'h3088000f
;   8'd9 : Instruction <= 32'h20110001
;   8'd10 : Instruction <= 32'h20120002
;   8'd11 : Instruction <= 32'h20130003
;   8'd12 : Instruction <= 32'h20140004
;   8'd13 : Instruction <= 32'h16e00001
;   8'd14 : Instruction <= 32'h20170004
;   8'd15 : Instruction <= 32'h0011b2c0
;   8'd16 : Instruction <= 32'h000b2820
;   8'd17 : Instruction <= 32'h0c000024
;   8'd18 : Instruction <= 32'h02c7b020
;   8'd19 : Instruction <= 32'hae160010
;   8'd20 : Instruction <= 32'h0011b280
;   8'd21 : Instruction <= 32'h000a2820
;   8'd22 : Instruction <= 32'h0c000024
;   8'd23 : Instruction <= 32'h02c7b020
;   8'd24 : Instruction <= 32'hae160010
;   8'd25 : Instruction <= 32'h0011b240
;   8'd26 : Instruction <= 32'h00092820
;   8'd27 : Instruction <= 32'h0c000024
;   8'd28 : Instruction <= 32'h02c7b020
;   8'd29 : Instruction <= 32'hae160010
;   8'd30 : Instruction <= 32'h0011b200
;   8'd31 : Instruction <= 32'h00082820
;   8'd32 : Instruction <= 32'h0c000024
;   8'd33 : Instruction <= 32'h02c7b020
;   8'd34 : Instruction <= 32'hae160010
;   8'd35 : Instruction <= 32'h0800000f
;   8'd36 : Instruction <= 32'h10a0001e
;   8'd37 : Instruction <= 32'h20a6ffff
;   8'd38 : Instruction <= 32'h10c0001e
;   8'd39 : Instruction <= 32'h20a6fffe
;   8'd40 : Instruction <= 32'h10c0001e
;   8'd41 : Instruction <= 32'h20a6fffd
;   8'd42 : Instruction <= 32'h10c0001e
;   8'd43 : Instruction <= 32'h20a6fffc
;   8'd44 : Instruction <= 32'h10c0001e
;   8'd45 : Instruction <= 32'h20a6fffb
;   8'd46 : Instruction <= 32'h10c0001e
;   8'd47 : Instruction <= 32'h20a6fffa
;   8'd48 : Instruction <= 32'h10c0001e
;   8'd49 : Instruction <= 32'h20a6fff9
;   8'd50 : Instruction <= 32'h10c0001e
;   8'd51 : Instruction <= 32'h20a6fff8
;   8'd52 : Instruction <= 32'h10c0001e
;   8'd53 : Instruction <= 32'h20a6fff7
;   8'd54 : Instruction <= 32'h10c0001e
;   8'd55 : Instruction <= 32'h20a6fff6
;   8'd56 : Instruction <= 32'h10c0001e
;   8'd57 : Instruction <= 32'h20a6fff5
;   8'd58 : Instruction <= 32'h10c0001e
;   8'd59 : Instruction <= 32'h20a6fff4
;   8'd60 : Instruction <= 32'h10c0001e
;   8'd61 : Instruction <= 32'h20a6fff3
;   8'd62 : Instruction <= 32'h10c0001e
;   8'd63 : Instruction <= 32'h20a6fff2
;   8'd64 : Instruction <= 32'h10c0001e
;   8'd65 : Instruction <= 32'h20a6fff1
;   8'd66 : Instruction <= 32'h10c0001e
;   8'd67 : Instruction <= 32'h200700c0
;   8'd68 : Instruction <= 32'h03e00008
;   8'd69 : Instruction <= 32'h200700f9
;   8'd70 : Instruction <= 32'h03e00008
;   8'd71 : Instruction <= 32'h200700a4
;   8'd72 : Instruction <= 32'h03e00008
;   8'd73 : Instruction <= 32'h200700b0
;   8'd74 : Instruction <= 32'h03e00008
;   8'd75 : Instruction <= 32'h20070099
;   8'd76 : Instruction <= 32'h03e00008
;   8'd77 : Instruction <= 32'h20070092
;   8'd78 : Instruction <= 32'h03e00008
;   8'd79 : Instruction <= 32'h20070082
;   8'd80 : Instruction <= 32'h03e00008
;   8'd81 : Instruction <= 32'h200700f8
;   8'd82 : Instruction <= 32'h03e00008
;   8'd83 : Instruction <= 32'h20070080
;   8'd84 : Instruction <= 32'h03e00008
;   8'd85 : Instruction <= 32'h20070090
;   8'd86 : Instruction <= 32'h03e00008
;   8'd87 : Instruction <= 32'h20070088
;   8'd88 : Instruction <= 32'h03e00008
;   8'd89 : Instruction <= 32'h20070083
;   8'd90 : Instruction <= 32'h03e00008
;   8'd91 : Instruction <= 32'h200700a7
;   8'd92 : Instruction <= 32'h03e00008
;   8'd93 : Instruction <= 32'h200700a1
;   8'd94 : Instruction <= 32'h03e00008
;   8'd95 : Instruction <= 32'h20070086
;   8'd96 : Instruction <= 32'h03e00008
;   8'd97 : Instruction <= 32'h2007008e
;   8'd98 : Instruction <= 32'h03e00008;
    endcase
end
    
endmodule