`timescale 1 ns / 1 ns
module counter (
    rst_,
    updn_cnt,
    count_enb,
    clk,
    data_out
);
  input logic rst_, updn_cnt, count_enb, clk;
  output logic [4:0] data_out;
 
  always_ff @(posedge clk, negedge rst_)begin
    if(!rst_)begin  // active low reset
      data_out <= 0;
    end 
    else if(count_enb == 1)begin
      if(updn_cnt == 1)begin
            data_out <= data_out + 1;
      end else if(updn_cnt == 0) begin
            data_out <= data_out - 1; 
      end
    end 
  end
   
endmodule
