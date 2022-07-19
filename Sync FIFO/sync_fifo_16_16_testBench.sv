`timescale  1ns/1ns
module sync_fifo_16_16_testBench;

    parameter DATA_WIDTH = 16;
    parameter DEPTH = 16;
    parameter ADDR_WIDTH = $clog2(DEPTH) +1;

    logic  [DATA_WIDTH - 1 : 0] fifo_data_in;   // input
    logic  rst_, fifo_write, fifo_read, clk;    // input

    logic  [DATA_WIDTH - 1 : 0] fifo_data_out;  // output

    logic fifo_full, fifo_empty;

    logic [ADDR_WIDTH -1 : 0] wr_ptr , rd_ptr;
    logic [4:0] counter_data_out;

    initial begin

    $display ("time\t clk\t rst_\t fifo_write\t fifo_read\t fifo_full\t fifo_empty\t\t fifo_data_in\t\t\tfifo_data_out");
    $monitor ("%g\t %b\t %b\t\t%b\t%b\t %b\t\t%b\t%b\t\t%b ", $time, clk, rst_, fifo_write, fifo_read, fifo_full, fifo_empty, fifo_data_in, fifo_data_out);

    clk = 0;
    rst_ = 1'b0; // start with reset
    fifo_read = 1'b0;
    fifo_write = 1'b0;

    #10

    rst_ = 1'b1; //reset off
    fifo_data_in = 2;
    fifo_write = 1'b1;
    fifo_read = 1'b0;

    #35

    rst_ = 1'b1; //reset off
    fifo_write = 1'b0;  //write off
    fifo_read = 1'b1; // start reading

    end
    
always #5 clk = ~clk;
sync_fifo_16_16 u0(.*);
endmodule
