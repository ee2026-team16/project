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


module whoWinner(input clk, game_stop, input [7:0] ledPointsB4Stop, oledPointsB4Stop, otherPoints, 
        output reg isWinner, reg hasProcessedWinner = 0, output reg [7:0] myPoints, output [15:0] led); //testing
    parameter I_WIN = 1;
    parameter I_LOSE = 0;
    
    
    // testing
//    assign led[15] = game_stop;
//    assign led[14:8] = otherPoints;
//    assign led[7:0] = myPoints;
    
    always @ (posedge clk) begin // myPoints always updated
        myPoints = ledPointsB4Stop + oledPointsB4Stop; // default 1 + 1
        
    end
    
    always @ (posedge clk) begin // only when RX otherPoints
//        has_RX_DV = 1;
//        led[15] <= has_RX_DV ? 1 : 0;
//        led[14:8] <= otherPoints;
//        led[7:0] <= myPoints;
        isWinner <= (otherPoints > myPoints) ? I_LOSE : I_WIN;
        hasProcessedWinner <= game_stop ? 1 : 0;
    end
//    always @ (negedge game_stop) begin
//        hasProcessedWinner <= 0;
//    end
    
//    assign points = hasProcessedWinner ? 0 : points;
//    assign total_points = hasProcessedWinner ? 0 : total_points;
    
endmodule
