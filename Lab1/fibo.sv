module fibonacci_calculator
(
    input  logic                                clk , 
    input  logic                                reset,

    input  logic    [4:0]                       input_s, 
    input  logic                                begin_fibo, 

    output logic    [15:0]                      fibo_out,
    output logic                                done
);

    typedef enum logic [1:0] {IDLE=2'b0, COMPUTE=2'b01, OUTPUT=2'b10}    state;

    state                                   current_state, next_state;

    always_ff @(posedge clk) begin
        if (reset) begin
            current_state                   <=  IDLE;
        end
        else begin
            current_state                   <=  next_state;
        end
    end

    logic   [4:0]                           counter;
    logic   [4:0]                           store_s;

    always_comb begin
        case (current_state)
            IDLE: begin
                if (begin_fibo) begin
                    next_state              =   COMPUTE;
                end
                else begin
                    next_state              =   IDLE;
                end
            end
            COMPUTE: begin
                if (counter == store_s) begin
                    next_state              =   IDLE;
                end
                else begin
                    next_state              =   COMPUTE;
                end
            end
            OUTPUT: begin
                if (begin_fibo) begin
                    next_state              =   COMPUTE;
                end
                else begin
                    next_state              =   IDLE;
                end
            end
            default: begin
                next_state                  =   IDLE;
            end
        endcase
    end

    logic   [15:0]                          temp_1;
    logic   [15:0]                          temp_2;

    always_ff @(posedge clk) begin
        if (reset) begin
            temp_1                          <=  1;
            temp_2                          <=  1;

            counter                         <=  0;
            store_s                         <=  0;

            fibo_out                        <=  0;
            done                            <=  0;
        end
        else begin
            case (next_state)
                IDLE: begin
                    temp_1                  <=  1;
                    temp_2                  <=  1;

                    counter                 <=  0;

                    done                    <=  0;
                end
                COMPUTE: begin
                    temp_1                  <=  temp_2;
                    temp_2                  <=  temp_1 + temp_2;

                    counter                 <=  counter + 1;
                    if (begin_fibo) begin
                        store_s             <=  input_s;
                    end

                    done                    <=  0;
                end
                OUTPUT: begin
                    temp_1                  <=  1;
                    temp_2                  <=  1;

                    counter                 <=  0;
                    
                    fibo_out                <=  temp_2;
                    done                    <=  1;
                end
                default: begin
                    temp_1                  <=  1;
                    temp_2                  <=  1;

                    counter                 <=  0;
                    store_s                 <=  0;

                    fibo_out                <=  0;
                    done                    <=  0;
                end
            endcase
        end
    end


endmodule
