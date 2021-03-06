
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 /*
This is the top module of the farrow filter.

 Feiyu Yang
 5/12/2022
 */
 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

 module farrow
 (
    input   logic                                               clk,
    input   logic                                               rst,

    input   logic                                               enable_in,     
    input   logic   signed  [15:0]                              data_in,
    input   logic   signed  [15:0]                              mu_in,         

    output  logic   signed  [15:0]                              data_out,
    output  logic                                               enable_out
 );

    logic   signed  [15:0]                                  temp_input1;
    logic   signed  [15:0]                                  temp_input2;
    logic   signed  [15:0]                                  temp_input3;
    logic   signed  [15:0]                                  temp_input4;

    logic   signed  [15:0]                                  temp_mu1;
    logic   signed  [15:0]                                  temp_mu2;
    
    logic                                                   temp_enable1;
    logic   [3:0]                                           temp_enable2;
    logic                                                   temp_enable3;

    assign  temp_enable3                                =   &temp_enable2;

    always_ff @(posedge clk) begin
        if (rst) begin
            temp_input1                                 <=  0;
            temp_input2                                 <=  0;
            temp_input3                                 <=  0;
            temp_input4                                 <=  0;
            temp_mu1                                    <=  0;
        end
        else begin
            if (enable_in) begin
                temp_input1                             <=  data_in;
                temp_input2                             <=  temp_input1;
                temp_input3                             <=  temp_input2;
                temp_input4                             <=  temp_input3;
                temp_mu1                                <=  mu_in;
            end
        end
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            temp_enable1                                <=  0;
        end 
        else begin
            temp_enable1                                <=  enable_in;
        end
    end

    logic   signed  [15:0]                                  temp_output1;
    logic   signed  [15:0]                                  temp_output2;
    logic   signed  [15:0]                                  temp_output3;
    logic   signed  [15:0]                                  temp_output4;

    ALU ALU_inst1
    (
        .clk                                                (clk),
        .rst                                                (rst),

        .data1_in                                           (temp_input1),
        .data2_in                                           (temp_input2),
        .data3_in                                           (temp_input3),
        .data4_in                                           (temp_input4),
        .mu_in                                              (temp_mu1), 
        .enable_in                                          (temp_enable1),  

        .weight1_in                                         (16'b11_11010101010101),
        .weight2_in                                         (16'b00_10000000000000),
        .weight3_in                                         (16'b11_10000000000000),
        .weight4_in                                         (16'b00_00101010101011),

        .data_out                                           (temp_output1),
        .mu_out                                             (temp_mu2),
        .valid_out                                          (temp_enable2[0])  
    );

    ALU ALU_inst2
    (
        .clk                                                (clk),
        .rst                                                (rst),

        .data1_in                                           (temp_input1),
        .data2_in                                           (temp_input2),
        .data3_in                                           (temp_input3),
        .data4_in                                           (temp_input4),   
        .mu_in                                              (),
        .enable_in                                          (temp_enable1),  
        
        .weight1_in                                         (16'b00_10000000000000),
        .weight2_in                                         (16'b11_00000000000000),
        .weight3_in                                         (16'b00_10000000000000),
        .weight4_in                                         (16'b00_00000000000000),

        .data_out                                           (temp_output2),
        .mu_out                                             (),       
        .valid_out                                          (temp_enable2[1])
    );

    ALU ALU_inst3
    (
        .clk                                                (clk),
        .rst                                                (rst),

        .data1_in                                           (temp_input1),
        .data2_in                                           (temp_input2),
        .data3_in                                           (temp_input3),
        .data4_in                                           (temp_input4),   
        .mu_in                                              (),
        .enable_in                                          (temp_enable1),  
        
        .weight1_in                                         (16'b11_10101010101011),
        .weight2_in                                         (16'b11_10000000000000),
        .weight3_in                                         (16'b01_00000000000000),
        .weight4_in                                         (16'b11_11010101010101),

        .data_out                                           (temp_output2),
        .mu_out                                             (),       
        .valid_out                                          (temp_enable2[2])
    );

    ALU ALU_inst4
    (
        .clk                                                (clk),
        .rst                                                (rst),

        .data1_in                                           (temp_input1),
        .data2_in                                           (temp_input2),
        .data3_in                                           (temp_input3),
        .data4_in                                           (temp_input4),   
        .mu_in                                              (),
        .enable_in                                          (temp_enable1),  
        
        .weight1_in                                         (16'b00_00000000000000),
        .weight2_in                                         (16'b01_00000000000000),
        .weight3_in                                         (16'b00_00000000000000),
        .weight4_in                                         (16'b00_00000000000000),

        .data_out                                           (temp_output2),
        .mu_out                                             (),       
        .valid_out                                          (temp_enable2[3])
    );

    weighted weighted_inst
    (
        .clk                                                (clk),
        .rst                                                (rst),

        .data1_in                                           (temp_output1),
        .data2_in                                           (temp_output2),
        .data3_in                                           (temp_output3),
        .data4_in                                           (temp_output4),  
        .mu_in                                              (temp_mu2),
        .enable_in                                          (temp_enable3),   

        .data_out                                           (data_out),
        .valid_out                                          (enable_out)
    );

 endmodule


