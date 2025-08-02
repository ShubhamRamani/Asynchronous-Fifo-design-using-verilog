`timescale 1ns / 1ps
module fifo #(
    parameter depth = 8,
    parameter width = 8
)(
    input clk,
    input rst,
    input we,
    input re,
    input [width-1:0] din,
    output full,
    output empty,
    output reg [width-1:0] dout
);

reg [2:0] rd_ptr;
reg [2:0] wt_ptr;
reg [width-1:0]FIFO[0:depth-1];
reg [3:0]count = 4'd0;

assign full = (count == depth);
assign empty = (count == 0);

integer i;
initial begin
    rd_ptr = 0;
    wt_ptr = 0;
    for (i = 0; i < depth; i = i + 1)
        FIFO[i] = 0;
end

always @(posedge clk) begin
    if (rst) begin
        rd_ptr <= 0;
        wt_ptr <= 0;
    end 
    
    else begin
    case({we && !full , (re && !empty)})
    
    2'b10 : begin  //only write
    FIFO[wt_ptr] <= din;
    wt_ptr <= (wt_ptr + 1)%depth;
    count <= count + 1;
    end 
    
    2'b01 : begin
    dout <= FIFO[rd_ptr];
    rd_ptr <= (rd_ptr + 1)%depth;
    count <= count - 1;
    end 
    
    2'b11 : begin
    FIFO[wt_ptr] <= din;
    wt_ptr <= (wt_ptr + 1)%depth;
    dout <= FIFO[rd_ptr];
    rd_ptr <= (rd_ptr + 1)%depth;
    end 
    endcase
    end 

end 

endmodule

