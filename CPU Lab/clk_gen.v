module clk_gen(
    input       clk, 
    input       reset, 
    input[22:0] CNT,
    output      clk_1Ko
);

reg             clk_1K; 
reg     [15:0]  count;

assign clk_1Ko = clk_1K;

always @(posedge clk or posedge reset)
begin
    if(reset) begin
        clk_1K <= 1'b0;
        count <= 16'd0;
    end
    else begin
        count <= (count==CNT-16'd1) ? 16'd0 : count + 16'd1;
        clk_1K <= (count==16'd0) ? ~clk_1K : clk_1K;
    end
end

endmodule
