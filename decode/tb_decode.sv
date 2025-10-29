// my testbench template
`timescale 1ps/1ps
`include "keycode_to_notes.sv"

module tb_decode;

    /* iverilog */
    initial begin
        $dumpfile("tb_decode.vcd");
        $dumpvars(0, tb_decode);
    end

    reg reset;
    reg start = 1;
    reg [15:0] keycode;
    wire [7:0] notes [0:`MAX_NOTES_NUM - 1];
    wire [4:0] note_num;


    keycode_to_notes keycode_to_notes(
        .clk(clk),
        .start(start),
        .reset(reset),
        .keycode(keycode),
        .notes(notes),
        .note_num(note_num)
    );


    initial begin
        reset=1; #10
        reset=0;
    end

    //clk
    reg clk = 0;
    always #1 clk = ~clk;


    initial begin
        #15
        keycode = {8'h00, `keycode_a}; #2000;
        keycode = {8'hf0, `keycode_a}; #2000;
        keycode = {8'h00, `keycode_w}; #2000;
        keycode = {8'hf0, `keycode_w}; #2000;

        keycode = {8'h00, `keycode_s}; #2000;
        keycode = {8'h00, `keycode_e}; #2000;
        keycode = {8'hf0, `keycode_s}; #2000;
        keycode = {8'hf0, `keycode_e}; #2000;

        end

    wire [7:0] note0 = notes[0];
    wire [7:0] note1 = notes[1];
    wire [7:0] note2 = notes[2];
    wire [7:0] note3 = notes[3];
    wire [7:0] note4 = notes[4];

    wire C4_d = keycode_to_notes.note_map[4][1];
    wire C4s_d = keycode_to_notes.note_map[4][2];
    wire D4_d = keycode_to_notes.note_map[4][3];


    initial begin
        #30000 $finish;
    end
    
endmodule
