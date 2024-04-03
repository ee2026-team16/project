`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.04.2024 14:53:16
// Design Name: 
// Module Name: point_display
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


module point_display(input clk_25MHz, input [31:0] total_points, input [12:0] pixel_index, output reg [15:0] oled_data);
    parameter BLACK = 16'b00000_000000_00000;
    parameter WHITE = 16'b11111_111111_11111;
    parameter YELLOW = 16'b11111_111111_00000;
    parameter background_green = 16'b00110_110001_00110;
    reg [31:0] x, y;
    
    //returns 1 if the pixel indexed is associated with a specific digit of the points
    function digit;
        input [31:0] value;
        input [31:0] curr_x;
        input [31:0] curr_y;
        input [31:0] origin_x;
        input [31:0] origin_y;
        reg [31:0] x, y;
        begin
            x = curr_x - origin_x;
            y = curr_y - origin_y;
            if (value == 0 &&
            ((x == 1 && y == 0) || 
            (x == 0 && y == 1) || 
            (x == 2 && y == 1) || 
            (x == 0 && y == 2) || 
            (x == 2 && y == 2) || 
            (x == 0 && y == 3) || 
            (x == 2 && y == 3) || 
            (x == 1 && y == 4))) begin
                digit = 1;
            end
            else if (value == 1 &&
            ((x == 1 && y == 0) || 
            (x == 0 && y == 1) || 
            (x == 1 && y == 1) || 
            (x == 1 && y == 2) || 
            (x == 1 && y == 3) || 
            (x == 0 && y == 4) || 
            (x == 1 && y == 4) || 
            (x == 2 && y == 4))) begin
                digit = 1;
            end 
            else if (value == 2 &&
            ((x == 0 && y == 0) || 
            (x == 1 && y == 0) || 
            (x == 2 && y == 0) || 
            (x == 2 && y == 1) || 
            (x == 0 && y == 2) || 
            (x == 1 && y == 2) || 
            (x == 2 && y == 2) || 
            (x == 0 && y == 3) || 
            (x == 0 && y == 4) || 
            (x == 1 && y == 4) || 
            (x == 2 && y == 4))) begin
                digit = 1;
            end
            else if (value == 3 &&
            ((x == 0 && y == 0) || 
            (x == 1 && y == 0) || 
            (x == 2 && y == 0) || 
            (x == 2 && y == 1) || 
            (x == 0 && y == 2) || 
            (x == 1 && y == 2) || 
            (x == 2 && y == 2) || 
            (x == 2 && y == 3) || 
            (x == 0 && y == 4) || 
            (x == 1 && y == 4) || 
            (x == 2 && y == 4))) begin
                digit = 1;
            end
            else if (value == 4 && 
            ((x == 0 && y == 0) || 
            (x == 2 && y == 0) || 
            (x == 0 && y == 1) || 
            (x == 2 && y == 1) || 
            (x == 0 && y == 2) || 
            (x == 1 && y == 2) || 
            (x == 2 && y == 2) || 
            (x == 2 && y == 3) || 
            (x == 2 && y == 4))) begin
                digit = 1;
            end  
            else if (value == 5 && 
            ((x == 0 && y == 0) || 
            (x == 1 && y == 0) || 
            (x == 2 && y == 0) || 
            (x == 0 && y == 1) || 
            (x == 0 && y == 2) || 
            (x == 1 && y == 2) || 
            (x == 2 && y == 2) || 
            (x == 2 && y == 3) || 
            (x == 0 && y == 4) || 
            (x == 1 && y == 4) || 
            (x == 2 && y == 4))) begin
               digit = 1;
            end
            else if (value == 6 && 
            ((x == 0 && y == 0) || 
            (x == 1 && y == 0) || 
            (x == 2 && y == 0) || 
            (x == 0 && y == 1) || 
            (x == 0 && y == 2) || 
            (x == 1 && y == 2) || 
            (x == 2 && y == 2) || 
            (x == 0 && y == 3) || 
            (x == 2 && y == 3) || 
            (x == 0 && y == 4) || 
            (x == 1 && y == 4) || 
            (x == 2 && y == 4))) begin
                digit = 1;
            end
            else if (value == 7 && 
            ((x == 0 && y == 0) || 
            (x == 1 && y == 0) || 
            (x == 2 && y == 0) || 
            (x == 2 && y == 1) || 
            (x == 2 && y == 2) || 
            (x == 2 && y == 3) || 
            (x == 2 && y == 4))) begin
                digit = 1;
            end
            else if (value == 8 && 
            ((x == 0 && y == 0) || 
            (x == 1 && y == 0) || 
            (x == 2 && y == 0) || 
            (x == 0 && y == 1) || 
            (x == 2 && y == 1) || 
            (x == 0 && y == 2) || 
            (x == 1 && y == 2) || 
            (x == 2 && y == 2) || 
            (x == 0 && y == 3) || 
            (x == 2 && y == 3) || 
            (x == 0 && y == 4) || 
            (x == 1 && y == 4) || 
            (x == 2 && y == 4))) begin
                digit = 1;
            end
            else if (value == 9 && 
            ((x == 0 && y == 0) || 
            (x == 1 && y == 0) || 
            (x == 2 && y == 0) || 
            (x == 0 && y == 1) || 
            (x == 2 && y == 1) || 
            (x == 0 && y == 2) || 
            (x == 1 && y == 2) || 
            (x == 2 && y == 2) || 
            (x == 2 && y == 3) || 
            (x == 0 && y == 4) || 
            (x == 1 && y == 4) || 
            (x == 2 && y == 4))) begin
                digit = 1;
            end
            else begin
                digit = 0;
            end
             
        end  
    endfunction
    
    function points_word;
        input [31:0] curr_x;
        input [31:0] curr_y;
        input [31:0] origin_x;
        input [31:0] origin_y;
        reg [31:0] x, y;
        begin
            x = curr_x - origin_x;
            y = curr_y - origin_y;
            if ((x == 0 && y == 0) || 
            (x == 1 && y == 0) || 
            (x == 2 && y == 0) || 
            (x == 0 && y == 1) || 
            (x == 3 && y == 1) || 
            (x == 0 && y == 2) || 
            (x == 1 && y == 2) || 
            (x == 2 && y == 2) || 
            (x == 0 && y == 3) || 
            (x == 0 && y == 4) || 
            (x == 6 && y == 0) || 
            (x == 7 && y == 0) || 
            (x == 5 && y == 1) || 
            (x == 8 && y == 1) || 
            (x == 5 && y == 2) || 
            (x == 8 && y == 2) || 
            (x == 5 && y == 3) || 
            (x == 8 && y == 3) || 
            (x == 6 && y == 4) || 
            (x == 7 && y == 4) || 
            (x == 10 && y == 0) || 
            (x == 10 && y == 1) || 
            (x == 10 && y == 2) || 
            (x == 10 && y == 3) || 
            (x == 10 && y == 4) || 
            (x == 12 && y == 0) || 
            (x == 15 && y == 0) || 
            (x == 12 && y == 1) || 
            (x == 13 && y == 1) || 
            (x == 15 && y == 1) || 
            (x == 12 && y == 2) || 
            (x == 14 && y == 2) || 
            (x == 15 && y == 2) || 
            (x == 12 && y == 3) || 
            (x == 15 && y == 3) || 
            (x == 12 && y == 4) || 
            (x == 15 && y == 4) || 
            (x == 17 && y == 0) || 
            (x == 18 && y == 0) || 
            (x == 19 && y == 0) || 
            (x == 18 && y == 1) || 
            (x == 18 && y == 2) || 
            (x == 18 && y == 3) || 
            (x == 18 && y == 4) || 
            (x == 21 && y == 0) || 
            (x == 22 && y == 0) || 
            (x == 23 && y == 0) || 
            (x == 24 && y == 0) || 
            (x == 21 && y == 1) || 
            (x == 21 && y == 2) || 
            (x == 22 && y == 2) || 
            (x == 23 && y == 2) || 
            (x == 24 && y == 2) || 
            (x == 24 && y == 3) || 
            (x == 21 && y == 4) || 
            (x == 22 && y == 4) || 
            (x == 23 && y == 4) || 
            (x == 24 && y == 4)) begin
                points_word = 1;
            end
            else begin
                points_word = 0;
            end
        end  
    endfunction
    
    always @ (posedge clk_25MHz) begin
        y = pixel_index / 96;
        x = pixel_index % 96;
        if (digit(total_points % 10, x, y, 9, 1)) begin
            oled_data <= WHITE;
        end
        else if (digit((total_points / 10) % 10, x, y, 5, 1)) begin
            oled_data <= WHITE;
        end
        else if (digit(total_points / 100, x, y, 1, 1)) begin
            oled_data <= WHITE;
        end
        else if (points_word(x, y, 14, 1)) begin
            oled_data <= BLACK;
        end 
        else begin
            oled_data <= background_green;
        end
    end        
endmodule
