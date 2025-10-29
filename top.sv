/* ==========================================================
 * NUSRI FPGA Course Final Project
 * Project Name: Mini Musical Instruments
 * File Name: top.v
 * Author: Xue Hanlin U2401161, Guan Qiyu
 * Date: 2024-12-28
 * Version: 1.0
 * 
 * Board: Basys3 Artix-7 FPGA Board
 * Peripherals: USB Keyboard, I2S DAC, 3.5mm Speaker or earphones
 * ==========================================================
 */

`define MAX_NOTES_NUM 16
`define SEG_0 8'b11000000
`define SEG_1 8'b11111001
`define SEG_2 8'b10100100
`define SEG_3 8'b10110000
`define SEG_4 8'b10011001
`define SEG_5 8'b10010010
`define SEG_6 8'b10000010
`define SEG_7 8'b11111000
`define SEG_8 8'b10000000
`define SEG_9 8'b10010000

`include "basic/button_control.v"
`include "keyboard/keyboard_top.v"
`include "decode/keycode_to_notes.sv"
`include "decode/notes_to_Hz.sv"
`include "i2s/i2s_top.sv"

module top (
    // Basic
    input clk,
    // input reset,    // connect to btnC
    input [15:0] sw,
    input [4:0] btn, // buttons C, U, L, R, D
    output [15:0] led,
    // output [3:0] an,
    // output [7:0] seg

    // Keyboard
    input PS2Data,
    input PS2Clk,
    output tx,      // connect to USB-UART tx, use serial port tools to monitor keyboard input

    // I2S output
    output sck,
    output bck,
    output din,
    output lrck
);

    wire reset;
    wire [1:0] tone_select;

    assign tone_select = sw[1:0];

    // button control
    wire [4:0] btn_single_pulse;
    button_control button_control(
        .clk(clk),
        .btn(btn),
        .btn_single_pulse(btn_single_pulse)
    );
    assign reset = btn_single_pulse[0];



    // Keyboard
    wire [15:0] keycode;
    keyboard_top keyboard_top (
        .clk(clk),
        .PS2Data(PS2Data),
        .PS2Clk(PS2Clk),
        .keycodev(keycode),
        .start(start),
        .tx(tx)
    );
    assign led = keycode;

    // keycode -> notes -> Hz
    wire [7:0] notes [0:`MAX_NOTES_NUM - 1];    // [6:4]: zone, [3:0]: semi-tone, [7]: reserved
                                                // eg. D4: zone=4, semi-tone=3, notes=0100_0011
    wire [4:0] note_num;
    wire [15:0] Hz [0:`MAX_NOTES_NUM - 1];      // Hz range: 0-65535
    
    keycode_to_notes keycode_to_notes (
        .clk(clk),
        .reset(reset),
        .keycode(keycode),
        .start(start),
        .notes(notes),
        .note_num(note_num)
    );

    notes_to_Hz notes_to_Hz (
        .notes(notes),
        .Hz(Hz)
    );

    // I2S output
    i2s_top i2s_top (
        .clk(clk),
        .reset(reset),
        .note_num(note_num),
        .Hz(Hz),
        .tone_select(tone_select),
        .sck(sck),
        .bck(bck),
        .din(din),
        .lrck(lrck)
    );
    
endmodule


