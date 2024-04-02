`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/28/2024 08:35:52 AM
// Design Name: 
// Module Name: Music_player
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Music_player(
    input [4:0] volume,
    input start,
    input clk,
    output o_audio,
    output gain,
    output shutdown
    );
    parameter clkdivider = 25000000/440/2;
    
    reg [23:0] tone;
    reg [14:0] counter;
    reg speaker;
    reg stopped = 0;
    reg [14:0] speaker_time;
    
    assign shutdown = 1;
    assign gain = 1;
    
    assign o_audio = speaker & (speaker_time== 0); //reduce time that speaker is turned on
    always @(posedge clk) // set tone to 1.5Hz
    begin
        if(start == 1)
        begin
            tone <= tone+1;          
            if(counter==0) 
            begin
                counter <= (tone[23] ? clkdivider-1 : clkdivider/2-1);
                speaker = ~speaker;
            end
            else 
            begin 
                counter <= counter + 1;
            end
            case(volume)
            1: speaker_time = counter[7:0];
            2: speaker_time = counter[6:0];
            3: speaker_time = counter[5:0];
            4: speaker_time = counter[4:0];
            5: speaker_time = counter[3:0];
            6: speaker_time = counter[2:0];
            7: speaker_time = counter[1:0];
            8: speaker_time = counter[0];
            9: speaker_time = 0;
            default: speaker_time = counter;
            endcase
        end
    end
    

endmodule
