module music(
    input [4:0] volume,
	input clk,
    output o_audio,
    output gain,
    output shutdown
);

reg [30:0] tone;
always @(posedge clk) 
begin
    tone <= tone+31'd1;
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
reg [8:0] counter_note;
reg [7:0] counter_octave;
always @(posedge clk) 
begin
    counter_note <= counter_note==0 ? clkdivider : counter_note-9'd1;
    if(counter_note==0) 
    begin
        counter_octave <= counter_octave==0 ? 8'd255 >> octave : counter_octave-8'd1;
    end
    if(counter_note==0 && counter_octave==0 && fullnote!=0 && tone[21:18]!=0) 
    begin
        speaker <= ~speaker;
    end  
    case(volume)
    1: speaker_time =  counter_note[7:0];
    2: speaker_time =  counter_note[6:0];
    3: speaker_time =  counter_note[5:0];
    4: speaker_time =  counter_note[4:0];
    5: speaker_time =  counter_note[3:0];
    6: speaker_time =  counter_note[2:0];
    7: speaker_time =  counter_note[1:0];
    8: speaker_time = counter_note[0];
    9: speaker_time = 0;
    default: speaker_time =  counter_note;
    endcase 
end
endmodule
