`timescale 1 ns / 1 ns
module upDownCounter16bit (
    data_in,
    rst_,
    ld_cnt,
    updn_cnt,
    count_enb,
    clk,
    data_out
);
  input logic [15:0] data_in;
  input logic rst_, ld_cnt, updn_cnt, count_enb, clk;
  output logic [15:0] data_out;
 
  always_ff @(posedge clk, negedge rst_)begin
    if(!rst_)begin  // active low reset
      data_out <= 0;
    end 
    else if(!ld_cnt)begin      //actice low load_counter
      data_out <= data_in; 
    end
    else if(count_enb == 1)begin
      if(updn_cnt == 1)begin
        if(data_out == 16'b1)begin
            data_out <= 0;
        end else begin
            data_out <= data_out + 1;
        end
      end else if(updn_cnt == 0) begin
        if(data_out == 16'b0)begin
            data_out <= 16'hffff;
        end else begin
            data_out <= data_out - 1;
        end 
      end
    end 
  end
   
endmodule
