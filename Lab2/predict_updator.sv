
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 /*
This module updates the predict result.

 Feiyu Yang
 4/26/2022
 */
 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

 module predict_updator
 (
    input   logic   signed  [3:0]                               code_in,
    input   logic   signed  [15:0]                              predict_in,
    input   logic   [14:0]                                      step_size_in,

    output  logic   signed  [15:0]                              predict_out
 );

    logic   signed  [15:0]                                  step_size;
    assign  step_size                                   =   $signed({1'b0, step_size_in});

    logic   signed  [15:0]                                  diff_temp1;
    logic   signed  [15:0]                                  diff_temp2;
    logic   signed  [15:0]                                  diff_temp3;
    logic   signed  [15:0]                                  diff_temp4;

    logic   signed  [16:0]                                  temp_result;

    always_comb begin
        diff_temp1                                      =   {3'b0, step_size[15:3]};

        if (code_in[2]) begin
            diff_temp2                                  =   diff_temp1 + step_size;
        end
        else begin
            diff_temp2                                  =   diff_temp1;
        end

        if (code_in[1]) begin
            diff_temp3                                  =   diff_temp2 + {1'b0, step_size[15:1]};
        end
        else begin
            diff_temp3                                  =   diff_temp2;
        end

        if (code_in[0]) begin
            diff_temp4                                  =   diff_temp3 + {2'b0, step_size[15:2]};
        end
        else begin
            diff_temp4                                  =   diff_temp3;
        end
    end

    always_comb begin
        temp_result                                     =  (code_in[3] == 0)? predict_in + diff_temp4 : predict_in - diff_temp4;

        if (temp_result > 32767) begin
            assign  predict_out                         =   32767;
        end
        else if (temp_result < -32767) begin
            assign  predict_out                         =   -32767;
        end
        else begin
            assign  predict_out                         =   temp_result;
        end
    end

 endmodule

