// testbench for fibonacci_calculator2 
class myPacket;

randc bit [4:0] key;
constraint input_s1 {key >= 0; key <= 23;}

endclass

module fibo_testbench2;

myPacket pkt;
 
bit        RST_N,		    // driving into design
           CLK,START;
bit [4:0]  INPUT_S;
int        ct;			    // parallel 
wire[27:0] DOUT;	        // receiving from design
wire       DONE;

logic[27:0] fiblisth[36], 	// table of fibo values in binary coded decimal 
            fiblistd[36];   // table of Fibo values	in decimal



initial begin
  $readmemh("fib_table.txt",fiblisth);	 // readmem thinks this is hex
  #1ns for(int i=0; i<36; i++) begin     // convert BCD to proper binary
     fiblistd[i] = fiblisth[i][3:0];
	 for(int j=1; j<7; j++) begin
       fiblistd[i] = fiblistd[i] + (10**j)*fiblisth[i][4*j+3 -: 4];
     end 
  end 
  #2000ns $stop;
end

// DUT 
  fibonacci_calculator U_Fibonacci_generator
  (.input_s(INPUT_S),		 // inputs
   .reset  (RST_N),
   .clk    (CLK),
   .begin_fibo(START),
   .fibo_out(DOUT),			 // outputs
   .done   (DONE));
 
initial begin
   pkt = new();
//  $dumpfile("dump.vcd");
//  $dumpvars;
   for (int i=0; i<10; i++) begin
          pkt.randomize();
          INPUT_S = pkt.key;
   #30ns  RST_N = 1;
   #10ns  RST_N = 0;
   #10ns  START = 1;
   #10ns  START = 0;
          wait(DONE);
          display1;         // call task to check our work
   end
/*
          pkt.randomize();
          INPUT_S = pkt.key;
   #10ns  RST_N = 1;
   #10ns  RST_N = 0;
   #10ns  START = 1;
   #10ns  START = 0;
          wait(DONE);
          display1;
          pkt.randomize();
          INPUT_S = pkt.key;
   #10ns  RST_N = 1;
   #10ns  RST_N = 0;
   #10ns  START = 1;
   #10ns  START = 0;
          wait(DONE);

   #10ns  display1;
*/
   #10ns  $stop;
end
 
always begin
  #5ns CLK = 1;
  #2ns if(RST_N) ct = 0; else ct++;
  #3ns CLK = 0;
//  if(!DONE) display1;
end
 
task display1;
  if(DOUT==fiblistd[INPUT_S])
   $display("fib_ct=%d, ct=%d, fib_out=%d, correct=%d",
      INPUT_S,ct,DOUT,fiblistd[INPUT_S]);
  else 
   $display("oops  fib_ct=%d, ct=%d, fib_out=%d, correct=%d",
      INPUT_S,ct,DOUT,fiblistd[INPUT_S]);
endtask
  
endmodule