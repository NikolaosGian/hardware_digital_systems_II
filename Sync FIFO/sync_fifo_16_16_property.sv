`timescale 1ns/1ns
module sync_fifo_16_16_property(fifo_data_in, rst_, fifo_write, fifo_read, clk,
  fifo_full, fifo_empty, wr_ptr, rd_ptr, counter_data_out);
    parameter DATA_WIDTH = 16;
    parameter DEPTH = 16;
    parameter ADDR_WIDTH = $clog2(DEPTH);
    input logic  [DATA_WIDTH - 1 : 0] fifo_data_in;
    input logic  rst_, fifo_write, fifo_read, clk;
    input logic  fifo_full , fifo_empty;
    input logic [ADDR_WIDTH -1 : 0] wr_ptr , rd_ptr;
    input logic [4:0] counter_data_out;

`ifdef check_rst
    property pr1;
        @(posedge clk) (!rst_) |-> (rd_ptr===0) && (wr_ptr===0) && (counter_data_out===0) && (fifo_empty===1) && (fifo_full===0);
    endproperty

    rstPr1: assert property(pr1) $display($stime,,,"\t\t %m PASS");
            else $display($stime,,,"\t\t %m FAIL");

`elsif check_empty

    property pr2;
        @(posedge clk) disable iff(!rst_) counter_data_out === 0 |-> fifo_empty;
    endproperty

    fifoEmpty: assert property(pr2) $display($stime,,,"\t\t %m PASS");
            else $display($stime,,,"\t\t %m FAIL");

`elsif check_full
    property pr3;
        @(posedge clk) disable iff(!rst_) counter_data_out >= 16 |-> fifo_full; 
    endproperty

    checkFull: assert property(pr3) $display($stime,,,"\t\t %m PASS");
            else $display($stime,,,"\t\t %m FAIL");

`elsif check_writePtr
    property pr4;
        @(posedge clk) disable iff(!rst_) fifo_full && fifo_write && !fifo_read |-> $stable(wr_ptr);
    endproperty

    checkWritePtr: assert property (pr4) $display($stime,,,"\t\t %m PASS");
            else $display($stime,,,"\t\t %m FAIL"); 

`elsif check_readPtr
    property pr5;
        @(posedge clk) disable iff(!rst_) fifo_empty && fifo_read && !fifo_write |-> $stable(rd_ptr);
    endproperty

    checkReadPtr: assert property (pr5) $display($stime,,,"\t\t %m PASS");
            else $display($stime,,,"\t\t %m FAIL"); 
`endif
endmodule