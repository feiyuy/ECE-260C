// test bench for canonical Farrow
module canonical_farrow_tb();

  logic               clk = 'b0,
                      reset = 'b1;
                      enable = 'b0;
  logic  signed[15:0] mu=0,		            // fractional timing offset, format 2 integer . 14 fraction	
                      dat_in=0,				// data input, integer
                      dif=40;					// difference (related to offset) between dat_in and dat_out
  wire   signed[15:0] dat_out; 				// data output, should be shifted/delayed version of data input
  logic               enable_out;

farrow cf1
(.clk(clk),
.rst(reset),
.enable_in(enable),
.mu_in(mu),
.data_in(dat_in),
.data_out(dat_out),
.enable_out(enable_out)
);

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
    dif = dat_in - dat_out;
	if(dif<40) dif=40;						// for graphing purposes only
	if(dif>60) dif=60;					// for graphing purposes only
    if(dat_out==='bx) dif=40;
  end
  #20ns $stop;
end
								
endmodule