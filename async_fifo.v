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


//module ASYNCHRONOUS_FIFO(
//input [7:0]data_in,
//input w_en,
//input wclk,
//output reg [7:0]data_out,
//input ren,
//input rclk,
//input wrst_n,
//input rrst_n,
//output reg full,
//output reg empty,
//output [3:0]b_wptr_out,
//output [3:0]b_rptr_out,
//input reset,
//output [3:0]b_wptr_sync_out,
//output [3:0]b_rptr_sync_out
//);


//reg [7:0]FIFO_ROM[15:0];
//reg [3:0]b_wptr_r,b_rptr_r;
//reg [3:0]t1,t2,t3,t4,g_wptr_sync,g_rptr_sync;
//wire [3:0]g_wptr,g_rptr,b_wptr_sync,b_rptr_sync;


//b2g BG1(b_wptr_r,g_wptr);
//b2g BG2(b_rptr_r,g_rptr);
//g2b GB1(g_rptr_sync,b_rptr_sync);
//g2b GB2(g_wptr_sync,b_wptr_sync);

//assign b_wptr_out = b_wptr_r;
//assign b_rptr_out = b_rptr_r;
//assign b_wptr_sync_out = b_wptr_sync;
//assign b_rptr_sync_out = b_rptr_sync;



//always@(posedge wclk)
//begin
//if(reset == 1'b1)begin
//b_wptr_r = -4'd1;
//g_rptr_sync = 4'b1111;
//t1 = 4'b1111;
//full = 4'd0;
//end

//else begin

//if(w_en == 1'b1)begin

//  if((b_wptr_r + 1'b1)== b_rptr_sync)
//  begin
//  full = 1'b1;
//  end
  
//  else begin
// b_wptr_r[3:0] = b_wptr_r[3:0] + 1;
// FIFO_ROM[b_wptr_r] = data_in;

// end
 
//end


//t1 <= g_rptr;
//g_rptr_sync <= t1;

//end

//end

//always@(posedge rclk)
//begin

//if(reset == 1'b1)begin
//b_rptr_r = -4'd1;
//g_wptr_sync = 4'b1111;
//t2 = 4'b1111;
//empty = 1'd0;
//end

//else begin
//if(ren == 1'b1)begin

//  if(b_rptr_sync == b_wptr_r)begin
//   empty = 1'b1;
//  end
//  else
//  begin
//  b_rptr_r[3:0] = b_rptr_r[3:0] + 1;
// data_out = FIFO_ROM[b_rptr_r];
 
//  end
  
//end

//t2 <= g_wptr;
//g_wptr_sync <= t2;

//end
 
