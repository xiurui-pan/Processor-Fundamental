module BCD (
    input       clk, //an_clock
    input[3:0]  cnt0, //the digits it displays
    input[3:0]  cnt1,
    input[3:0]  cnt2,
    input[3:0]  cnt3,
    input       EN,
    output[3:0] ano,
    output[6:0] leds,
    output reg  dot
);

reg[3:0]  cnt = 0;
reg[1:0]  an_cnt = 0;
reg[3:0]  an = 0;

assign ano = an;

always @(posedge clk) begin
    an_cnt <= an_cnt + 1;
end

always @(*) begin
    dot = 1;
    case(an_cnt)
        2'b00:begin
            an = 4'b1110;
            cnt = cnt0;
        end
        2'b01:begin
            an = 4'b1101;
            cnt = cnt1;
        end
        2'b10:begin
            an = 4'b1011;
            cnt = cnt2;
        end
        2'b11:begin
            an = 4'b0111;
            cnt = cnt3;
        end
    endcase
end

assign leds = (cnt == 4'h0) ? 7'b1000000:
              (cnt == 4'h1) ? 7'b1111001:
              (cnt == 4'h2) ? 7'b0100100:
              (cnt == 4'h3) ? 7'b0110000:
              (cnt == 4'h4) ? 7'b0011001:
              (cnt == 4'h5) ? 7'b0010010:
              (cnt == 4'h6) ? 7'b0000010:
              (cnt == 4'h7) ? 7'b1111000:
              (cnt == 4'h8) ? 7'b0000000:
              (cnt == 4'h9) ? 7'b0010000:
              (cnt == 4'hA) ? 7'b0001000:
              (cnt == 4'hb) ? 7'b0000011:
              (cnt == 4'hC) ? 7'b0100111:
              (cnt == 4'hD) ? 7'b0100001:
              (cnt == 4'hE) ? 7'b0000110:
              (cnt == 4'hF) ? 7'b0001110:7'b1111111;
    
endmodule