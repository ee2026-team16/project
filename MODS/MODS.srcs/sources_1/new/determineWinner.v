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
    
    
    // testing
//    assign led[15] = game_stop;
//    assign led[14:8] = otherPoints;
//    assign led[7:0] = myPoints;
    
    always @ (posedge clk) begin // myPoints always updated
        // immediate assignment
        myPoints <= total_points; // default 1 + 1
        isWinner <= (otherPoints > myPoints) ? I_LOSE : I_WIN;
        // delayed assignment
        hasProcessedWinner <= game_stop ? 1 : 0;
    end

    
endmodule
