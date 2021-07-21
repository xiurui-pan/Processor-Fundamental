`timescale 1ns / 1ps

module ALU(ALUConf, Sign, In1, In2, Comp, Result, Branch);
    // Control Signals
    input [4:0] ALUConf;
	input [2:0] Branch;
    input Sign;
    // Input Data Signals
    input [31:0] In1;
    input [31:0] In2;
    // Output 
    output reg Comp;
    output reg [31:0] Result;

    //ALU logic
    wire [1:0] ss;
	assign ss = {In1[31], In2[31]};
	
	wire lt_31;
	assign lt_31 = (In1[30:0] < In2[30:0]);
	
	wire lt_signed;
	assign lt_signed = (In1[31] ^ In2[31])? 
		((ss == 2'b01)? 0: 1): lt_31;

	always @(*) begin
		case(Branch)
			3'b100: Comp <= (In1 == In2) ? 1 : 0;
			3'b101: Comp <= (In1 != In2) ? 1 : 0;
			3'b110: Comp <= (In1[31]==1 || In1==0) ? 1 : 0;
			3'b111: Comp <= (In1[31]==0 && In1!=0) ? 1 : 0;
			3'b001: Comp <= (In1[31]==1) ? 1 : 0;
			default: Comp <= 0;
		endcase
	end

    always @(*) begin
		case (ALUConf)
			5'b00000: Result <= In1 + In2;
			5'b00001: Result <= In1 | In2;
			5'b00010: Result <= In1 & In2;
			5'b00110: Result <= In1 - In2;
			5'b00111: Result <= {31'h00000000, Sign? lt_signed: (In1 < In2)};
			5'b01100: Result <= ~(In1 | In2);
			5'b01101: Result <= In1 ^ In2;
			5'b10000: Result <= (In2 >> In1[4:0]);
			5'b11000: Result <= ({{32{In2[31]}}, In2} >> In1[4:0]);
            5'b11001: Result <= (In2 << In1[4:0]);
			default: Result <= 32'h00000000;
		endcase
    end

endmodule
