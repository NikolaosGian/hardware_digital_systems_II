`timescale  1ns/1ns
module counter_testBench;
    logic rst_,updn_cnt,count_enb,clk;
    logic [3:0] data_out;
    

    initial begin

        $display ("time\t clk\t rst_\t updn_cnt\t count_enb \t\tdata_out");
        $monitor ("%g\t %b\t %b\t\t%b\t%b\t%b", $time, clk, rst_, updn_cnt, count_enb, data_out);

        clk = 0;
        rst_ = 1'b0; // start with reset
        count_enb = 1'b0;

        #10

        rst_ = 1'b1;
        updn_cnt = 1'b1;
        count_enb = 1'b1;

        #40
        rst_ = 1'b1; 
        count_enb = 1'b0;  
       
    end
    
always #5 clk = ~clk;
counter cnt(.*);
initial  // Dump waveform for debug 
$dumpvars;
endmodule