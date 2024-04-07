`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.04.2024 12:31:53
// Design Name: 
// Module Name: isWinner
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


module whoWinner(input clk, game_stop, input [7:0] total_points, otherPoints, 
        output reg isWinner, reg hasProcessedWinner = 0, output reg [7:0] myPoints, output [15:0] led); //testing
    parameter I_WIN = 1;
    parameter I_LOSE = 0;
    parameter THREE_SEC = 28'hFFF_FFFF;
    
    reg [27:0] delay = 0; // delay 1 clk cycle // CHANGE
    reg start_delay = 0;
    always @ (posedge clk) begin // myPoints always updated
        if (start_delay == 1) begin   // CHANGE
            delay <= delay + 1;
        end 
        if (delay == THREE_SEC) begin
            delay <= 0;         // reset delay
            start_delay <= 0;   // reset start_delay
        end
        if (game_stop == 1) begin   // CHANGE
            start_delay <= 1;
        end    
        
        myPoints <= total_points; 
        isWinner <= (otherPoints > myPoints) ? I_LOSE : I_WIN;
        hasProcessedWinner <= (delay == THREE_SEC) ? 1 : 0; // resets points // TopStudentFSM game_stop also change
    end

    
endmodule
