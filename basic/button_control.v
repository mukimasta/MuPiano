
module button_control (
    input clk,
    input [4:0] btn,
    output [4:0] btn_single_pulse
);

    clock_generator #(
        .FREQUENCY_i(100000000), // 100MHz
        .FREQENCY_o(15) // Hz
    ) clock_generator (
        .clk_i(clk),
        .clk_o(clk_15)
    );
    
    button_detector button_detector (
        .clk(clk_15),
        .btn(btn),
        .btn_single_pulse(btn_single_pulse)
    );

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

    always @(posedge clk_i) begin
        if (cnt == DIV_FACTOR - 1) begin
            clk_o <= ~clk_o;
            cnt <= 0;
        end else begin
            cnt <= cnt + 1;
        end
    end
    
endmodule


module button_detector (
    input clk, // 15 Hz
    input [4:0] btn, // buttons C, U, L, R, D
    output reg [4:0] btn_single_pulse
);

    reg [4:0] btn_last_state = 5'b00000;

    always @(posedge clk) begin
        btn_single_pulse <= btn & ~btn_last_state;
        btn_last_state <= btn;
    end

    
endmodule