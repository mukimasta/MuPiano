`include "i2s_clock_gen.v"


`define MAX_NOTES_NUM 16


module i2s_top (
    input clk,
    input reset,
    input [4:0] note_num, // deprecated
    input [15:0] Hz [0:`MAX_NOTES_NUM - 1],
    input [1:0] tone_select,
    // // test
    // input [15:0] sw,
    // output [15:0] led,
    // // test



    output sck,
    output bck,
    output reg din,
    output reg lrck
);

    // //test
    // assign led = sw;
    // //

    assign sck = 0; // I2S PLL mode



    i2s_clock_gen i2s_clock_gen (
        .clk(clk),
        .reset(reset),
        .bck(bck)
    );

    reg [15:0] rom_sine [0:1023];
    reg [15:0] rom_triangle [0:1023];
    reg [15:0] rom_square [0:1023];
    
    initial begin
        $readmemh("sine_wave_1024.mem", rom_sine);
        $readmemh("triangle_wave_1024.mem", rom_triangle);
        $readmemh("square_wave_1024.mem", rom_square);
    end

    reg [63:0] phase_acc[0:`MAX_NOTES_NUM - 1];
    wire [63:0] phase_step [0:`MAX_NOTES_NUM - 1];
    wire [9:0] address [0:`MAX_NOTES_NUM - 1];
    wire signed [15:0] data [0:15];

    generate
        genvar i;
        for (i = 0; i < 16; i = i + 1) begin
            assign phase_step[i] = Hz[i] ? (Hz[i] * 33'h10000_0000) / 44100 : 0;
            assign address[i] = phase_acc[i][31:22];
            assign data[i] = Hz[i]  ?
                                        tone_select[1] ? rom_triangle[address[i]]
                                        : tone_select[0] ? rom_square[address[i]]
                                        : rom_sine[address[i]]
                                    : 0;
        end
    endgenerate

    reg [15:0] wave;

    reg [4:0] cnt = 0; // for 32 cycles of bck
    always @(negedge bck) begin
        if (reset) begin
            lrck <= 0;
            cnt <= 0;
            for (int i = 0; i < 16; i = i + 1) begin
                phase_acc[i] <= 0;
            end

        end else begin
            case (cnt)
                31: begin
                    lrck <= 1; // left
                    
                    wave <= data[0] + data[1] + data[2] + data[3] + data[4] + data[5] + data[6] + data[7] + data[8] + data[9] + ((data[10] + data[11] + data[12] + data[13] + data[14] + data[15]) >>> 2);
                    
                end
                15: begin
                    lrck <= 0; // right
                    
                    for (int i = 0; i < 16; i = i + 1) begin
                        phase_acc[i] <= phase_acc[i] + phase_step[i];
                    end

                    
                end
                default: ;
            endcase

            din = wave[ (15 - (cnt % 16)) ];

            cnt = cnt + 1;
        end
    end






    // wire [15:0] Hz0 = Hz[0];
    // wire [15:0] Hz1 = Hz[1];
    // wire [15:0] data0 = data[0];
    // wire [15:0] data1 = data[1];

endmodule
