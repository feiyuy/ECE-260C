//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 /*
Quantizer encode the result and quantize the difference between input and prediction.

 Feiyu Yang
 4/24/2022
 */
 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

 module quantizer(
    input   logic   [15:0]                                      diff_in,
    input   logic   [14:0]                                      step_size_in,
    input   logic                                               sign_in,

    output  logic   signed  [2:0]                               data_out,
    output  logic   signed  [16:0]                              diff_out
 );

    logic   signed  [16:0]                                  temp_result1;
    logic   signed  [16:0]                                  temp_result2;
    logic   signed  [16:0]                                  temp_result3;

    logic   [15:0]                                          temp_diff1;
    logic   [15:0]                                          temp_diff2;

    logic   [14:0]                                          temp_step1;
    logic   [14:0]                                          temp_step2;


    always_comb begin
        temp_result1                                    =   {5'b0, step_size_in[14:3]};
        
        if (diff_in >= step_size_in) begin
            data_out[2]                                 =   1;
            temp_diff1                                  =   diff_in - step_size_in;
            temp_result2                                =   temp_result1 + step_size_in;
        end
        else begin
            data_out[2]                                 =   0;
            temp_diff1                                  =   diff_in;
            temp_result2                                =   temp_result1;
        end
        temp_step1                                      =   {1'b0, step_size_in[14:1]};

        if (temp_diff1 >= temp_step1) begin
            data_out[1]                                 =   1;
            temp_diff2                                  =   temp_diff1 - temp_step1;
            temp_result3                                =   temp_result2 + temp_step1;
        end
        else begin
            data_out[1]                                 =   0;
            temp_diff2                                  =   temp_diff1;
            temp_result3                                =   temp_result2;
        end
        temp_step2                                      =   {1'b0, temp_step1[14:1]};

        if (temp_diff2 >= temp_step2) begin
            data_out[0]                                 =   1;
            diff_out                                    =   temp_result3 + temp_step2;
        end
        else begin
            data_out[0]                                 =   0;
            diff_out                                    =   temp_result3;
        end
    end
    
 endmodule



