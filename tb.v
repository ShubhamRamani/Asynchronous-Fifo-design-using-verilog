`timescale 1ns / 1ps

module tb();

reg clk,rst,we,re;
reg [7:0]din;
wire [7:0]dout;
wire full,empty;

reg [7:0]mem[0:44];
fifo dut(clk,rst,we,re,din,full,empty,dout);

integer FILE = 0;
integer i;

initial begin
clk = 1'b0;
rst = 1'b1;
we = 1'b0;
re = 1'b0;
end 

always #5 clk = ~clk;



initial begin

#12;
rst = 1'b0;

    FILE = $fopen("C:\placement\Project\TVDC_PROJECT\data.txt", "w");
    if (FILE == 0) begin
        $display("Error: Could not open file.");
        $finish;
    end
    
    for (i = 0; i < 5; i = i + 1) begin    // write operations (we = 1, re = 0)
        $fdisplay(FILE, "1\t 0\t %x\t", i * 4);
    end

    for (i = 0; i < 5; i = i + 1) begin     // Read operations (we = 0, re = 1)
        $fdisplay(FILE, "0\t 1\t %x\t",0*i);
    end

    for (i = 0; i < 5; i = i + 1) begin   // Simultaneous read and write (we = 1, re = 1)
        $fdisplay(FILE, "1\t 1\t %x\t", i + 1);
    end

    $fclose(FILE);  

// now read the file
    FILE = $fopen("C:\placement\Project\TVDC_PROJECT\data.txt", "r");
    

for(i = 0 ; i<15 ; i=i+1) begin
    $fscanf(FILE,"%b\t %b\t %x\t",mem[3*i],mem[3*i + 1],mem[3*i + 2]);
    we = mem[3*i];
    re = mem[3*i + 1];
    din = mem[3*i + 2];
    #10;
    $display("time = %0t, we = %b, re = %b , din = %x , wt_ptr = %d, rd_ptr = %d, count = %d",$time, we, re, din,dut.wt_ptr,dut.rd_ptr,dut.count);
     if (we == 1'b1) begin
        $display("FIFO[%0d] = %x", 
                 (dut.wt_ptr + 7) % 8, 
                 dut.FIFO[(dut.wt_ptr + 7) % 8]);
    end
end 

end
endmodule
