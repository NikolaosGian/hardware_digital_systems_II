`timescale  1ns/1ns
module updownCOunter16bit_test_with_bind;
	logic [15:0] data_in;
	logic rst_, ld_cnt, updn_cnt, count_enb, clk;
	logic [15:0] data_out;
	/*
module upDownCounter16bit (
    data_in,
    rst_,
    ld_cnt,
    updn_cnt,
    count_enb,
    clk,
    data_out
);*/
	upDownCounter16bit counter(.data_in(data_in), .rst_(rst_), .ld_cnt(ld_cnt), .updn_cnt(updn_cnt), .count_enb(count_enb), .clk(clk), .data_out(data_out));

	bind upDownCounter16bit upDownCounter16bit_property dut(data_in, rst_, ld_cnt, updn_cnt, count_enb, clk, data_out);

    always @(posedge clk) 
        $display($stime,,,"clk=%b\t rst_= %b\t ld_cnt=%b\t count_enb=%b\t updn_cnt=%b\t data_in=%b\t\t data_out=%b", clk, rst_, ld_cnt, count_enb, updn_cnt, data_in, data_out); 

    always #5 clk = ~clk; 
    
    initial begin
        rst_ = 1'b1 ;        // set reset off
        ld_cnt = 1'b1;      // set load off
        count_enb = 1'b0;   // set off counter enable
        clk = 1'b0;         // set clk at 0
        rst_ = 1'b0;
     
     @(posedge clk) rst_ = 1'b1; data_in = 2; ld_cnt = 1'b0;
     @(posedge clk) count_enb = 1'b1; ld_cnt = 1'b1; updn_cnt = 1'b1; rst_ = 1'b1;
     @(posedge clk) rst_ = 1'b1; count_enb = 1'b1; ld_cnt = 1'b1; updn_cnt = 1'b0; 
     @(posedge clk);
     @(posedge clk);
    end
endmodule

