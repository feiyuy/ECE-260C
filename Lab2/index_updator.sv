
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 /*
This module updates the index based on index table and the input code.

 Feiyu Yang
 4/26/2022
 */
 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module index_updator
(
    input   logic                                               clk,
    input   logic                                               rst,
    
    input   logic   [7:0]                                       index_in,
    input   logic   signed  [3:0]                               code_in,

    output  logic   [7:0]                                       index_out
);

    //Update index based on the code
    logic   [7:0]                                          index_table      [15:0];

    initial begin
        $readmemh("IndexTable.mem", index_table);
    end

    logic   signed  [8:0]                                   temp_index;

    always_ff @(posedge clk) begin
        if (rst) begin
            temp_index                                  <=  0;
        end
        else begin
            temp_index                                  <=  $signed({1'b0,index_in}) + $signed(index_table[$unsigned(code_in)]);
        end
    end

    //Bound index
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
    end

endmodule