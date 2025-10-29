`define keycode_1 8'h16
`define keycode_2 8'h1e
`define keycode_3 8'h26
`define keycode_4 8'h25
`define keycode_5 8'h2e
`define keycode_6 8'h36
`define keycode_7 8'h3d
`define keycode_8 8'h3e
`define keycode_9 8'h46
`define keycode_0 8'h45
`define keycode_minus 8'h4e
`define keycode_plus 8'h55

`define keycode_num_1 8'h69
`define keycode_num_2 8'h72
`define keycode_num_3 8'h7a
`define keycode_num_4 8'h6b
`define keycode_num_5 8'h73
`define keycode_num_6 8'h74
`define keycode_num_7 8'h6c
`define keycode_num_8 8'h75
`define keycode_num_9 8'h7d
`define keycode_num_0 8'h7c
`define keycode_num_enter 8'h5a


`define keycode_a 8'h1c
`define keycode_b 8'h32
`define keycode_c 8'h21
`define keycode_d 8'h23
`define keycode_e 8'h24
`define keycode_f 8'h2b
`define keycode_g 8'h34
`define keycode_h 8'h33
`define keycode_i 8'h43
`define keycode_j 8'h3b
`define keycode_k 8'h42
`define keycode_l 8'h4b
`define keycode_m 8'h3a
`define keycode_n 8'h31
`define keycode_o 8'h44
`define keycode_p 8'h4d
`define keycode_q 8'h15
`define keycode_r 8'h2d
`define keycode_s 8'h1b
`define keycode_t 8'h2c
`define keycode_u 8'h3c
`define keycode_v 8'h2a
`define keycode_w 8'h1d
`define keycode_x 8'h22
`define keycode_y 8'h35
`define keycode_z 8'h1a
`define keycode_semicolon 8'h4c
`define keycode_quote 8'h52
`define keycode_comma 8'h41
`define keycode_dot 8'h49


`define keycode_space 8'h29
`define keycode_enter 8'h5a
`define keycode_ctrl 8'h14
`define keycode_shift 8'h12
`define keycode_del 8'h66

`define keycode_f1 8'h05
`define keycode_f2 8'h06
`define keycode_f3 8'h04
`define keycode_f4 8'h0c
`define keycode_f5 8'h03
`define keycode_f6 8'h0b
`define keycode_f7 8'h83
`define keycode_f8 8'h0a
`define keycode_f9 8'h01
`define keycode_f10 8'h09
`define keycode_f11 8'h78
`define keycode_f12 8'h07

