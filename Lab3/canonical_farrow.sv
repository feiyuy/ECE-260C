// from slide 16 in FarrowFilters.ppt
// ECE260C
// upper 16 multipliers: gain factor format = 2 signed integer + 14 fraction
// -1/6 = 16'b11_11010101010101
// -1/3 = 16'b11_10101010101011
// -1/2 = 16'b11_10000000000000
// -1   = 16'b11_00000000000000 
//  1/6 = 16'b00_00101010101011
//  1/2 = 16'b00_10000000000000
//  1   = 16'b01_00000000000000
module canonical_farrow(
  input                     clk,
                            reset,
  input        signed[15:0] mu,				// format 2 integer + 14 fraction
  input        signed[15:0] dat_in,
  output logic signed[15:0] dat_out); 		// (data output register not shown in drawing)

// dff[0] is unpictured register for data input
  logic signed [15:0] muq;                 // unshown input register for offset control (mu)
  logic signed [15:0] dff[4];              // internal data registers, not replicated
  logic signed [31:0] prod[4][4];          // fixed gain multipiers

  logic signed [15:0] coef[4][4];
  initial begin	 :set_coefs
    coef[0][0] = 16'b11_11010101010101;    // -1/6
    coef[0][1] = 16'b00_10000000000000;	   //  1/2
    coef[0][2] = 16'b11_10000000000000;	   // -1/2
    coef[0][3] = 16'b00_00101010101011;	   //  1/6

    coef[1][0] = 16'b00_10000000000000;	   //  1/2
    coef[1][1] = 16'b11_00000000000000;	   // -1
    coef[1][2] = 16'b00_10000000000000;	   //  1/2
    coef[1][3] = 16'b00_00000000000000;    //  0 

    coef[2][0] = 16'b11_10101010101011;    // -1/3
    coef[2][1] = 16'b11_10000000000000;    // -1/2
    coef[2][2] = 16'b01_00000000000000;	   //  1
    coef[2][3] = 16'b11_11010101010101;    // -1/6

    coef[3][0] = 16'b00_00000000000000;    //  0
    coef[3][1] = 16'b01_00000000000000;	   //  1
    coef[3][2] = 16'b00_00000000000000;	   //  0
    coef[3][3] = 16'b00_00000000000000;	   //  0
  end : set_coefs

  logic signed[15:0] s[4];                 // column adders
  logic signed[15:0] sum;
// 4x4 multiplier array
  always_comb begin
    for(int i=0;i<4;i++)
	  for(int j=0;j<4;j++)
	    prod[i][j] = coef[i][j]*dff[j];
  end

// vertical sums of products
  always_comb begin
    for(int j=0;j<4;j++) 
      s[j] = (prod[j][0]+prod[j][1]+prod[j][2]+prod[j][3])>>>14;
  end

// last row ...
  logic signed[31:0] p[3];

  always_comb begin 
	p[0] = muq*s[0];
	p[1] = muq*(s[1]+(p[0]>>>14));
	p[2] = muq*(s[2]+(p[1]>>>14)); 
	sum  =      s[3]+(p[2]>>>14); 
  end

// input, internal pipe, output registers
  always @(posedge clk) begin
    muq     <= mu;
    dff[0]  <= dat_in;
    dff[1]  <= dff[0];
	dff[2]  <= dff[1];
	dff[3]  <= dff[2];
	dat_out <= sum;
  end

endmodule