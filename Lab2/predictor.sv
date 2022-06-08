//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 /*
 This module update predict result and index.

 Feiyu Yang
 4/24/2022
 */
 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

 module predictor
 (
    input   logic                                               clk,
    input   logic                                               rst,

    input   logic   signed  [15:0]                              pre_sample_in,
    input   logic   signed  [16:0]                              diff_in,
    input   logic   signed  [3:0]                               temp_result_in,
    input   logic   [7:0]                                       index_in,

    output  logic   signed  [15:0]                              pre_sample_out,
    output  logic   [7:0]                                       index_out
 );

    //Get index update based on the code
    logic   [7:0]                                          index_table      [15:0];

    initial begin
        $readmemh("IndexTable.list", index_table);
    end

    logic   signed  [8:0]                                   temp_index;
    logic   signed  [15:0]                                  temp_pre_sample;

    always_ff (@posedge clk) begin
        if (rst) begin
            temp_index                                  <=  0;
            temp_pre_sample                             <=  0;
        end
        else begin
            temp_index                                  <=  $signed({1'b0,index_in}) + $signed(index_table[$unsigned(temp_result_in)]);
            temp_pre_sample                             <=  (temp_result_in[3] == 0)? pre_sample_in + diff_in : pre_sample_in - diff_in;
        end
    end

    //Bound predict and index
    always_comb begin
        if (temp_index[8] == 1) begin
            assign  index_out                           =   0;
        end
        else if (temp_index > 88) begin
            assign  index_out                           =   88;
        end
        else begin
            assign  index_out                           =   temp_index[7:0];
        end

        if (temp_pre_sample > 32767) begin
            assign  pre_sample_out                      =   32767;
        end
        else if (temp_pre_sample < -32767) begin
            assign  pre_sample_out                      =   -32767;
        end
        else begin
            assign  pre_sample_out                      =   temp_pre_sample;
        end
    end

 endmodule
