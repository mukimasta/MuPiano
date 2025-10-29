
`define MAX_NOTES_NUM 16
module notes_to_Hz(
    input [7:0] notes [0:`MAX_NOTES_NUM - 1],    // [6:4]: zone, [3:0]: semi-tone, [7]: reserved
                                              // eg. D4: zone=4, semi-tone=3, notes=0100_0011
    output reg [15:0] Hz [0:`MAX_NOTES_NUM - 1]
    );

    always @(*) begin

        for (int i = 0; i < `MAX_NOTES_NUM; i = i + 1) begin
            case (notes[i])
                // Zone 2
                8'h21: Hz[i] = 16'd65; // C2
                8'h22: Hz[i] = 16'd69; // C#2
                8'h23: Hz[i] = 16'd73; // D2
                8'h24: Hz[i] = 16'd78; // D#2
                8'h25: Hz[i] = 16'd82; // E2
                8'h26: Hz[i] = 16'd87; // F2
                8'h27: Hz[i] = 16'd92; // F#2
                8'h28: Hz[i] = 16'd98; // G2
                8'h29: Hz[i] = 16'd104; // G#2
                8'h2a: Hz[i] = 16'd110; // A2
                8'h2b: Hz[i] = 16'd117; // A#2
                8'h2c: Hz[i] = 16'd123; // B2

                // Zone 3
                8'h31: Hz[i] = 16'd131; // C3
                8'h32: Hz[i] = 16'd139; // C#3
                8'h33: Hz[i] = 16'd147; // D3
                8'h34: Hz[i] = 16'd156; // D#3
                8'h35: Hz[i] = 16'd165; // E3
                8'h36: Hz[i] = 16'd175; // F3
                8'h37: Hz[i] = 16'd185; // F#3
                8'h38: Hz[i] = 16'd196; // G3
                8'h39: Hz[i] = 16'd208; // G#3
                8'h3a: Hz[i] = 16'd220; // A3
                8'h3b: Hz[i] = 16'd233; // A#3
                8'h3c: Hz[i] = 16'd247; // B3

                // Zone 4
                8'h41: Hz[i] = 16'd262; // C4
                8'h42: Hz[i] = 16'd277; // C#4
                8'h43: Hz[i] = 16'd294; // D4
                8'h44: Hz[i] = 16'd311; // D#4
                8'h45: Hz[i] = 16'd330; // E4
                8'h46: Hz[i] = 16'd349; // F4
                8'h47: Hz[i] = 16'd370; // F#4
                8'h48: Hz[i] = 16'd392; // G4
                8'h49: Hz[i] = 16'd415; // G#4
                8'h4a: Hz[i] = 16'd440; // A4
                8'h4b: Hz[i] = 16'd466; // A#4
                8'h4c: Hz[i] = 16'd494; // B4

                // Zone 5
                8'h51: Hz[i] = 16'd523; // C5
                8'h52: Hz[i] = 16'd554; // C#5
                8'h53: Hz[i] = 16'd587; // D5
                8'h54: Hz[i] = 16'd622; // D#5
                8'h55: Hz[i] = 16'd659; // E5
                8'h56: Hz[i] = 16'd698; // F5
                8'h57: Hz[i] = 16'd740; // F#5
                8'h58: Hz[i] = 16'd784; // G5
                8'h59: Hz[i] = 16'd831; // G#5
                8'h5a: Hz[i] = 16'd880; // A5
                8'h5b: Hz[i] = 16'd932; // A#5
                8'h5c: Hz[i] = 16'd988; // B5

                // Zone 6
                8'h61: Hz[i] = 16'd1047; // C6
                8'h62: Hz[i] = 16'd1109; // C#6
                8'h63: Hz[i] = 16'd1175; // D6
                8'h64: Hz[i] = 16'd1245; // D#6
                8'h65: Hz[i] = 16'd1319; // E6
                8'h66: Hz[i] = 16'd1397; // F6
                8'h67: Hz[i] = 16'd1480; // F#6
                8'h68: Hz[i] = 16'd1568; // G6
                8'h69: Hz[i] = 16'd1661; // G#6
                8'h6a: Hz[i] = 16'd1760; // A6
                8'h6b: Hz[i] = 16'd1865; // A#6
                8'h6c: Hz[i] = 16'd1976; // B6

                // Zone 7
                8'h71: Hz[i] = 16'd2093; // C7
                8'h72: Hz[i] = 16'd2218; // C#7
                8'h73: Hz[i] = 16'd2349; // D7
                8'h74: Hz[i] = 16'd2489; // D#7
                8'h75: Hz[i] = 16'd2637; // E7
                8'h76: Hz[i] = 16'd2794; // F7
                8'h77: Hz[i] = 16'd2960; // F#7
                8'h78: Hz[i] = 16'd3136; // G7
                8'h79: Hz[i] = 16'd3322; // G#7
                8'h7a: Hz[i] = 16'd3520; // A7
                8'h7b: Hz[i] = 16'd3729; // A#7
                8'h7c: Hz[i] = 16'd3951; // B7

                

                default: Hz[i] = 16'd0;
            endcase
        end
    end
endmodule
