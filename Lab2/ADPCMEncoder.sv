//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 /*
 This is the top module of the encoder.

 Feiyu Yang
 4/24/2022
 */
 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

 module ADPCMEncoder
 (
    input   logic                                               clk,
    input   logic                                               rst,

    input   logic   signed  [15:0]                              data_in,
    input   logic                                               eanble_in,

    output  logic   signed  [3:0]                               data_out,
    output  logic                                               valid_out
 );

    logic   signed  [15:0]                                  temp_data;
    logic                                                   temp_valid;

    always_ff @(posedge clk) begin
        if (rst) begin
            temp_data                                   <=  0;
            temp_valid                                  <=  0;
        end
        else begin
            temp_data                                   <=  data_in;
            temp_valid                                  <=  eanble_in;
        end
    end     

    logic   signed  [15:0]                                  pre_sample;
    logic   [7:0]                                           index;

    //Get step size based on the index
    logic   [14:0]                                          step_table      [88:0];

    initial begin
        $readmemh("StepTable.mem", step_table);
    end

    logic   [14:0]                                          step_size;
    assign  step_size                                   =   step_table[index];

    logic   signed  [16:0]                                  diff;
    logic   signed  [3:0]                                   temp_result;
    logic   signed  [16:0]                                  quant_diff;

    //Compute the difference between current input data and predicted sample
    //This could be replaced by other adder design
    always_comb begin
        if (temp_data >= pre_sample) begin
            temp_result[3]                              =   0;
            diff                                        =   {temp_data[15], temp_data} - {pre_sample[15], pre_sample};
        end
        else begin
            temp_result[3]                              =   1;
            diff                                        =   {pre_sample[15], pre_sample} - {temp_data[15], temp_data};
        end
    end

    //Get encoding result and quantized difference
    quantizer   quantizer_inst
    (
        .diff_in                                        (diff[15:0]),
        .step_size_in                                   (step_size),
        .sign_in                                        (temp_result[3]),

        .data_out                                       (temp_result[2:0]),
        .diff_out                                       (quant_diff)
    );

    always_ff @(posedge clk) begin
        if (rst) begin
            data_out                                    <=  0;
            valid_out                                   <=  0;
        end
        else begin
            data_out                                    <=  temp_result;
            valid_out                                   <=  temp_valid;
        end
    end

    //Update prediction and index
    logic   signed  [15:0]                                  pre_sample_temp;
    logic           [7:0]                                   index_temp;

    predictor predictor_inst
    (
        .clk                                            (clk),
        .rst                                            (rst),

        .pre_sample_in                                  (pre_sample),
        .diff_in                                        (quant_diff),
        .temp_result_in                                 (temp_result),
        .index_in                                       (index),

        .pre_sample_out                                 (pre_sample_temp),
        .index_out                                      (index_temp)
    );

    assign  pre_sample                                  =   pre_sample_temp;
    assign  index                                       =   index_temp;

 endmodule







 