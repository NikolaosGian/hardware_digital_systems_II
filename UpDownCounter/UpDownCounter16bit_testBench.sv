`timescale 1 ns / 1 ns
module upDownCounter16bit_testBench;

  logic [15:0] data_in;
  logic rst_, ld_cnt, updn_cnt, count_enb, clk;
  logic [15:0]data_out;

  initial begin

  $display ("time\t clk \tld_cnt\t data_in\t\t data_out ");
  $monitor ("%g\t %b\t %b\t %b\t", $time, clk, ld_cnt, data_in, data_out);

  clk = 0;
  rst_ = 1'b0;    // start with reset
  //updn_cnt = 1'b1;    // 
  //ld_cnt = 1'b1;    // do load
	#10

  rst_ = 1'b1;    // reset at not trigger
  data_in = 2;  // 2 
  ld_cnt = 1'b0;  // do load
	#20
    
  count_enb = 1'b1;  
	ld_cnt = 1'b1;  //load off
  updn_cnt = 1'b1;  // count up
  rst_ = 1'b1;    // reset off


  #35
  rst_ = 1'b1;
  count_enb = 1'b0;  
	ld_cnt = 1'b1;
  updn_cnt = 1'b0; // start count down
  end

always #5 clk = ~clk;
upDownCounter16bit u0(.*);

initial  // Dump waveform for debug 
$dumpvars;

endmodule
