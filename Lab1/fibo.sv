module fibonacci_calculator
(
    input  logic                                clk , 
    input  logic                                reset,

    input  logic    [4:0]                       input_s, 
    input  logic                                begin_fibo, 

    output logic    [27:0]                      fibo_out,
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
                    next_state              =   OUTPUT;
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

    logic   [27:0]                          temp    [1:0];

    always_ff @(posedge clk) begin
        if (reset) begin
            temp[0]                         <=  0;
            temp[1]                         <=  1;

            counter                         <=  0;
            store_s                         <=  0;

            fibo_out                        <=  0;
            done                            <=  0;
        end
        else begin
            case (next_state)
                IDLE: begin
                    temp[0]                 <=  0;
                    temp[1]                 <=  1;

                    counter                 <=  0;

                    done                    <=  0;
                end
                COMPUTE: begin
                    temp[0]                 <=  temp[1];
                    temp[1]                 <=  temp[0] + temp[1];

                    counter                 <=  counter + 1;
                    if (begin_fibo) begin
                        store_s             <=  input_s;
                    end

                    done                    <=  0;
                end
                OUTPUT: begin
                    temp[0]                 <=  0;
                    temp[1]                 <=  1;

                    counter                 <=  0;
                    
                    fibo_out                <=  temp[0];
                    done                    <=  1;
                end
                default: begin
                    temp[0]                 <=  0;
                    temp[1]                 <=  1;

                    counter                 <=  0;
                    store_s                 <=  0;

                    fibo_out                <=  0;
                    done                    <=  0;
                end
            endcase
        end
    end


endmodule
