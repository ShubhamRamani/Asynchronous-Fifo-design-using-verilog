module synchronizer (
  input clk, rst, 
  input [3:0]din, 
  output reg [3:0]dout,
  output reg [3:0]sync1
);



  always @(posedge clk) begin
    if (rst) begin
      sync1 <= 0;
      dout  <= 0;
    end 
    else begin
      sync1 <= din;
      dout  <= sync1;
    end
    
  end

endmodule
