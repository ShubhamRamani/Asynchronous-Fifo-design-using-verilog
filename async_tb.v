`timescale 1ns / 1ps

module async_tb( );
reg clk_wt, clk_rd, we, re,rst;
reg [15:0]din;
wire full, empty;
wire [15:0]dout;


asynsc_fifo dut (.clk_wt(clk_wt),.rst(rst),.clk_rd(clk_rd),.we(we),.re(re),.din(din),.full(full),.empty(empty),.dout(dout));

integer i;
initial begin
clk_wt = 1'b0;
clk_rd = 1'b0;
re = 1'b0;
we = 1'b0;
rst = 1'b1;
end 

always #5 clk_wt = ~clk_wt;
always #10 clk_rd = ~clk_rd;

initial begin
#18; rst = 1'b0;
#5; we = 1'b1;
for(i = 0 ; i<16 ; i = i+1) begin
@(posedge clk_wt);
din = i;
end 

#12;
we = 1'b0;
re = 1'b1;
end 









endmodule