`define keycode_esc 8'h76
`define keycode_tab 8'h0d
`define keycode_caps 8'h58

`define keycode_up 8'h75
`define keycode_down 8'h72
`define keycode_left 8'h6b
`define keycode_right 8'h74


`define note_C 4'd1
`define note_Cs 4'd2
`define note_D 4'd3
`define note_Ds 4'd4
`define note_E 4'd5
`define note_F 4'd6
`define note_Fs 4'd7
`define note_G 4'd8
`define note_Gs 4'd9
`define note_A 4'd10
`define note_As 4'd11
`define note_B 4'd12


`define MAX_NOTES_NUM 16
module keycode_to_notes(
    input clk,
    input reset,
    input [15:0] keycode,
    input start,
    output reg [7:0] notes [0:`MAX_NOTES_NUM - 1],   // [6:4]: zone, [3:0]: semi-tone, [7]: reserved
                                                    // eg. D4: zone=4, semi-tone=3, notes=0100_0011
    output reg [4:0] note_num = 0
    );
    reg [1:0] note_map [2:7][1:12]; // [zone][semi-tone] 0: key-up, 1: key-down

    wire [7:0] keycode_h8;
    wire [7:0] keycode_l8;
    assign keycode_h8 = keycode[15:8];
    assign keycode_l8 = keycode[7:0];
    

    reg [3:0] chord_mark;

    reg [4:0] note_idx;
    always @(posedge clk) begin

        if (reset) begin
            for (int i = 2; i <= 7; i = i + 1) begin
                    for (int j = 1; j <= 12; j = j + 1) begin
                        note_map[i][j] = 0;
                    end
            end
        end else begin
            if (start) begin
                if (!(keycode_h8 == 8'hF0)) begin // key-down
                    case (keycode_l8)
                        // single
                        `keycode_a: note_map[4][1] = 1;
                        `keycode_w: note_map[4][2] = 1;
                        `keycode_s: note_map[4][3] = 1;
                        `keycode_e: note_map[4][4] = 1;
                        `keycode_d: note_map[4][5] = 1;
                        `keycode_f: note_map[4][6] = 1;
                        `keycode_t: note_map[4][7] = 1;
                        `keycode_g: note_map[4][8] = 1;
                        `keycode_y: note_map[4][9] = 1;
                        `keycode_h: note_map[4][10] = 1;
                        `keycode_u: note_map[4][11] = 1;
                        `keycode_j: note_map[4][12] = 1;
                        `keycode_k: note_map[5][1] = 1;
                        `keycode_o: note_map[5][2] = 1;
                        `keycode_l: note_map[5][3] = 1;
                        `keycode_p: note_map[5][4] = 1;
                        `keycode_semicolon: note_map[5][5] = 1;
                        `keycode_quote: note_map[5][6] = 1;

                        `keycode_1: note_map[5][1] = 1;
                        `keycode_2: note_map[5][3] = 1;
                        `keycode_3: note_map[5][5] = 1;
                        `keycode_4: note_map[5][6] = 1;
                        `keycode_5: note_map[5][8] = 1;
                        `keycode_6: note_map[5][10] = 1;
                        `keycode_7: note_map[5][12] = 1;
                        `keycode_8: note_map[6][1] = 1;
                        `keycode_9: note_map[6][3] = 1;
                        `keycode_0: note_map[6][5] = 1;

                        `keycode_z: note_map[3][1] = 1;
                        `keycode_x: note_map[3][3] = 1;
                        `keycode_c: note_map[3][5] = 1;
                        `keycode_v: note_map[3][6] = 1;
                        `keycode_b: note_map[3][8] = 1;
                        `keycode_n: note_map[3][10] = 1;
                        `keycode_m: note_map[3][12] = 1;
                        `keycode_comma: note_map[4][1] = 1;
                        `keycode_dot: note_map[4][3] = 1;

                        // chords
                        `keycode_num_1: chord_mark = 1;
                        `keycode_num_2: chord_mark = 2;
                        `keycode_num_3: chord_mark = 3;
                        `keycode_num_4: chord_mark = 4;
                        `keycode_num_5: chord_mark = 5;
                        `keycode_num_6: chord_mark = 6;
                        `keycode_num_7: chord_mark = 7;

                        default: ;
                    endcase
                end else begin
                    case (keycode_l8)
                        // single
                        `keycode_a: note_map[4][1] = 0;
                        `keycode_w: note_map[4][2] = 0;
                        `keycode_s: note_map[4][3] = 0;
                        `keycode_e: note_map[4][4] = 0;
                        `keycode_d: note_map[4][5] = 0;
                        `keycode_f: note_map[4][6] = 0;
                        `keycode_t: note_map[4][7] = 0;
                        `keycode_g: note_map[4][8] = 0;
                        `keycode_y: note_map[4][9] = 0;
                        `keycode_h: note_map[4][10] = 0;
                        `keycode_u: note_map[4][11] = 0;
                        `keycode_j: note_map[4][12] = 0;
                        `keycode_k: note_map[5][1] = 0;
                        `keycode_o: note_map[5][2] = 0;
                        `keycode_l: note_map[5][3] = 0;
                        `keycode_p: note_map[5][4] = 0;
                        `keycode_semicolon: note_map[5][5] = 0;
                        `keycode_quote: note_map[5][6] = 0;

                        `keycode_1: note_map[5][1] = 0;
                        `keycode_2: note_map[5][3] = 0;
                        `keycode_3: note_map[5][5] = 0;
                        `keycode_4: note_map[5][6] = 0;
                        `keycode_5: note_map[5][8] = 0;
                        `keycode_6: note_map[5][10] = 0;
                        `keycode_7: note_map[5][12] = 0;
                        `keycode_8: note_map[6][1] = 0;
                        `keycode_9: note_map[6][3] = 0;
                        `keycode_0: note_map[6][5] = 0;

                        `keycode_z: note_map[3][1] = 0;
                        `keycode_x: note_map[3][3] = 0;
                        `keycode_c: note_map[3][5] = 0;
                        `keycode_v: note_map[3][6] = 0;
                        `keycode_b: note_map[3][8] = 0;
                        `keycode_n: note_map[3][10] = 0;
                        `keycode_m: note_map[3][12] = 0;
                        `keycode_comma: note_map[4][1] = 0;
                        `keycode_dot: note_map[4][3] = 0;

                        // chords
                        `keycode_num_1: chord_mark = 0;
                        `keycode_num_2: chord_mark = 0;
                        `keycode_num_3: chord_mark = 0;
                        `keycode_num_4: chord_mark = 0;
                        `keycode_num_5: chord_mark = 0;
                        `keycode_num_6: chord_mark = 0;
                        `keycode_num_7: chord_mark = 0;
                        
                        default: ;
                    endcase
                end
                
            end
        end 
    end


    wire clk_slow;
    clock_generator #(
        .FREQUENCY_i(300),
        .FREQENCY_o(1)
    ) clock_generator (
        .clk_i(clk),
        .clk_o(clk_slow)
    );


    always @(posedge clk_slow) begin


        if (reset) begin

            for (int i = 0; i < `MAX_NOTES_NUM; i = i + 1) begin
                notes[i] = 0;
            end

        end else begin

                note_idx = 0;

                for (int i = 2; i <= 7; i = i + 1) begin //  zone
                    for (int j = 1; j <= 12; j = j + 1) begin //  semi-tone
                        if (note_map[i][j] > 0) begin
                            if (note_idx < 10) begin
                                notes[note_idx] = {1'b0, i[2:0], j[3:0]};
                                note_idx = note_idx + 1;
                            end
                        end
                    end
                end

                note_num = note_idx;

                if (note_idx < 10) begin
                    if (note_idx <= 9) notes[9] = 0;
                    if (note_idx <= 8) notes[8] = 0;
                    if (note_idx <= 7) notes[7] = 0;
                    if (note_idx <= 6) notes[6] = 0;
                    if (note_idx <= 5) notes[5] = 0;
                    if (note_idx <= 4) notes[4] = 0;
                    if (note_idx <= 3) notes[3] = 0;
                    if (note_idx <= 2) notes[2] = 0;
                    if (note_idx <= 1) notes[1] = 0;
                    if (note_idx <= 0) notes[0] = 0;
                end


                // chords
                case (chord_mark)
                    0: begin
                        notes[10] <= 0;
                        notes[11] <= 0;
                        notes[12] <= 0;
                        notes[13] <= 0;
                        notes[14] <= 0;
                        notes[15] <= 0;
                    end

                    1: begin
                        notes[10] <= {1'b0, 3'd3, `note_C};
                        notes[11] <= {1'b0, 3'd3, `note_G};
                        notes[12] <= {1'b0, 3'd4, `note_C};
                        notes[13] <= {1'b0, 3'd4, `note_E};
                        notes[14] <= 0;
                        notes[15] <= 0;
                    end

                    2: begin
                        notes[10] <= {1'b0, 3'd3, `note_D};
                        notes[11] <= {1'b0, 3'd3, `note_A};
                        notes[12] <= {1'b0, 3'd4, `note_D};
                        notes[13] <= {1'b0, 3'd4, `note_F};
                        notes[14] <= 0;
                        notes[15] <= 0;
                    end

                    3: begin
                        notes[10] <= {1'b0, 3'd3, `note_E};
                        notes[11] <= {1'b0, 3'd3, `note_G};
                        notes[12] <= {1'b0, 3'd3, `note_B};
                        notes[13] <= {1'b0, 3'd4, `note_E};
                        notes[14] <= 0;
                        notes[15] <= 0;
                    end

                    4: begin
                        notes[10] <= {1'b0, 3'd3, `note_F};
                        notes[11] <= {1'b0, 3'd3, `note_A};
                        notes[12] <= {1'b0, 3'd4, `note_C};
                        notes[13] <= {1'b0, 3'd4, `note_F};
                        notes[14] <= 0;
                        notes[15] <= 0;
                    end

                    5: begin
                        notes[10] <= {1'b0, 3'd3, `note_G};
                        notes[11] <= {1'b0, 3'd3, `note_B};
                        notes[12] <= {1'b0, 3'd4, `note_D};
                        notes[13] <= {1'b0, 3'd4, `note_G};
                        notes[14] <= 0;
                        notes[15] <= {1'b0, 2'd2, `note_G};
                    end

                    6: begin
                        notes[10] <= {1'b0, 3'd3, `note_A};
                        notes[11] <= {1'b0, 3'd3, `note_C};
                        notes[12] <= {1'b0, 3'd4, `note_E};
                        notes[13] <= 0;
                        notes[14] <= 0;
                        notes[15] <= 0;
                    end

                    7: begin
                        notes[10] <= {1'b0, 3'd3, `note_B};
                        notes[11] <= {1'b0, 3'd3, `note_D};
                        notes[12] <= {1'b0, 3'd4, `note_F};
                        notes[13] <= 0;
                        notes[14] <= 0;
                        notes[15] <= 0;
                    end

                    default: ;
                endcase


        end
    end


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