module i2s_clock_gen (
    input clk,
    input reset,
    output bck
);

    clock_generator #(
        .FREQUENCY_i(100000000), // 100MHz
        .FREQENCY_o(1411200) // 16 bit audio depth
    ) bck_generator (
        .clk_i(clk),
        .clk_o(bck)
    );

    // clock_generator #(
    //     .FREQUENCY_i(32), // 100MHz
    //     .FREQENCY_o(1) // 16 bit audio depth
    // ) lrck_generator (
    //     .clk_i(bck),
    //     .clk_o(lrck)
    // );


endmodule


module clock_generator #(
    parameter real FREQUENCY_i = 100000000, // 1MHz
    parameter real FREQENCY_o = 1 // Hz
) (
    input clk_i,
    output reg clk_o = 0
);

    localparam integer DIV_FACTOR = FREQUENCY_i / (2 * FREQENCY_o);
    reg [$clog2(DIV_FACTOR):0] cnt = 0;

    always @(negedge clk_i) begin
        if (cnt == DIV_FACTOR - 1) begin
            clk_o <= ~clk_o;
            cnt <= 0;
        end else begin
            cnt <= cnt + 1;
        end
    end
    
endmodule