`timescale 1ns/1ns
module upDownCounter16bit_property( data_in,
    rst_,
    ld_cnt,
    updn_cnt,
    count_enb,
    clk,
    data_out);

  input logic [15:0] data_in , data_out;
  input logic rst_, ld_cnt, updn_cnt, count_enb, clk;
`ifdef check_rst
    property pr1;
        @(posedge clk) $fell(rst_) |-> (data_out === 0);
    endproperty

    rstPr1: assert property (pr1) $display($stime,,,"\t\t %m PASS");
        else $display($stime,,,"\t\t %m FAIL");


`elsif check_ld_cnt_and_count_en_notEnable
    property pr2;                    //ld_cnt active low and count_enb active high
        @(posedge clk) disable iff (!rst_) !ld_cnt && !count_enb |-> data_out === $past(data_out);               //$rose(ld_cnt)
    endproperty  
                           // if ld_cnt == 1 then load is off
    ldCntCounterEnb: assert property(pr2) $display($stime,,,"\t\t %m PASS");
        else $display($stime,,,"\t\t %m FAIL");
`elsif check_ld_cnt_notEnable_and_countEnb_and_updncntEnb
    property pr3;                         //active low      active high
        @(posedge clk) disable iff(!rst_)
	 ld_cnt && count_enb |->
	 if(updn_cnt)
	 ##1 
	data_out === $past(data_out) + 1
	 else 
	##1 
	data_out === $past(data_out) -1;
    endproperty

    ldCntCountrEnbUpCnt: assert property(pr3) $display($stime,,,"\t\t %m PASS");
        else $display($stime,,,"\t\t %m FAIL");

`endif 
endmodule