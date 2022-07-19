`timescale 1ns/1ns
module sync_fifo_16_16_test_with_bind;

    parameter DATA_WIDTH = 16;
    parameter DEPTH = 16;
    parameter ADDR_WIDTH = $clog2(DEPTH);
    logic  [DATA_WIDTH - 1 : 0] fifo_data_in;
    logic  [DATA_WIDTH - 1 : 0] fifo_data_out;
    logic  rst_, fifo_write, fifo_read, clk;
    logic  fifo_full , fifo_empty;
    logic [ADDR_WIDTH -1 : 0] wr_ptr , rd_ptr;
    logic [4:0] counter_data_out;
    sync_fifo_16_16 fifo(.fifo_data_in(fifo_data_in), .rst_(rst_), .fifo_write(fifo_write), .fifo_read(fifo_read), .clk(clk),
     .fifo_data_out(fifo_data_out), .fifo_full(fifo_full), .fifo_empty(fifo_empty), .wr_ptr(wr_ptr), .rd_ptr(rd_ptr), .counter_data_out(counter_data_out));
    bind sync_fifo_16_16 sync_fifo_16_16_property dut(fifo_data_in, rst_, fifo_write, fifo_read, clk, fifo_full, fifo_empty, wr_ptr, rd_ptr, counter_data_out);
    always #5 clk = ~clk; 
    initial begin
        $display ("time\t clk\t rst_\t fifo_write\t fifo_read\t fifo_full\t fifo_empty\t\t   fifo_data_in\t\t\tfifo_data_out\t\t   wr_ptr\t\t rd_ptr\t\tcounter_data_out");
        $monitor ("%g\t %b\t %b\t\t%b\t%b\t %b\t\t%b\t%b\t\t%b\t\t%b\t\t%b\t\t%b", $time, clk, rst_, fifo_write, fifo_read, fifo_full, fifo_empty, fifo_data_in, fifo_data_out, wr_ptr,
         rd_ptr, counter_data_out);

        rst_ = 1'b1;        
        clk = 1'b0;         
        rst_ = 1'b0;

        @(posedge clk); // check propert pr1 
        @(posedge clk) rst_ = 1'b1;  fifo_write = 0; fifo_read = 0;     // check property pr2
        @(posedge clk);

        @(posedge clk) rst_ = 1'b1;  fifo_write = 0; fifo_read = 1;            // check property pr5
        @(posedge clk) rst_ = 1'b1; fifo_write = 0; fifo_read = 0;

        @(posedge clk) for(int i = 0; i < 16; i++) begin                    // write all over 16 slots to check property pr3
                 fifo_write = 1; fifo_read = 0; fifo_data_in = 1;
        end
        @(posedge clk) rst_ = 1'b1; fifo_write = 1; fifo_read = 0;     // check property pr4
    end
    initial  // Dump waveform for debug 
    $dumpvars;

endmodule