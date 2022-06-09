// test bench for canonical Farrow
module canonical_farrow_tb();

  logic               clk = 'b0,
                      reset = 'b1,
                      enable = 'b0;
  logic  signed[15:0] mu=0,		            // fractional timing offset, format 2 integer . 14 fraction	
                      dat_in=0;				// data input, integer
  wire   signed[15:0] dat_out; 				// data output, should be shifted/delayed version of data input
  wire   signed[15:0] test_result;
  logic               enable_out;
  logic               correct;

farrow cf1
(.clk(clk),
.rst(reset),
.enable_in(enable),
.mu_in(mu),
.data_in(dat_in),
.data_out(test_result),
.enable_out(enable_out)
);

canonical_farrow referemce (.*);

logic signed [15:0] temp_result1, temp_result2, temp_result3, temp_result4, temp_result5, temp_result6, ref_result;
assign correct = ref_result == test_result;

always @(posedge clk) begin
  if (reset) begin
    temp_result1 <= 0;
    temp_result2 <= 0;
    temp_result3 <= 0;
    temp_result4 <= 0;
    temp_result5 <= 0;
    temp_result6 <= 0;
    ref_result   <= 0;
  end
  else begin
    temp_result1 <= dat_out;
    temp_result2 <= temp_result1;
    temp_result3 <= temp_result2;
    temp_result4 <= temp_result3;
    temp_result5 <= temp_result4;
    temp_result6 <= temp_result5;
    ref_result  <= temp_result6;
  end
end

always begin
  #5ns clk = 'b1;
  #5ns clk = 'b0;
end

initial begin
  #20ns reset = 'b0;
  enable = 'b1;
  for(int i=0; i<16384*4; i++) begin
    #10ns mu = (i[19:4]);					// increment mu every 16 clock cycles
    if(i[11]) 
	  dat_in = (65536-(i<<<4))-1;
	else
	  dat_in = (i<<<4)-1;						    // increment data by 16 on every clock cycle
  end
  #20ns $stop;
end


								
endmodule