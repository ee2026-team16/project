// Music demo verilog file
// (c) fpga4fun.com 2003-2015

// Plays a little tune on a speaker
// Use a 25MHz clock if possible (other frequencies will 
// change the pitch/speed of the song)

/////////////////////////////////////////////////////
module music(
    input [4:0] volume,
    input defuse,
	input clk,
    output o_audio,
    output gain,
    output shutdown
);

reg [30:0] tone;
reg [23:0] tone_siren;
always @(posedge clk) 
begin
    if(defuse == 1)
    begin
        tone <= tone+31'd1;
        tone_siren = 0;
    end
    else
    begin
        tone_siren <= tone_siren + 1;
        tone = 0;
    end
end

reg [14:0] speaker_time;

wire [7:0] fullnote;
music_ROM get_fullnote(.clk(clk), .address(tone[29:22]), .note(fullnote));

wire [2:0] octave;
wire [3:0] note;
divide_by12 get_octave_and_note(.numerator(fullnote[5:0]), .quotient(octave), .remainder(note));

reg [8:0] clkdivider;
reg speaker;

assign shutdown = 1;
assign gain = 1;
assign o_audio = speaker & (speaker_time== 0); //reduce time that speaker is turned on


always @*
case(note)
	 0: clkdivider = 9'd511;//A
	 1: clkdivider = 9'd482;// A#/Bb
	 2: clkdivider = 9'd455;//B
	 3: clkdivider = 9'd430;//C
	 4: clkdivider = 9'd405;// C#/Db
	 5: clkdivider = 9'd383;//D
	 6: clkdivider = 9'd361;// D#/Eb
	 7: clkdivider = 9'd341;//E
	 8: clkdivider = 9'd322;//F
	 9: clkdivider = 9'd303;// F#/Gb
	10: clkdivider = 9'd286;//G
	11: clkdivider = 9'd270;// G#/Ab
	default: clkdivider = 9'd0;
endcase
reg [14:0] counter_siren;
reg [8:0] counter_note;
reg [7:0] counter_octave;
always @(posedge clk) 
begin
    if(defuse == 1)
    begin
        counter_siren = 0;
        counter_note <= counter_note==0 ? clkdivider : counter_note-9'd1;
        if(counter_note==0) 
        begin
            counter_octave <= counter_octave==0 ? 8'd255 >> octave : counter_octave-8'd1;
        end
        if(counter_note==0 && counter_octave==0 && fullnote!=0 && tone[21:18]!=0) 
        begin
            speaker <= ~speaker;
        end
    end
    else
    begin         
        counter_note = 0;
        if(counter_siren==0) 
            begin
                counter_siren <= (tone_siren[23] ? 28409 : 14204);
                speaker = ~speaker;
            end
        else 
            begin 
                counter_siren <= counter_siren + 1;
            end    
    end
    
    case(volume)
    1: speaker_time = (defuse == 1) ? counter_note[7:0]: counter_siren[7:0];
    2: speaker_time = (defuse == 1) ? counter_note[6:0]: counter_siren[6:0];
    3: speaker_time = (defuse == 1) ? counter_note[5:0]: counter_siren[5:0];
    4: speaker_time = (defuse == 1) ? counter_note[4:0]: counter_siren[4:0];
    5: speaker_time = (defuse == 1) ? counter_note[3:0]: counter_siren[3:0];
    6: speaker_time = (defuse == 1) ? counter_note[2:0]: counter_siren[2:0];
    7: speaker_time = (defuse == 1) ? counter_note[1:0]: counter_siren[1:0];
    8: speaker_time = (defuse == 1) ? counter_note[0]: counter_siren[0];
    9: speaker_time = 0;
    default: speaker_time = (defuse == 1) ? counter_note: counter_siren;
    endcase 
end
endmodule
