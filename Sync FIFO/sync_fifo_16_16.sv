`timescale  1ns/1ns
module sync_fifo_16_16(fifo_data_in, rst_, fifo_write, fifo_read, clk,
 fifo_data_out, fifo_full, fifo_empty , wr_ptr, rd_ptr, counter_data_out);

    parameter DATA_WIDTH = 16;
    parameter DEPTH = 16;
    parameter ADDR_WIDTH = $clog2(DEPTH);

    input logic  [DATA_WIDTH - 1 : 0] fifo_data_in;
    input logic  rst_, fifo_write, fifo_read, clk;

    output logic  [DATA_WIDTH - 1 : 0] fifo_data_out;
    output logic  fifo_full , fifo_empty;


    output logic [ADDR_WIDTH -1 : 0] wr_ptr , rd_ptr;
    
    logic [DATA_WIDTH -1 : 0] rdata_temp;
            //15:0                      //15:0
    logic [DATA_WIDTH -1 : 0] memory [DEPTH - 1 : 0]; //16 slots with width of 16 bits
    
    logic updn_cnt, count_enb;
    output logic [4:0] counter_data_out;

    counter cnt(.rst_(rst_), .updn_cnt(updn_cnt), .count_enb(count_enb), .clk(clk), .data_out(counter_data_out));

    // Init memory when reset is active
    integer  i;
    always_ff@(posedge clk, negedge rst_)begin
        if(!rst_)begin
            for(i=0; i < DEPTH; i++)
                memory[i] <= 0;
                
        end
    end

    // write to memory
    always_ff@(posedge clk, negedge rst_ )begin
        if(fifo_write && ~fifo_full)begin
            memory[wr_ptr] <= fifo_data_in;

        end
    end

    //Default val of read data when reset
    always_ff@(posedge clk, negedge rst_)begin
        if(!rst_)begin
            rdata_temp <= 0;
        end                 
    end

    //Read from Fifo
    always_ff@(posedge clk, negedge rst_ )begin
        if(fifo_read && ~fifo_empty)begin
            rdata_temp <= memory[rd_ptr];
        end
    end

    // write pointer handler
    always_ff@(posedge clk, negedge rst_)begin
        if (!rst_)begin
            wr_ptr <= 0;
            count_enb <= 0; 
        end
        else if(fifo_write && ~fifo_full)begin
            wr_ptr <= wr_ptr + 1;
            updn_cnt <= 1;
            count_enb <= 1; 
        end
    end
     // read pointer handler
    always_ff@(posedge clk, negedge rst_)begin
        if(!rst_)begin
            rd_ptr <= 0;
            count_enb <= 0;
        end
        else if(fifo_read && ~(fifo_empty))begin
            rd_ptr <= rd_ptr + 1;
            updn_cnt <= 0;
            count_enb <= 1;
        end
    end
    

    // fifo full usage when is 16'hffff then set fifo_full 1 
    assign fifo_full = (counter_data_out >= 16) ? 1'b1 : 1'b0;
    // fifo empty when counter is equal zero then actived it
    assign fifo_empty = (counter_data_out === 0) ? 1'b1 : 1'b0;
   
    assign fifo_data_out = rdata_temp;
    
endmodule
