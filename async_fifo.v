`timescale 1ns / 1ps

module asynsc_fifo (
    input clk_wt, clk_rd, we, re,
    output reg full, empty,
    input [15:0] din,
    input rst_r,rst_w,
    output reg [15:0] dout
);

    integer j;
    reg  [3:0] b_rd_ptr;
    reg  [3:0] b_wt_ptr;
    wire [3:0] g_rd_ptr, g_wt_ptr;
    reg  [15:0] FIFO [0:15];
    wire [3:0]u1_sync1,u2_sync2;
    wor [3:0] g_rd_ptr_sync = 4'b0000, g_wt_ptr_sync = 4'b0000;
    wor [3:0] b_rd_ptr_sync = 4'b0000, b_wt_ptr_sync = 4'b0000;

    b2g b2g_w(b_wt_ptr, g_wt_ptr);
    b2g b2g_r(b_rd_ptr, g_rd_ptr);


      synchronizer  u1(
        .clk(clk_rd),
        .rst(rst_r),
        .din(g_wt_ptr),
        .dout(g_wt_ptr_sync));
       
      synchronizer u2(
        .clk(clk_wt),
        .rst(rst_r),
        .din(g_rd_ptr),
        .dout(g_rd_ptr_sync));
  

    g2b g2b_w(g_wt_ptr_sync,b_wt_ptr_sync);
    g2b g2b_r(g_rd_ptr_sync,b_rd_ptr_sync);
    
    
    initial begin
             for(j=0;j<=15;j=j+1) begin
                FIFO[j] = 16'h0000;
             end
        end
    
    // Write side
    always @(posedge clk_wt) begin
        if (rst_r)
            b_wt_ptr <= 0;
        else if (we) begin
            if((b_wt_ptr + 1'b1 )== b_rd_ptr_sync) begin
                full <= 1'b1;
             end 
            else begin
                FIFO[b_wt_ptr] <= din;
                b_wt_ptr <= (b_wt_ptr + 1);
            end 
        end
        
        end
        

    // Read side
    always@(posedge clk_rd) begin
        if (rst_r)
            b_rd_ptr <= 0;
        else if(re) begin
            if(b_rd_ptr == b_wt_ptr_sync) begin
                empty <= 1'b1;
            end 
            else  begin
                dout <= FIFO[b_rd_ptr];
                b_rd_ptr <= (b_rd_ptr + 1);
            end
        
        end
    end

endmodule




