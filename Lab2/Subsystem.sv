// -------------------------------------------------------------
// 
// File Name: D:\class\ECE\ECE260C\2022\Canvas\Lab Material\lab2 -- adpcm\hdl_proj_round_trip\hdlsrc\adpcm_rtl_min\Subsystem.v
// Created: 2022-04-07 18:06:56
// 
// Generated by MATLAB 9.12 and HDL Coder 3.20
// 
// 
// -- -------------------------------------------------------------
// -- Rate and Clocking Details
// -- -------------------------------------------------------------
// Model base rate: 1e-05
// Target subsystem base rate: 1e-05
// 
// 
// Clock Enable  Sample Time
// -- -------------------------------------------------------------
// ce_out        1e-05
// -- -------------------------------------------------------------
// 
// 
// Output Signal                 Clock Enable  Sample Time
// -- -------------------------------------------------------------
// Out1                          ce_out        1e-05
// Out2                          ce_out        1e-05
// -- -------------------------------------------------------------
// 
// -------------------------------------------------------------


// -------------------------------------------------------------
// 
// Module: Subsystem
// Source Path: adpcm_rtl_min/Subsystem
// Hierarchy Level: 0
// 
// -------------------------------------------------------------

`timescale 1 ns / 1 ns

module Subsystem
          (clk,
           reset_x,
           clk_enable,
           in1,
           ce_out,
           Out1,
           Out2);


  input   clk;
  input   reset_x;
  input   clk_enable;
  input   signed [19:0] in1;  // sfix20_En16
  output  ce_out;
  output  signed [19:0] Out1;  // sfix20_En16
  output  signed [1:0] Out2;  // sfix2


  wire signed [1:0] adpcm_encoder2_out1;  // sfix2
  wire signed [19:0] ADPCM_Decoder1_out1;  // sfix20_En16

  logic   valid;


  ADPCMEncoder ADPCMEncoder_inst  (.clk(clk),
                                   .rst(reset_x),
                                   .eanble_in(clk_enable),
                                   .data_in(in1),  // sfix20_En16
                                   .data_out(adpcm_encoder2_out1),  // sfix2
                                   .valid_out(valid)
                                   );

  ADPCMDncoder ADPCMDncoder_inst (.clk(clk),
                                   .reset_x(reset_x),
                                   .enb(valid),
                                   .In1(adpcm_encoder2_out1),  // sfix2
                                   .Out1(ADPCM_Decoder1_out1)  // sfix20_En16
                                   );

  assign Out1 = ADPCM_Decoder1_out1;

  assign Out2 = adpcm_encoder2_out1;

  assign ce_out = clk_enable;

endmodule  // Subsystem
