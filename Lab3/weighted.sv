//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 /*
This module perform sum of AULs' result with weight mu.

 Feiyu Yang
 5/12/2022
 */
 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

 module weighted
 (
    input   logic                                               clk,
    input   logic                                               rst,

    input   logic   signed  [15:0]                              data1_in,
    input   logic   signed  [15:0]                              data2_in,
    input   logic   signed  [15:0]                              data3_in,
    input   logic   signed  [15:0]                              data4_in, 
    input   logic   signed  [15:0]                              mu_in,

    output  logic   signed  [15:0]                              data_out
 );

    logic   signed  [15:0]                                  temp1_mu1;
    logic   signed  [15:0]                                  temp2_mu1;

    logic   signed  [31:0]                                  temp1_mu2;
    logic   signed  [15:0]                                  temp2_mu2;   

    logic   signed  [31:0]                                  temp1_mu3;

    logic   signed  [15:0]                                  temp1_data1;
    logic   signed  [15:0]                                  temp1_data2;
    logic   signed  [15:0]                                  temp1_data3;
    logic   signed  [15:0]                                  temp1_data4;

    always_ff @(posedge clk) begin
        if (rst) begin
            temp1_mu1                                   <=  0;
            temp1_mu2                                   <=  0;

            temp1_data1                                 <=  0;
            temp1_data2                                 <=  0;
            temp1_data3                                 <=  0;
            temp1_data4                                 <=  0;
        end
        else begin
            temp1_mu1                                   <=  mu_in;
            temp1_mu2                                   <=  mu_in * mu_in;

            temp1_data1                                 <=  data1_in;
            temp1_data2                                 <=  data2_in;
            temp1_data3                                 <=  data3_in;
            temp1_data4                                 <=  data4_in;
        end
    end

    logic   signed  [31:0]                                  temp2_mu;

    logic   signed  [15:0]                                  temp2_data1;
    logic   signed  [15:0]                                  temp2_data2;
    logic   signed  [15:0]                                  temp2_data3;
    logic   signed  [15:0]                                  temp2_data4;

    always_ff @(posedge clk) begin
        if (rst) begin
            temp2_mu1                                   <=  0;
            temp2_mu2                                   <=  0;
            temp1_mu3                                   <=  0;

            temp2_data1                                 <=  0;
            temp2_data2                                 <=  0;
            temp2_data3                                 <=  0;
            temp2_data4                                 <=  0;
        end
        else begin
            temp2_mu1                                   <=  temp1_mu1;
            temp2_mu2                                   <=  temp1_mu2[31:16];
            temp1_mu3                                   <=  temp1_mu[31:16] * mu_in;

            temp2_data1                                 <=  temp1_data1;
            temp2_data2                                 <=  temp1_data2;
            temp2_data3                                 <=  temp1_data3;
            temp2_data4                                 <=  temp1_data4;
        end
    end

    logic   signed  [31:0]                                  temp_mul1;
    logic   signed  [31:0]                                  temp_mul2;
    logic   signed  [31:0]                                  temp_mul3;
    logic   signed  [15:0]                                  temp_mul4; 

    always_ff @(posedge clk) begin
        if (rst) begin
            temp_mul1                                   <=  0;
            temp_mul2                                   <=  0;
            temp_mul3                                   <=  0;
            temp_mul4                                   <=  0;
        end
        else begin
            temp_mul1                                   <=  temp2_data1 * temp1_mu3[31:16];
            temp_mul2                                   <=  temp2_data2 * temp2_mu2;
            temp_mul3                                   <=  temp2_data3 * temp2_mu1;
            temp_mul4                                   <=  temp2_data4;
        end
    end

    logic   signed  [15:0]                                  temp_add1;
    logic   signed  [15:0]                                  temp_add2;

    always_ff @(posedge clk) begin
        if (rst) begin
            temp_add1                                   <=  0;
            temp_add2                                   <=  0;
        end
        else begin
            temp_add1                                   <=  temp_mul1[31:16] + temp_mul2[31:16];
            temp_add2                                   <=  temp_mul3[31:16] + temp_mul4;
        end
    end

    always_ff @ (posedge clk) begin
        if (rst) begin
            data_out                                    <=  0;
        end
        else begin
            data_out                                    <=  temp_add1 + temp_add2;
        end
    end

 endmodule