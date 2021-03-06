//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 /*
This module perform multiply then add operation.

 Feiyu Yang
 5/12/2022
 */
 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ALU
(
    input   logic                                               clk,
    input   logic                                               rst,

    input   logic   signed  [15:0]                              data1_in,
    input   logic   signed  [15:0]                              data2_in,
    input   logic   signed  [15:0]                              data3_in,
    input   logic   signed  [15:0]                              data4_in, 
    input   logic   signed  [15:0]                              mu_in,
    input   logic                                               enable_in,

    input   logic   signed  [15:0]                              weight1_in,
    input   logic   signed  [15:0]                              weight2_in,
    input   logic   signed  [15:0]                              weight3_in,
    input   logic   signed  [15:0]                              weight4_in,   

    output  logic   signed  [15:0]                              data_out,
    output  logic   signed  [15:0]                              mu_out,
    output  logic                                               valid_out
 );


    logic   signed  [31:0]                                  temp_mul1;
    logic   signed  [31:0]                                  temp_mul2;
    logic   signed  [31:0]                                  temp_mul3;
    logic   signed  [31:0]                                  temp_mul4; 
    
    logic   signed  [31:0]                                  temp_mu1;
    logic   signed  [31:0]                                  temp_mu2;

    logic                                                   temp_enable1;
    logic                                                   temp_enable2;

    always_ff @(posedge clk) begin
        if (rst) begin
            temp_enable1                                <=  0;
            temp_enable2                                <=  0;
            valid_out                                   <=  0;
        end
        else begin
            temp_enable1                                <=  enable_in;
            temp_enable2                                <=  temp_enable1;
            valid_out                                   <=  temp_enable2;
        end
    end


    always_ff @(posedge clk) begin
        if (rst) begin
            temp_mul1                                   <=  0;
            temp_mul2                                   <=  0;
            temp_mul3                                   <=  0;
            temp_mul4                                   <=  0;

            temp_mu1                                    <=  0;
        end
        else begin
            if (enable_in) begin
                temp_mul1                               <=  data1_in * weight1_in;
                temp_mul2                               <=  data2_in * weight2_in;
                temp_mul3                               <=  data3_in * weight3_in;
                temp_mul4                               <=  data4_in * weight4_in;

                temp_mu1                                <=  mu_in;
            end
        end
    end

    logic   signed  [31:0]                                  temp_add1;
    logic   signed  [31:0]                                  temp_add2;

    always_ff @(posedge clk) begin
        if (rst) begin
            temp_add1                                   <=  0;
            temp_add2                                   <=  0;

            temp_mu2                                    <=  0;
        end
        else begin
            if (temp_enable1) begin
                temp_add1                               <=  temp_mul1 + temp_mul2;
                temp_add2                               <=  temp_mul3 + temp_mul4;

                temp_mu2                                <=  temp_mu1;
            end
        end
    end

    always_ff @ (posedge clk) begin
        if (rst) begin
            data_out                                    <=  0;
            mu_out                                      <=  0;
        end
        else begin
            if (temp_enable2) begin
                data_out                                <=  (temp_add1 + temp_add2) >>> 14;
                mu_out                                  <=  temp_mu2;
            end
        end
    end

endmodule
