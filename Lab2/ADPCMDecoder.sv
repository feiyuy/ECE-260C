//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 /*
 This is the top module of the decoder.

 Feiyu Yang
 4/26/2022
 */
 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ADPCMDecoder
(
    input   logic                                               clk,
    input   logic                                               rst,

    input   logic   signed  [3:0]                               data_in,
    input   logic                                               enable_in,

    output  logic   signed  [15:0]                              data_out,
    output  logic                                               valid_out
);

    logic   signed  [3:0]                                   temp_code;

    logic                                                   temp_enable;

    always_ff @(posedge clk) begin
        if (rst) begin
            temp_code                                   <=  0;
            temp_enable                                 <=  0;
        end
        else begin
            if (enable_in) begin
                temp_code                               <=  data_in;
                temp_enable                             <=  1;
            end
            else begin
                temp_code                               <=  0;
                temp_enable                             <=  0;
            end
        end
    end

    logic   [7:0]                                           index;

   //Get step size based on the index
    logic   [14:0]                                          step_table      [88:0];

    initial begin
        $readmemh("StepTable.mem", step_table);
    end

    logic   [14:0]                                          step_size;
    assign  step_size                                   =   step_table[index];


    index_updator   index_updator_inst
    (
        .clk                                                (clk),
        .rst                                                (rst),
        
        .index_in                                           (index),
        .code_in                                            (temp_code),

        .index_out                                          (index)
    );

    logic   signed  [15:0]                                  temp_result;

    predict_updator predict_updator_inst
    (
        .code_in                                            (temp_code),
        .predict_in                                         (data_out),
        .step_size_in                                       (step_size),
        
        .predict_out                                        (temp_result)
    );

    always_ff @(posedge clk) begin
        if (rst) begin
            data_out                                    <=  0;
        end
        else begin
            if (temp_enable) begin
                valid_out                               <=  1;
                data_out                                <=  temp_result;
            end
            else begin
                valid_out                               <=  0;
                data_out                                <=  0;
            end
        end
    end
    
endmodule


    

            