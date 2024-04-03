`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.04.2024 09:30:01
// Design Name: 
// Module Name: tutorial_menu_page_3
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


module tutorial_menu_page_3(
    input clk,
    input [12:0] pixel_index,
    output reg [15:0] pixel_data,
    input btnC, btnL, btnR,
    output reg clicked_back, clicked_home
);
    reg [15:0] background = 16'b11100_100101_00111;
    reg [15:0] title_text = 16'b00111_000000_00010;
    reg [15:0] subtitle_text = 16'b01101_010010_00010;
    reg [15:0] rectangle_border = 16'b10011_100111_10011;
    
    wire clk_25m;
    flexible_clock_module flexible_clock_module_25m (
        .basys_clock(clk),
        .my_m_value(1),
        .my_clk(clk_25m)
    );
    
    function is_rectangle_border;
        input [7:0] curr_x;
        input [7:0] curr_y;
        input [7:0] origin_x;
        input [7:0] origin_y;
        input [7:0] a;
        input [7:0] b;
        begin
            is_rectangle_border = 0;
            if ((((curr_x - origin_x) * (curr_x - origin_x)) / (a * a)) + (((curr_y - origin_y) * (curr_y - origin_y)) / (b * b)) == 1)
            begin
                is_rectangle_border = 1;
            end
        end
    endfunction
        
    function is_char;
        input [7:0] curr_x;
        input [7:0] curr_y;
        input [7:0] origin_x;
        input [7:0] origin_y;
        input [7:0] ascii;
        begin
            case(ascii)
            65:
            begin
                if (curr_x == origin_x + 1 && curr_y == origin_y +0) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 4) is_char = 1;
                else is_char = 0;
            end
            66:
            begin
                if (curr_x == origin_x + 0 && curr_y == origin_y +0) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 4) is_char = 1;
                else is_char = 0;
            end
            67:
            begin
                if (curr_x == origin_x + 1 && curr_y == origin_y +0) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 4) is_char = 1;
                else is_char = 0;
            end
            68:
            begin
                if (curr_x == origin_x + 0 && curr_y == origin_y +0) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 4) is_char = 1;
                else is_char = 0;
            end
            69:
            begin
                if (curr_x == origin_x + 0 && curr_y == origin_y +0) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 4) is_char = 1;
                else is_char = 0;
            end
            70:
            begin
                if (curr_x == origin_x + 0 && curr_y == origin_y +0) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 4) is_char = 1;
                else is_char = 0;
            end
            71:
            begin
                if (curr_x == origin_x + 1 && curr_y == origin_y +0) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 4 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 4 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 4) is_char = 1;
                else is_char = 0;
            end
            72:
            begin
                if (curr_x == origin_x + 0 && curr_y == origin_y +0) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 4) is_char = 1;
                else is_char = 0;
            end
            73:
            begin
                if (curr_x == origin_x + 0 && curr_y == origin_y +0) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 4) is_char = 1;
                else is_char = 0;
            end
            75:
            begin
                if (curr_x == origin_x + 0 && curr_y == origin_y +0) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 4) is_char = 1;
                else is_char = 0;
            end
            76:
            begin
                if (curr_x == origin_x + 0 && curr_y == origin_y +0) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 4) is_char = 1;
                else is_char = 0;
            end
            77:
            begin
                if (curr_x == origin_x + 0 && curr_y == origin_y +0) is_char = 1;
                else if (curr_x == origin_x + 4 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 4 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 4 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 4 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 4 && curr_y == origin_y + 4) is_char = 1;
                else is_char = 0;
            end
            78:
            begin
                if (curr_x == origin_x + 0 && curr_y == origin_y +0) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 4) is_char = 1;
                else is_char = 0;
            end
            79:
            begin
                if (curr_x == origin_x + 1 && curr_y == origin_y +0) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 4) is_char = 1;
                else is_char = 0;
            end
            80:
            begin
                if (curr_x == origin_x + 0 && curr_y == origin_y +0) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 4) is_char = 1;
                else is_char = 0;
            end
            81:
            begin
                if (curr_x == origin_x + 1 && curr_y == origin_y +0) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 4 && curr_y == origin_y + 4) is_char = 1;
                else is_char = 0;
            end
            82:
            begin
                if (curr_x == origin_x + 0 && curr_y == origin_y +0) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 4) is_char = 1;
                else is_char = 0;
            end
            83:
            begin
                if (curr_x == origin_x + 0 && curr_y == origin_y +0) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 4) is_char = 1;
                else is_char = 0;
            end
            84:
            begin
                if (curr_x == origin_x + 0 && curr_y == origin_y +0) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 4) is_char = 1;
                else is_char = 0;
            end
            85:
            begin
                if (curr_x == origin_x + 0 && curr_y == origin_y +0) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 4) is_char = 1;
                else is_char = 0;
            end
            86:
            begin
                if (curr_x == origin_x + 0 && curr_y == origin_y +0) is_char = 1;
                else if (curr_x == origin_x + 4 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 4 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 4 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 4) is_char = 1;
                else is_char = 0;
            end
            87:
            begin
                if (curr_x == origin_x + 0 && curr_y == origin_y +0) is_char = 1;
                else if (curr_x == origin_x + 4 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 4 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 4 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 4 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 4) is_char = 1;
                else is_char = 0;
            end
            88:
            begin
                if (curr_x == origin_x + 0 && curr_y == origin_y +0) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 4) is_char = 1;
                else is_char = 0;
            end
            89:
            begin
                if (curr_x == origin_x + 0 && curr_y == origin_y +0) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 4) is_char = 1;
                else is_char = 0;
            end
            90:
            begin
                if (curr_x == origin_x + 0 && curr_y == origin_y +0) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 4) is_char = 1;
                else is_char = 0;
            end
            74:
            begin
                if (curr_x == origin_x + 0 && curr_y == origin_y +0) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 4) is_char = 1;
                else is_char = 0;
            end
            49:
            begin
                if (curr_x == origin_x + 1 && curr_y == origin_y +0) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 4) is_char = 1;
                else is_char = 0;
            end
            50:
            begin
                if (curr_x == origin_x + 0 && curr_y == origin_y +0) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 4) is_char = 1;
                else is_char = 0;
            end
            51:
            begin
                if (curr_x == origin_x + 0 && curr_y == origin_y +0) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 4) is_char = 1;
                else is_char = 0;
            end
            52:
            begin
                if (curr_x == origin_x + 0 && curr_y == origin_y +0) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 4) is_char = 1;
                else is_char = 0;
            end
            53:
            begin
                if (curr_x == origin_x + 0 && curr_y == origin_y +0) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 4) is_char = 1;
                else is_char = 0;
            end
            54:
            begin
                if (curr_x == origin_x + 0 && curr_y == origin_y +0) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 4) is_char = 1;
                else is_char = 0;
            end
            55:
            begin
                if (curr_x == origin_x + 0 && curr_y == origin_y +0) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 4) is_char = 1;
                else is_char = 0;
            end
            56:
            begin
                if (curr_x == origin_x + 0 && curr_y == origin_y +0) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 4) is_char = 1;
                else is_char = 0;
            end
            57:
            begin
                if (curr_x == origin_x + 0 && curr_y == origin_y +0) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 4) is_char = 1;
                else is_char = 0;
            end
            48:
            begin
                if (curr_x == origin_x + 0 && curr_y == origin_y +0) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 4) is_char = 1;
                else is_char = 0;
            end
            45:
            begin
                if (curr_x == origin_x + 0 && curr_y == origin_y +2) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 2 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 4 && curr_y == origin_y + 2) is_char = 1;
                else is_char = 0;
            end
            58:
            begin
                if (curr_x == origin_x + 0 && curr_y == origin_y +0) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 4) is_char = 1;
                else is_char = 0;
            end
            37:
            begin
                if (curr_x == origin_x + 0 && curr_y == origin_y +3) is_char = 1;
                else if (curr_x == origin_x + 0 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 1 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 5) is_char = 1;
                else if (curr_x == origin_x + 3 && curr_y == origin_y + 7) is_char = 1;
                else if (curr_x == origin_x + 4 && curr_y == origin_y + 0) is_char = 1;
                else if (curr_x == origin_x + 4 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 4 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 4 && curr_y == origin_y + 7) is_char = 1;
                else if (curr_x == origin_x + 5 && curr_y == origin_y + 1) is_char = 1;
                else if (curr_x == origin_x + 5 && curr_y == origin_y + 6) is_char = 1;
                else if (curr_x == origin_x + 6 && curr_y == origin_y + 2) is_char = 1;
                else if (curr_x == origin_x + 6 && curr_y == origin_y + 3) is_char = 1;
                else if (curr_x == origin_x + 6 && curr_y == origin_y + 4) is_char = 1;
                else if (curr_x == origin_x + 6 && curr_y == origin_y + 5) is_char = 1;
                else is_char = 0;
            end
            default: is_char = 0;
        endcase
        end
    endfunction
    
    // selection at left
    reg [7:0] select_left_x = 32;
    reg [7:0] select_left_y = 54;
    reg [7:0] select_left_a = 14;
    reg [7:0] select_left_b = 5;
    
    // selection at right
    reg [7:0] select_right_x = 66;
    reg [7:0] select_right_y = 54;
    reg [7:0] select_right_a = 14;
    reg [7:0] select_right_b = 5;
    
    reg [7:0] rectangle_border_x = 128;
    reg [7:0] rectangle_border_y = 128;
    reg [7:0] rectangle_border_a = 128;
    reg [7:0] rectangle_border_b = 128;
        
    always @ (posedge clk)
    begin
        if (rectangle_border_x == 128 && btnL)
            begin
                rectangle_border_x = select_left_x;
                rectangle_border_y = select_left_y;
                rectangle_border_a = select_left_a;
                rectangle_border_b = select_left_b;
            end
        else if (rectangle_border_x == 128 && btnR)
            begin
                rectangle_border_x = select_right_x;
                rectangle_border_y = select_right_y;
                rectangle_border_a = select_right_a;
                rectangle_border_b = select_right_b;
            end
        else if (rectangle_border_x == select_left_x && btnR)
            begin
                rectangle_border_x = select_right_x;
                rectangle_border_y = select_right_y;
                rectangle_border_a = select_right_a;
                rectangle_border_b = select_right_b;
            end
        else if (rectangle_border_x == select_right_x && btnL)
            begin
                rectangle_border_x = select_left_x;
                rectangle_border_y = select_left_y;
                rectangle_border_a = select_left_a;
                rectangle_border_b = select_left_b;
            end
        
        if (rectangle_border_x == select_left_x && btnC)
            begin
                clicked_back = 1;
                clicked_home = 0;
                rectangle_border_x = 128;
                rectangle_border_y = 128;
                rectangle_border_a = 128;
                rectangle_border_b = 128;
            end
        else if (rectangle_border_x == select_right_x && btnC)
            begin
                clicked_back = 0;
                clicked_home = 1;
                rectangle_border_x = 128;
                rectangle_border_y = 128;
                rectangle_border_a = 128;
                rectangle_border_b = 128;
            end
        else
            begin
                clicked_back = 0;
                clicked_home = 0;
            end
    end
    
    reg [7:0] x, y;
    always @ (posedge clk_25m)
    begin
        x = pixel_index % 96;
        y = pixel_index / 96;
        
        // "PRESS"
        if (is_char(x, y, 8, 8, 80)) pixel_data <= title_text;
        else if (is_char(x, y, 13, 8, 82)) pixel_data <= title_text;
        else if (is_char(x, y, 18, 8, 69)) pixel_data <= title_text;
        else if (is_char(x, y, 23, 8, 83)) pixel_data <= title_text;
        else if (is_char(x, y, 28, 8, 83)) pixel_data <= title_text;
                    
        // "BACK"
        else if (is_char(x, y, 23, 52, 66)) pixel_data <= subtitle_text;
        else if (is_char(x, y, 28, 52, 65)) pixel_data <= subtitle_text;
        else if (is_char(x, y, 33, 52, 67)) pixel_data <= subtitle_text;
        else if (is_char(x, y, 38, 52, 75)) pixel_data <= subtitle_text;
        
        // "HOME"
        else if (is_char(x, y, 58, 52, 72)) pixel_data <= subtitle_text;
        else if (is_char(x, y, 63, 52, 79)) pixel_data <= subtitle_text;
        else if (is_char(x, y, 68, 52, 77)) pixel_data <= subtitle_text;
        else if (is_char(x, y, 73, 52, 69)) pixel_data <= subtitle_text;
        
        else if (x == 22 && y == 18)
        begin
            pixel_data <= 16'b01101_011101_01100;
        end
        else if (x == 23 && y == 18)
        begin
            pixel_data <= 16'b01011_011110_01001;
        end
        else if (x == 24 && y == 18)
        begin
            pixel_data <= 16'b01011_011111_01001;
        end
        else if (x == 25 && y == 18)
        begin
            pixel_data <= 16'b01011_011110_01001;
        end
        else if (x == 26 && y == 18)
        begin
            pixel_data <= 16'b01101_011100_01100;
        end
        else if (x == 69 && y == 18)
        begin
            pixel_data <= 16'b01101_001111_10001;
        end
        else if (x == 70 && y == 18)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 71 && y == 18)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 72 && y == 18)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 73 && y == 18)
        begin
            pixel_data <= 16'b01100_001110_10001;
        end
        else if (x == 20 && y == 19)
        begin
            pixel_data <= 16'b11111_011111_11111;
        end
        else if (x == 21 && y == 19)
        begin
            pixel_data <= 16'b01110_011101_01101;
        end
        else if (x == 22 && y == 19)
        begin
            pixel_data <= 16'b01011_011110_01001;
        end
        else if (x == 23 && y == 19)
        begin
            pixel_data <= 16'b01010_011110_01001;
        end
        else if (x == 24 && y == 19)
        begin
            pixel_data <= 16'b01010_011111_01001;
        end
        else if (x == 25 && y == 19)
        begin
            pixel_data <= 16'b01010_011110_01001;
        end
        else if (x == 26 && y == 19)
        begin
            pixel_data <= 16'b01011_011110_01010;
        end
        else if (x == 27 && y == 19)
        begin
            pixel_data <= 16'b01101_011101_01101;
        end
        else if (x == 28 && y == 19)
        begin
            pixel_data <= 16'b01111_011111_01111;
        end
        else if (x == 67 && y == 19)
        begin
            pixel_data <= 16'b11111_011111_11111;
        end
        else if (x == 68 && y == 19)
        begin
            pixel_data <= 16'b01101_001110_10001;
        end
        else if (x == 69 && y == 19)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 70 && y == 19)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 71 && y == 19)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 72 && y == 19)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 73 && y == 19)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 74 && y == 19)
        begin
            pixel_data <= 16'b01101_001111_10010;
        end
        else if (x == 75 && y == 19)
        begin
            pixel_data <= 16'b01111_001111_01111;
        end
        else if (x == 20 && y == 20)
        begin
            pixel_data <= 16'b01110_011100_01110;
        end
        else if (x == 21 && y == 20)
        begin
            pixel_data <= 16'b01011_011110_01010;
        end
        else if (x == 22 && y == 20)
        begin
            pixel_data <= 16'b01011_011111_01001;
        end
        else if (x == 23 && y == 20)
        begin
            pixel_data <= 16'b01010_011111_01001;
        end
        else if (x == 24 && y == 20)
        begin
            pixel_data <= 16'b01010_011111_01001;
        end
        else if (x == 25 && y == 20)
        begin
            pixel_data <= 16'b01010_011111_01001;
        end
        else if (x == 26 && y == 20)
        begin
            pixel_data <= 16'b01011_011111_01001;
        end
        else if (x == 27 && y == 20)
        begin
            pixel_data <= 16'b01011_011110_01001;
        end
        else if (x == 28 && y == 20)
        begin
            pixel_data <= 16'b01110_011101_01101;
        end
        else if (x == 67 && y == 20)
        begin
            pixel_data <= 16'b01100_001110_10000;
        end
        else if (x == 68 && y == 20)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 69 && y == 20)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 70 && y == 20)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 71 && y == 20)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 72 && y == 20)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 73 && y == 20)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 74 && y == 20)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 75 && y == 20)
        begin
            pixel_data <= 16'b01101_001110_10001;
        end
        else if (x == 20 && y == 21)
        begin
            pixel_data <= 16'b01111_011111_01101;
        end
        else if (x == 21 && y == 21)
        begin
            pixel_data <= 16'b01011_011110_01001;
        end
        else if (x == 22 && y == 21)
        begin
            pixel_data <= 16'b01011_011111_01001;
        end
        else if (x == 23 && y == 21)
        begin
            pixel_data <= 16'b01010_011111_01001;
        end
        else if (x == 24 && y == 21)
        begin
            pixel_data <= 16'b01010_011111_01001;
        end
        else if (x == 25 && y == 21)
        begin
            pixel_data <= 16'b01010_011111_01001;
        end
        else if (x == 26 && y == 21)
        begin
            pixel_data <= 16'b01010_011111_01001;
        end
        else if (x == 27 && y == 21)
        begin
            pixel_data <= 16'b01011_011110_01001;
        end
        else if (x == 28 && y == 21)
        begin
            pixel_data <= 16'b01110_011101_01100;
        end
        else if (x == 67 && y == 21)
        begin
            pixel_data <= 16'b01011_001110_10001;
        end
        else if (x == 68 && y == 21)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 69 && y == 21)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 70 && y == 21)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 71 && y == 21)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 72 && y == 21)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 73 && y == 21)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 74 && y == 21)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 75 && y == 21)
        begin
            pixel_data <= 16'b01100_001101_10010;
        end
        else if (x == 20 && y == 22)
        begin
            pixel_data <= 16'b01110_011100_01110;
        end
        else if (x == 21 && y == 22)
        begin
            pixel_data <= 16'b01011_011110_01010;
        end
        else if (x == 22 && y == 22)
        begin
            pixel_data <= 16'b01011_011111_01001;
        end
        else if (x == 23 && y == 22)
        begin
            pixel_data <= 16'b01010_011111_01001;
        end
        else if (x == 24 && y == 22)
        begin
            pixel_data <= 16'b01010_011111_01001;
        end
        else if (x == 25 && y == 22)
        begin
            pixel_data <= 16'b01010_011111_01001;
        end
        else if (x == 26 && y == 22)
        begin
            pixel_data <= 16'b01011_011111_01001;
        end
        else if (x == 27 && y == 22)
        begin
            pixel_data <= 16'b01011_011110_01010;
        end
        else if (x == 28 && y == 22)
        begin
            pixel_data <= 16'b01110_011100_01101;
        end
        else if (x == 67 && y == 22)
        begin
            pixel_data <= 16'b01100_001110_10000;
        end
        else if (x == 68 && y == 22)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 69 && y == 22)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 70 && y == 22)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 71 && y == 22)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 72 && y == 22)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 73 && y == 22)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 74 && y == 22)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 75 && y == 22)
        begin
            pixel_data <= 16'b01101_001110_10001;
        end
        else if (x == 20 && y == 23)
        begin
            pixel_data <= 16'b11111_011111_11111;
        end
        else if (x == 21 && y == 23)
        begin
            pixel_data <= 16'b01101_011100_01100;
        end
        else if (x == 22 && y == 23)
        begin
            pixel_data <= 16'b01011_011110_01001;
        end
        else if (x == 23 && y == 23)
        begin
            pixel_data <= 16'b01011_011111_01001;
        end
        else if (x == 24 && y == 23)
        begin
            pixel_data <= 16'b01011_011111_01001;
        end
        else if (x == 25 && y == 23)
        begin
            pixel_data <= 16'b01011_011111_01001;
        end
        else if (x == 26 && y == 23)
        begin
            pixel_data <= 16'b01011_011110_01010;
        end
        else if (x == 27 && y == 23)
        begin
            pixel_data <= 16'b01110_011100_01101;
        end
        else if (x == 28 && y == 23)
        begin
            pixel_data <= 16'b01111_011111_01111;
        end
        else if (x == 49 && y == 23)
        begin
            pixel_data <= 16'b01111_011111_11111;
        end
        else if (x == 50 && y == 23)
        begin
            pixel_data <= 16'b01100_010111_11011;
        end
        else if (x == 67 && y == 23)
        begin
            pixel_data <= 16'b11111_011111_11111;
        end
        else if (x == 68 && y == 23)
        begin
            pixel_data <= 16'b01101_001110_10001;
        end
        else if (x == 69 && y == 23)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 70 && y == 23)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 71 && y == 23)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 72 && y == 23)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 73 && y == 23)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 74 && y == 23)
        begin
            pixel_data <= 16'b01100_001111_10001;
        end
        else if (x == 75 && y == 23)
        begin
            pixel_data <= 16'b11111_011111_11111;
        end
        else if (x == 22 && y == 24)
        begin
            pixel_data <= 16'b01110_011100_01101;
        end
        else if (x == 23 && y == 24)
        begin
            pixel_data <= 16'b01011_011110_01001;
        end
        else if (x == 24 && y == 24)
        begin
            pixel_data <= 16'b01011_011111_01001;
        end
        else if (x == 25 && y == 24)
        begin
            pixel_data <= 16'b01011_011110_01001;
        end
        else if (x == 26 && y == 24)
        begin
            pixel_data <= 16'b01110_011100_01101;
        end
        else if (x == 49 && y == 24)
        begin
            pixel_data <= 16'b01011_010110_11011;
        end
        else if (x == 50 && y == 24)
        begin
            pixel_data <= 16'b01000_010110_11100;
        end
        else if (x == 51 && y == 24)
        begin
            pixel_data <= 16'b01010_010110_11100;
        end
        else if (x == 69 && y == 24)
        begin
            pixel_data <= 16'b01101_001111_10001;
        end
        else if (x == 70 && y == 24)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 71 && y == 24)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 72 && y == 24)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 73 && y == 24)
        begin
            pixel_data <= 16'b01101_001111_10010;
        end
        else if (x == 23 && y == 25)
        begin
            pixel_data <= 16'b01111_011111_01100;
        end
        else if (x == 24 && y == 25)
        begin
            pixel_data <= 16'b10000_011111_01011;
        end
        else if (x == 25 && y == 25)
        begin
            pixel_data <= 16'b01110_011111_01011;
        end
        else if (x == 49 && y == 25)
        begin
            pixel_data <= 16'b01100_010110_11011;
        end
        else if (x == 50 && y == 25)
        begin
            pixel_data <= 16'b01000_010110_11100;
        end
        else if (x == 51 && y == 25)
        begin
            pixel_data <= 16'b01000_010110_11100;
        end
        else if (x == 52 && y == 25)
        begin
            pixel_data <= 16'b01010_010110_11011;
        end
        else if (x == 70 && y == 25)
        begin
            pixel_data <= 16'b01101_010000_10011;
        end
        else if (x == 71 && y == 25)
        begin
            pixel_data <= 16'b01110_010000_10010;
        end
        else if (x == 72 && y == 25)
        begin
            pixel_data <= 16'b01101_010000_10011;
        end
        else if (x == 14 && y == 26)
        begin
            pixel_data <= 16'b01011_001101_10000;
        end
        else if (x == 15 && y == 26)
        begin
            pixel_data <= 16'b01100_001110_10010;
        end
        else if (x == 16 && y == 26)
        begin
            pixel_data <= 16'b01011_001110_10000;
        end
        else if (x == 23 && y == 26)
        begin
            pixel_data <= 16'b01100_001100_10001;
        end
        else if (x == 24 && y == 26)
        begin
            pixel_data <= 16'b01100_001101_10010;
        end
        else if (x == 25 && y == 26)
        begin
            pixel_data <= 16'b01011_001101_10001;
        end
        else if (x == 32 && y == 26)
        begin
            pixel_data <= 16'b01100_001101_10000;
        end
        else if (x == 33 && y == 26)
        begin
            pixel_data <= 16'b01100_001110_10010;
        end
        else if (x == 34 && y == 26)
        begin
            pixel_data <= 16'b01100_001110_10001;
        end
        else if (x == 49 && y == 26)
        begin
            pixel_data <= 16'b01101_010110_11010;
        end
        else if (x == 50 && y == 26)
        begin
            pixel_data <= 16'b01000_010110_11100;
        end
        else if (x == 51 && y == 26)
        begin
            pixel_data <= 16'b01000_010111_11110;
        end
        else if (x == 52 && y == 26)
        begin
            pixel_data <= 16'b01000_010110_11101;
        end
        else if (x == 53 && y == 26)
        begin
            pixel_data <= 16'b01010_010110_11100;
        end
        else if (x == 61 && y == 26)
        begin
            pixel_data <= 16'b01100_001110_10001;
        end
        else if (x == 62 && y == 26)
        begin
            pixel_data <= 16'b01011_001110_10001;
        end
        else if (x == 63 && y == 26)
        begin
            pixel_data <= 16'b01100_001110_10001;
        end
        else if (x == 70 && y == 26)
        begin
            pixel_data <= 16'b01100_001101_10001;
        end
        else if (x == 71 && y == 26)
        begin
            pixel_data <= 16'b01100_001110_10001;
        end
        else if (x == 72 && y == 26)
        begin
            pixel_data <= 16'b01011_001110_10001;
        end
        else if (x == 79 && y == 26)
        begin
            pixel_data <= 16'b01100_001110_10001;
        end
        else if (x == 80 && y == 26)
        begin
            pixel_data <= 16'b01011_001110_10001;
        end
        else if (x == 81 && y == 26)
        begin
            pixel_data <= 16'b01100_001110_10001;
        end
        else if (x == 13 && y == 27)
        begin
            pixel_data <= 16'b01100_001110_10000;
        end
        else if (x == 14 && y == 27)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 15 && y == 27)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 16 && y == 27)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 17 && y == 27)
        begin
            pixel_data <= 16'b01100_001110_10001;
        end
        else if (x == 22 && y == 27)
        begin
            pixel_data <= 16'b01101_001110_10001;
        end
        else if (x == 23 && y == 27)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 24 && y == 27)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 25 && y == 27)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 26 && y == 27)
        begin
            pixel_data <= 16'b01100_001110_10001;
        end
        else if (x == 31 && y == 27)
        begin
            pixel_data <= 16'b01100_001110_10001;
        end
        else if (x == 32 && y == 27)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 33 && y == 27)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 34 && y == 27)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 35 && y == 27)
        begin
            pixel_data <= 16'b01100_001110_10001;
        end
        else if (x == 39 && y == 27)
        begin
            pixel_data <= 16'b01111_001111_01111;
        end
        else if (x == 40 && y == 27)
        begin
            pixel_data <= 16'b01011_010111_11100;
        end
        else if (x == 41 && y == 27)
        begin
            pixel_data <= 16'b01011_010110_11100;
        end
        else if (x == 42 && y == 27)
        begin
            pixel_data <= 16'b01011_010110_11100;
        end
        else if (x == 43 && y == 27)
        begin
            pixel_data <= 16'b01010_010110_11011;
        end
        else if (x == 44 && y == 27)
        begin
            pixel_data <= 16'b01011_010110_11011;
        end
        else if (x == 45 && y == 27)
        begin
            pixel_data <= 16'b01010_010110_11011;
        end
        else if (x == 46 && y == 27)
        begin
            pixel_data <= 16'b01011_010110_11011;
        end
        else if (x == 47 && y == 27)
        begin
            pixel_data <= 16'b01010_010110_11011;
        end
        else if (x == 48 && y == 27)
        begin
            pixel_data <= 16'b01011_010110_11100;
        end
        else if (x == 49 && y == 27)
        begin
            pixel_data <= 16'b01011_010110_11011;
        end
        else if (x == 50 && y == 27)
        begin
            pixel_data <= 16'b01000_010110_11100;
        end
        else if (x == 51 && y == 27)
        begin
            pixel_data <= 16'b01000_010110_11101;
        end
        else if (x == 52 && y == 27)
        begin
            pixel_data <= 16'b01000_010110_11101;
        end
        else if (x == 53 && y == 27)
        begin
            pixel_data <= 16'b01000_010110_11101;
        end
        else if (x == 54 && y == 27)
        begin
            pixel_data <= 16'b01010_010110_11100;
        end
        else if (x == 60 && y == 27)
        begin
            pixel_data <= 16'b01101_001111_10001;
        end
        else if (x == 61 && y == 27)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 62 && y == 27)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 63 && y == 27)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 64 && y == 27)
        begin
            pixel_data <= 16'b01100_001110_10001;
        end
        else if (x == 69 && y == 27)
        begin
            pixel_data <= 16'b01101_001110_10001;
        end
        else if (x == 70 && y == 27)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 71 && y == 27)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 72 && y == 27)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 73 && y == 27)
        begin
            pixel_data <= 16'b01100_001110_10001;
        end
        else if (x == 78 && y == 27)
        begin
            pixel_data <= 16'b01100_001111_10001;
        end
        else if (x == 79 && y == 27)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 80 && y == 27)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 81 && y == 27)
        begin
            pixel_data <= 16'b01011_001101_10001;
        end
        else if (x == 82 && y == 27)
        begin
            pixel_data <= 16'b01101_001111_10010;
        end
        else if (x == 12 && y == 28)
        begin
            pixel_data <= 16'b01101_001110_10001;
        end
        else if (x == 13 && y == 28)
        begin
            pixel_data <= 16'b01011_001101_10001;
        end
        else if (x == 14 && y == 28)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 15 && y == 28)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 16 && y == 28)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 17 && y == 28)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 18 && y == 28)
        begin
            pixel_data <= 16'b01100_001110_10001;
        end
        else if (x == 19 && y == 28)
        begin
            pixel_data <= 16'b01010_001010_01010;
        end
        else if (x == 20 && y == 28)
        begin
            pixel_data <= 16'b11111_011111_11111;
        end
        else if (x == 21 && y == 28)
        begin
            pixel_data <= 16'b01100_001111_10001;
        end
        else if (x == 22 && y == 28)
        begin
            pixel_data <= 16'b01011_001101_10001;
        end
        else if (x == 23 && y == 28)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 24 && y == 28)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 25 && y == 28)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 26 && y == 28)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 27 && y == 28)
        begin
            pixel_data <= 16'b01100_001110_10001;
        end
        else if (x == 28 && y == 28)
        begin
            pixel_data <= 16'b01010_001010_01010;
        end
        else if (x == 29 && y == 28)
        begin
            pixel_data <= 16'b11111_011111_11111;
        end
        else if (x == 30 && y == 28)
        begin
            pixel_data <= 16'b01100_001110_10001;
        end
        else if (x == 31 && y == 28)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 32 && y == 28)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 33 && y == 28)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 34 && y == 28)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 35 && y == 28)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 36 && y == 28)
        begin
            pixel_data <= 16'b01100_001110_10001;
        end
        else if (x == 37 && y == 28)
        begin
            pixel_data <= 16'b01010_001010_10100;
        end
        else if (x == 39 && y == 28)
        begin
            pixel_data <= 16'b01100_010110_11010;
        end
        else if (x == 40 && y == 28)
        begin
            pixel_data <= 16'b01000_010110_11100;
        end
        else if (x == 41 && y == 28)
        begin
            pixel_data <= 16'b01000_010110_11101;
        end
        else if (x == 42 && y == 28)
        begin
            pixel_data <= 16'b01000_010110_11101;
        end
        else if (x == 43 && y == 28)
        begin
            pixel_data <= 16'b01000_010110_11101;
        end
        else if (x == 44 && y == 28)
        begin
            pixel_data <= 16'b01000_010110_11101;
        end
        else if (x == 45 && y == 28)
        begin
            pixel_data <= 16'b01000_010110_11101;
        end
        else if (x == 46 && y == 28)
        begin
            pixel_data <= 16'b01000_010110_11101;
        end
        else if (x == 47 && y == 28)
        begin
            pixel_data <= 16'b01000_010110_11101;
        end
        else if (x == 48 && y == 28)
        begin
            pixel_data <= 16'b01000_010110_11101;
        end
        else if (x == 49 && y == 28)
        begin
            pixel_data <= 16'b01000_010110_11101;
        end
        else if (x == 50 && y == 28)
        begin
            pixel_data <= 16'b00111_010110_11101;
        end
        else if (x == 51 && y == 28)
        begin
            pixel_data <= 16'b00111_010110_11101;
        end
        else if (x == 52 && y == 28)
        begin
            pixel_data <= 16'b00111_010110_11101;
        end
        else if (x == 53 && y == 28)
        begin
            pixel_data <= 16'b01000_010110_11101;
        end
        else if (x == 54 && y == 28)
        begin
            pixel_data <= 16'b01000_010110_11100;
        end
        else if (x == 55 && y == 28)
        begin
            pixel_data <= 16'b01010_010110_11011;
        end
        else if (x == 56 && y == 28)
        begin
            pixel_data <= 16'b01111_011111_11111;
        end
        else if (x == 58 && y == 28)
        begin
            pixel_data <= 16'b01111_001111_01111;
        end
        else if (x == 59 && y == 28)
        begin
            pixel_data <= 16'b01100_001110_10001;
        end
        else if (x == 60 && y == 28)
        begin
            pixel_data <= 16'b01011_001101_10001;
        end
        else if (x == 61 && y == 28)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 62 && y == 28)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 63 && y == 28)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 64 && y == 28)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 65 && y == 28)
        begin
            pixel_data <= 16'b01100_001110_10001;
        end
        else if (x == 66 && y == 28)
        begin
            pixel_data <= 16'b01111_001111_01111;
        end
        else if (x == 67 && y == 28)
        begin
            pixel_data <= 16'b01111_001111_01111;
        end
        else if (x == 68 && y == 28)
        begin
            pixel_data <= 16'b01100_001111_10001;
        end
        else if (x == 69 && y == 28)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 70 && y == 28)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 71 && y == 28)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 72 && y == 28)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 73 && y == 28)
        begin
            pixel_data <= 16'b01011_001101_10001;
        end
        else if (x == 74 && y == 28)
        begin
            pixel_data <= 16'b01100_001110_10001;
        end
        else if (x == 75 && y == 28)
        begin
            pixel_data <= 16'b01111_001111_01111;
        end
        else if (x == 76 && y == 28)
        begin
            pixel_data <= 16'b01111_001111_01111;
        end
        else if (x == 77 && y == 28)
        begin
            pixel_data <= 16'b01101_001111_10010;
        end
        else if (x == 78 && y == 28)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 79 && y == 28)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 80 && y == 28)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 81 && y == 28)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 82 && y == 28)
        begin
            pixel_data <= 16'b01011_001101_10001;
        end
        else if (x == 83 && y == 28)
        begin
            pixel_data <= 16'b01100_001110_10001;
        end
        else if (x == 12 && y == 29)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 13 && y == 29)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 14 && y == 29)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 15 && y == 29)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 16 && y == 29)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 17 && y == 29)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 18 && y == 29)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 19 && y == 29)
        begin
            pixel_data <= 16'b01011_001110_10000;
        end
        else if (x == 20 && y == 29)
        begin
            pixel_data <= 16'b01111_010010_10010;
        end
        else if (x == 21 && y == 29)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 22 && y == 29)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 23 && y == 29)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 24 && y == 29)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 25 && y == 29)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 26 && y == 29)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 27 && y == 29)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 28 && y == 29)
        begin
            pixel_data <= 16'b01101_001110_10001;
        end
        else if (x == 29 && y == 29)
        begin
            pixel_data <= 16'b01101_001101_10011;
        end
        else if (x == 30 && y == 29)
        begin
            pixel_data <= 16'b01011_001101_10001;
        end
        else if (x == 31 && y == 29)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 32 && y == 29)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 33 && y == 29)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 34 && y == 29)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 35 && y == 29)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 36 && y == 29)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 37 && y == 29)
        begin
            pixel_data <= 16'b01100_001111_10001;
        end
        else if (x == 39 && y == 29)
        begin
            pixel_data <= 16'b01011_010111_11101;
        end
        else if (x == 40 && y == 29)
        begin
            pixel_data <= 16'b01000_010110_11100;
        end
        else if (x == 41 && y == 29)
        begin
            pixel_data <= 16'b01000_010110_11110;
        end
        else if (x == 42 && y == 29)
        begin
            pixel_data <= 16'b00111_010110_11101;
        end
        else if (x == 43 && y == 29)
        begin
            pixel_data <= 16'b00111_010110_11101;
        end
        else if (x == 44 && y == 29)
        begin
            pixel_data <= 16'b00111_010110_11101;
        end
        else if (x == 45 && y == 29)
        begin
            pixel_data <= 16'b00111_010110_11101;
        end
        else if (x == 46 && y == 29)
        begin
            pixel_data <= 16'b00111_010110_11101;
        end
        else if (x == 47 && y == 29)
        begin
            pixel_data <= 16'b00111_010110_11101;
        end
        else if (x == 48 && y == 29)
        begin
            pixel_data <= 16'b00111_010110_11101;
        end
        else if (x == 49 && y == 29)
        begin
            pixel_data <= 16'b00111_010110_11101;
        end
        else if (x == 50 && y == 29)
        begin
            pixel_data <= 16'b00111_010110_11101;
        end
        else if (x == 51 && y == 29)
        begin
            pixel_data <= 16'b00111_010110_11101;
        end
        else if (x == 52 && y == 29)
        begin
            pixel_data <= 16'b00111_010110_11101;
        end
        else if (x == 53 && y == 29)
        begin
            pixel_data <= 16'b00111_010110_11101;
        end
        else if (x == 54 && y == 29)
        begin
            pixel_data <= 16'b01000_010110_11101;
        end
        else if (x == 55 && y == 29)
        begin
            pixel_data <= 16'b01000_010110_11100;
        end
        else if (x == 56 && y == 29)
        begin
            pixel_data <= 16'b01011_010110_11100;
        end
        else if (x == 58 && y == 29)
        begin
            pixel_data <= 16'b01101_001111_10001;
        end
        else if (x == 59 && y == 29)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 60 && y == 29)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 61 && y == 29)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 62 && y == 29)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 63 && y == 29)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 64 && y == 29)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 65 && y == 29)
        begin
            pixel_data <= 16'b01011_001101_10001;
        end
        else if (x == 66 && y == 29)
        begin
            pixel_data <= 16'b01101_001111_10001;
        end
        else if (x == 67 && y == 29)
        begin
            pixel_data <= 16'b01100_001110_10000;
        end
        else if (x == 68 && y == 29)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 69 && y == 29)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 70 && y == 29)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 71 && y == 29)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 72 && y == 29)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 73 && y == 29)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 74 && y == 29)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 75 && y == 29)
        begin
            pixel_data <= 16'b01100_001110_10000;
        end
        else if (x == 76 && y == 29)
        begin
            pixel_data <= 16'b01110_010000_10010;
        end
        else if (x == 77 && y == 29)
        begin
            pixel_data <= 16'b01011_001101_10001;
        end
        else if (x == 78 && y == 29)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 79 && y == 29)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 80 && y == 29)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 81 && y == 29)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 82 && y == 29)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 83 && y == 29)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 12 && y == 30)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 13 && y == 30)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 14 && y == 30)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 15 && y == 30)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 16 && y == 30)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 17 && y == 30)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 18 && y == 30)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 19 && y == 30)
        begin
            pixel_data <= 16'b01011_001101_10001;
        end
        else if (x == 20 && y == 30)
        begin
            pixel_data <= 16'b01101_010000_10011;
        end
        else if (x == 21 && y == 30)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 22 && y == 30)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 23 && y == 30)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 24 && y == 30)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 25 && y == 30)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 26 && y == 30)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 27 && y == 30)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 28 && y == 30)
        begin
            pixel_data <= 16'b01100_001110_10001;
        end
        else if (x == 29 && y == 30)
        begin
            pixel_data <= 16'b01100_001100_10001;
        end
        else if (x == 30 && y == 30)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 31 && y == 30)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 32 && y == 30)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 33 && y == 30)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 34 && y == 30)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 35 && y == 30)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 36 && y == 30)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 37 && y == 30)
        begin
            pixel_data <= 16'b01101_001111_10001;
        end
        else if (x == 39 && y == 30)
        begin
            pixel_data <= 16'b01011_010111_11011;
        end
        else if (x == 40 && y == 30)
        begin
            pixel_data <= 16'b01000_010110_11100;
        end
        else if (x == 41 && y == 30)
        begin
            pixel_data <= 16'b01000_010111_11110;
        end
        else if (x == 42 && y == 30)
        begin
            pixel_data <= 16'b01000_010110_11101;
        end
        else if (x == 43 && y == 30)
        begin
            pixel_data <= 16'b01000_010110_11101;
        end
        else if (x == 44 && y == 30)
        begin
            pixel_data <= 16'b01000_010110_11101;
        end
        else if (x == 45 && y == 30)
        begin
            pixel_data <= 16'b01000_010110_11101;
        end
        else if (x == 46 && y == 30)
        begin
            pixel_data <= 16'b01000_010110_11101;
        end
        else if (x == 47 && y == 30)
        begin
            pixel_data <= 16'b01000_010110_11101;
        end
        else if (x == 48 && y == 30)
        begin
            pixel_data <= 16'b01000_010110_11101;
        end
        else if (x == 49 && y == 30)
        begin
            pixel_data <= 16'b01000_010110_11101;
        end
        else if (x == 50 && y == 30)
        begin
            pixel_data <= 16'b00111_010110_11101;
        end
        else if (x == 51 && y == 30)
        begin
            pixel_data <= 16'b00111_010110_11101;
        end
        else if (x == 52 && y == 30)
        begin
            pixel_data <= 16'b00111_010110_11101;
        end
        else if (x == 53 && y == 30)
        begin
            pixel_data <= 16'b00111_010110_11101;
        end
        else if (x == 54 && y == 30)
        begin
            pixel_data <= 16'b01000_010110_11101;
        end
        else if (x == 55 && y == 30)
        begin
            pixel_data <= 16'b01000_010110_11100;
        end
        else if (x == 56 && y == 30)
        begin
            pixel_data <= 16'b01010_010110_11011;
        end
        else if (x == 58 && y == 30)
        begin
            pixel_data <= 16'b01100_001101_10001;
        end
        else if (x == 59 && y == 30)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 60 && y == 30)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 61 && y == 30)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 62 && y == 30)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 63 && y == 30)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 64 && y == 30)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 65 && y == 30)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 66 && y == 30)
        begin
            pixel_data <= 16'b01100_001111_10010;
        end
        else if (x == 67 && y == 30)
        begin
            pixel_data <= 16'b01011_001101_01111;
        end
        else if (x == 68 && y == 30)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 69 && y == 30)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 70 && y == 30)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 71 && y == 30)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 72 && y == 30)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 73 && y == 30)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 74 && y == 30)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 75 && y == 30)
        begin
            pixel_data <= 16'b01101_001101_10001;
        end
        else if (x == 76 && y == 30)
        begin
            pixel_data <= 16'b01100_001110_10010;
        end
        else if (x == 77 && y == 30)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 78 && y == 30)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 79 && y == 30)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 80 && y == 30)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 81 && y == 30)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 82 && y == 30)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 83 && y == 30)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 12 && y == 31)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 13 && y == 31)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 14 && y == 31)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 15 && y == 31)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 16 && y == 31)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 17 && y == 31)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 18 && y == 31)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 19 && y == 31)
        begin
            pixel_data <= 16'b01100_001101_10000;
        end
        else if (x == 20 && y == 31)
        begin
            pixel_data <= 16'b01100_001111_10010;
        end
        else if (x == 21 && y == 31)
        begin
            pixel_data <= 16'b01011_001101_10001;
        end
        else if (x == 22 && y == 31)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 23 && y == 31)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 24 && y == 31)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 25 && y == 31)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 26 && y == 31)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 27 && y == 31)
        begin
            pixel_data <= 16'b01011_001101_10001;
        end
        else if (x == 28 && y == 31)
        begin
            pixel_data <= 16'b01101_001110_10001;
        end
        else if (x == 29 && y == 31)
        begin
            pixel_data <= 16'b01100_001111_10010;
        end
        else if (x == 30 && y == 31)
        begin
            pixel_data <= 16'b01011_001101_10001;
        end
        else if (x == 31 && y == 31)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 32 && y == 31)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 33 && y == 31)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 34 && y == 31)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 35 && y == 31)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 36 && y == 31)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 37 && y == 31)
        begin
            pixel_data <= 16'b01100_001110_10001;
        end
        else if (x == 39 && y == 31)
        begin
            pixel_data <= 16'b01010_010110_11010;
        end
        else if (x == 40 && y == 31)
        begin
            pixel_data <= 16'b01000_010110_11100;
        end
        else if (x == 41 && y == 31)
        begin
            pixel_data <= 16'b01000_010110_11101;
        end
        else if (x == 42 && y == 31)
        begin
            pixel_data <= 16'b01000_010110_11100;
        end
        else if (x == 43 && y == 31)
        begin
            pixel_data <= 16'b01000_010110_11101;
        end
        else if (x == 44 && y == 31)
        begin
            pixel_data <= 16'b01000_010110_11101;
        end
        else if (x == 45 && y == 31)
        begin
            pixel_data <= 16'b01000_010110_11101;
        end
        else if (x == 46 && y == 31)
        begin
            pixel_data <= 16'b01000_010110_11100;
        end
        else if (x == 47 && y == 31)
        begin
            pixel_data <= 16'b01000_010110_11101;
        end
        else if (x == 48 && y == 31)
        begin
            pixel_data <= 16'b01000_010110_11101;
        end
        else if (x == 49 && y == 31)
        begin
            pixel_data <= 16'b01000_010110_11100;
        end
        else if (x == 50 && y == 31)
        begin
            pixel_data <= 16'b00111_010110_11101;
        end
        else if (x == 51 && y == 31)
        begin
            pixel_data <= 16'b00111_010110_11101;
        end
        else if (x == 52 && y == 31)
        begin
            pixel_data <= 16'b00111_010110_11101;
        end
        else if (x == 53 && y == 31)
        begin
            pixel_data <= 16'b01000_010110_11101;
        end
        else if (x == 54 && y == 31)
        begin
            pixel_data <= 16'b01000_010110_11100;
        end
        else if (x == 55 && y == 31)
        begin
            pixel_data <= 16'b01011_010110_11011;
        end
        else if (x == 56 && y == 31)
        begin
            pixel_data <= 16'b11111_011111_11111;
        end
        else if (x == 58 && y == 31)
        begin
            pixel_data <= 16'b01100_001110_10010;
        end
        else if (x == 59 && y == 31)
        begin
            pixel_data <= 16'b01011_001101_10001;
        end
        else if (x == 60 && y == 31)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 61 && y == 31)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 62 && y == 31)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 63 && y == 31)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 64 && y == 31)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 65 && y == 31)
        begin
            pixel_data <= 16'b01011_001101_10001;
        end
        else if (x == 66 && y == 31)
        begin
            pixel_data <= 16'b01100_001110_10010;
        end
        else if (x == 67 && y == 31)
        begin
            pixel_data <= 16'b01011_001110_10000;
        end
        else if (x == 68 && y == 31)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 69 && y == 31)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 70 && y == 31)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 71 && y == 31)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 72 && y == 31)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 73 && y == 31)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 74 && y == 31)
        begin
            pixel_data <= 16'b01011_001101_10001;
        end
        else if (x == 75 && y == 31)
        begin
            pixel_data <= 16'b01100_001110_10010;
        end
        else if (x == 76 && y == 31)
        begin
            pixel_data <= 16'b01101_001111_10001;
        end
        else if (x == 77 && y == 31)
        begin
            pixel_data <= 16'b01011_001101_10001;
        end
        else if (x == 78 && y == 31)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 79 && y == 31)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 80 && y == 31)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 81 && y == 31)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 82 && y == 31)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 83 && y == 31)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 12 && y == 32)
        begin
            pixel_data <= 16'b01101_001110_10010;
        end
        else if (x == 13 && y == 32)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 14 && y == 32)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 15 && y == 32)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 16 && y == 32)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 17 && y == 32)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 18 && y == 32)
        begin
            pixel_data <= 16'b01100_001110_10001;
        end
        else if (x == 19 && y == 32)
        begin
            pixel_data <= 16'b11111_011111_11111;
        end
        else if (x == 21 && y == 32)
        begin
            pixel_data <= 16'b01110_010000_10010;
        end
        else if (x == 22 && y == 32)
        begin
            pixel_data <= 16'b01011_001101_10001;
        end
        else if (x == 23 && y == 32)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 24 && y == 32)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 25 && y == 32)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 26 && y == 32)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 27 && y == 32)
        begin
            pixel_data <= 16'b01100_001110_10001;
        end
        else if (x == 28 && y == 32)
        begin
            pixel_data <= 16'b11111_011111_11111;
        end
        else if (x == 30 && y == 32)
        begin
            pixel_data <= 16'b01100_001111_10001;
        end
        else if (x == 31 && y == 32)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 32 && y == 32)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 33 && y == 32)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 34 && y == 32)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 35 && y == 32)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 36 && y == 32)
        begin
            pixel_data <= 16'b01100_001110_10001;
        end
        else if (x == 37 && y == 32)
        begin
            pixel_data <= 16'b11111_011111_11111;
        end
        else if (x == 39 && y == 32)
        begin
            pixel_data <= 16'b00000_011111_11111;
        end
        else if (x == 40 && y == 32)
        begin
            pixel_data <= 16'b01100_010111_11100;
        end
        else if (x == 41 && y == 32)
        begin
            pixel_data <= 16'b01101_010110_11010;
        end
        else if (x == 42 && y == 32)
        begin
            pixel_data <= 16'b01101_010110_11010;
        end
        else if (x == 43 && y == 32)
        begin
            pixel_data <= 16'b01101_010110_11010;
        end
        else if (x == 44 && y == 32)
        begin
            pixel_data <= 16'b01101_010110_11010;
        end
        else if (x == 45 && y == 32)
        begin
            pixel_data <= 16'b01101_010110_11010;
        end
        else if (x == 46 && y == 32)
        begin
            pixel_data <= 16'b01101_010110_11010;
        end
        else if (x == 47 && y == 32)
        begin
            pixel_data <= 16'b01101_010110_11010;
        end
        else if (x == 48 && y == 32)
        begin
            pixel_data <= 16'b01101_010110_11010;
        end
        else if (x == 49 && y == 32)
        begin
            pixel_data <= 16'b01100_010110_11011;
        end
        else if (x == 50 && y == 32)
        begin
            pixel_data <= 16'b01000_010110_11100;
        end
        else if (x == 51 && y == 32)
        begin
            pixel_data <= 16'b01000_010110_11101;
        end
        else if (x == 52 && y == 32)
        begin
            pixel_data <= 16'b01000_010110_11101;
        end
        else if (x == 53 && y == 32)
        begin
            pixel_data <= 16'b01000_010110_11100;
        end
        else if (x == 54 && y == 32)
        begin
            pixel_data <= 16'b01011_010110_11011;
        end
        else if (x == 59 && y == 32)
        begin
            pixel_data <= 16'b01110_001111_10001;
        end
        else if (x == 60 && y == 32)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 61 && y == 32)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 62 && y == 32)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 63 && y == 32)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 64 && y == 32)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 65 && y == 32)
        begin
            pixel_data <= 16'b01101_001111_10010;
        end
        else if (x == 66 && y == 32)
        begin
            pixel_data <= 16'b11111_011111_11111;
        end
        else if (x == 68 && y == 32)
        begin
            pixel_data <= 16'b01101_001110_10010;
        end
        else if (x == 69 && y == 32)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 70 && y == 32)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 71 && y == 32)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 72 && y == 32)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 73 && y == 32)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 74 && y == 32)
        begin
            pixel_data <= 16'b01101_001110_10010;
        end
        else if (x == 77 && y == 32)
        begin
            pixel_data <= 16'b01110_001111_10010;
        end
        else if (x == 78 && y == 32)
        begin
            pixel_data <= 16'b01011_001101_10001;
        end
        else if (x == 79 && y == 32)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 80 && y == 32)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 81 && y == 32)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 82 && y == 32)
        begin
            pixel_data <= 16'b01011_001101_10001;
        end
        else if (x == 83 && y == 32)
        begin
            pixel_data <= 16'b01101_001110_10001;
        end
        else if (x == 13 && y == 33)
        begin
            pixel_data <= 16'b01100_001101_10000;
        end
        else if (x == 14 && y == 33)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 15 && y == 33)
        begin
            pixel_data <= 16'b01011_001101_10001;
        end
        else if (x == 16 && y == 33)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 17 && y == 33)
        begin
            pixel_data <= 16'b01100_001110_10001;
        end
        else if (x == 22 && y == 33)
        begin
            pixel_data <= 16'b01101_001110_10001;
        end
        else if (x == 23 && y == 33)
        begin
            pixel_data <= 16'b01011_001101_10001;
        end
        else if (x == 24 && y == 33)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 25 && y == 33)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 26 && y == 33)
        begin
            pixel_data <= 16'b01101_001110_10001;
        end
        else if (x == 31 && y == 33)
        begin
            pixel_data <= 16'b01101_001110_10001;
        end
        else if (x == 32 && y == 33)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 33 && y == 33)
        begin
            pixel_data <= 16'b01011_001101_10001;
        end
        else if (x == 34 && y == 33)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 35 && y == 33)
        begin
            pixel_data <= 16'b01100_001110_10001;
        end
        else if (x == 49 && y == 33)
        begin
            pixel_data <= 16'b01100_010110_11010;
        end
        else if (x == 50 && y == 33)
        begin
            pixel_data <= 16'b01000_010110_11100;
        end
        else if (x == 51 && y == 33)
        begin
            pixel_data <= 16'b01000_010111_11110;
        end
        else if (x == 52 && y == 33)
        begin
            pixel_data <= 16'b01000_010110_11100;
        end
        else if (x == 53 && y == 33)
        begin
            pixel_data <= 16'b01011_010110_11011;
        end
        else if (x == 60 && y == 33)
        begin
            pixel_data <= 16'b01101_001111_10001;
        end
        else if (x == 61 && y == 33)
        begin
            pixel_data <= 16'b01011_001101_10001;
        end
        else if (x == 62 && y == 33)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 63 && y == 33)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 64 && y == 33)
        begin
            pixel_data <= 16'b01100_001110_10001;
        end
        else if (x == 69 && y == 33)
        begin
            pixel_data <= 16'b01101_001110_10010;
        end
        else if (x == 70 && y == 33)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 71 && y == 33)
        begin
            pixel_data <= 16'b01011_001101_10001;
        end
        else if (x == 72 && y == 33)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 73 && y == 33)
        begin
            pixel_data <= 16'b01100_001110_10001;
        end
        else if (x == 78 && y == 33)
        begin
            pixel_data <= 16'b01101_001111_10001;
        end
        else if (x == 79 && y == 33)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 80 && y == 33)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 81 && y == 33)
        begin
            pixel_data <= 16'b01011_001101_10001;
        end
        else if (x == 82 && y == 33)
        begin
            pixel_data <= 16'b01101_001111_10001;
        end
        else if (x == 14 && y == 34)
        begin
            pixel_data <= 16'b01100_001111_01111;
        end
        else if (x == 15 && y == 34)
        begin
            pixel_data <= 16'b01100_001111_10001;
        end
        else if (x == 16 && y == 34)
        begin
            pixel_data <= 16'b01011_001101_10000;
        end
        else if (x == 23 && y == 34)
        begin
            pixel_data <= 16'b01111_001111_10100;
        end
        else if (x == 24 && y == 34)
        begin
            pixel_data <= 16'b01011_001111_01111;
        end
        else if (x == 25 && y == 34)
        begin
            pixel_data <= 16'b01101_001101_10001;
        end
        else if (x == 32 && y == 34)
        begin
            pixel_data <= 16'b01100_001111_10010;
        end
        else if (x == 33 && y == 34)
        begin
            pixel_data <= 16'b01100_001111_10001;
        end
        else if (x == 34 && y == 34)
        begin
            pixel_data <= 16'b01011_001101_10000;
        end
        else if (x == 49 && y == 34)
        begin
            pixel_data <= 16'b01011_010101_11011;
        end
        else if (x == 50 && y == 34)
        begin
            pixel_data <= 16'b01000_010110_11100;
        end
        else if (x == 51 && y == 34)
        begin
            pixel_data <= 16'b01000_010110_11100;
        end
        else if (x == 52 && y == 34)
        begin
            pixel_data <= 16'b01011_010110_11011;
        end
        else if (x == 61 && y == 34)
        begin
            pixel_data <= 16'b01101_001101_10000;
        end
        else if (x == 62 && y == 34)
        begin
            pixel_data <= 16'b01100_001111_10001;
        end
        else if (x == 63 && y == 34)
        begin
            pixel_data <= 16'b01101_001101_10000;
        end
        else if (x == 70 && y == 34)
        begin
            pixel_data <= 16'b01111_001111_01111;
        end
        else if (x == 71 && y == 34)
        begin
            pixel_data <= 16'b01011_001111_01111;
        end
        else if (x == 72 && y == 34)
        begin
            pixel_data <= 16'b01111_001111_01111;
        end
        else if (x == 79 && y == 34)
        begin
            pixel_data <= 16'b01101_001101_10000;
        end
        else if (x == 80 && y == 34)
        begin
            pixel_data <= 16'b01011_001110_10000;
        end
        else if (x == 81 && y == 34)
        begin
            pixel_data <= 16'b01101_001101_10000;
        end
        else if (x == 23 && y == 35)
        begin
            pixel_data <= 16'b01100_001110_10010;
        end
        else if (x == 24 && y == 35)
        begin
            pixel_data <= 16'b01100_001110_10010;
        end
        else if (x == 25 && y == 35)
        begin
            pixel_data <= 16'b01100_001110_10001;
        end
        else if (x == 49 && y == 35)
        begin
            pixel_data <= 16'b01100_010110_11011;
        end
        else if (x == 50 && y == 35)
        begin
            pixel_data <= 16'b01001_010110_11100;
        end
        else if (x == 51 && y == 35)
        begin
            pixel_data <= 16'b01011_010110_11011;
        end
        else if (x == 70 && y == 35)
        begin
            pixel_data <= 16'b01101_001111_10001;
        end
        else if (x == 71 && y == 35)
        begin
            pixel_data <= 16'b01100_001110_10001;
        end
        else if (x == 72 && y == 35)
        begin
            pixel_data <= 16'b01100_001110_10010;
        end
        else if (x == 22 && y == 36)
        begin
            pixel_data <= 16'b01100_001110_10001;
        end
        else if (x == 23 && y == 36)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 24 && y == 36)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 25 && y == 36)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 26 && y == 36)
        begin
            pixel_data <= 16'b01100_001101_10000;
        end
        else if (x == 49 && y == 36)
        begin
            pixel_data <= 16'b00000_011111_11111;
        end
        else if (x == 50 && y == 36)
        begin
            pixel_data <= 16'b01101_011000_11011;
        end
        else if (x == 69 && y == 36)
        begin
            pixel_data <= 16'b01101_001110_10001;
        end
        else if (x == 70 && y == 36)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 71 && y == 36)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 72 && y == 36)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 73 && y == 36)
        begin
            pixel_data <= 16'b01100_001110_10001;
        end
        else if (x == 20 && y == 37)
        begin
            pixel_data <= 16'b01111_001111_01111;
        end
        else if (x == 21 && y == 37)
        begin
            pixel_data <= 16'b01100_001101_10000;
        end
        else if (x == 22 && y == 37)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 23 && y == 37)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 24 && y == 37)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 25 && y == 37)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 26 && y == 37)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 27 && y == 37)
        begin
            pixel_data <= 16'b01100_001101_10000;
        end
        else if (x == 28 && y == 37)
        begin
            pixel_data <= 16'b01010_010100_10100;
        end
        else if (x == 67 && y == 37)
        begin
            pixel_data <= 16'b01111_001111_01111;
        end
        else if (x == 68 && y == 37)
        begin
            pixel_data <= 16'b01100_001110_10001;
        end
        else if (x == 69 && y == 37)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 70 && y == 37)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 71 && y == 37)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 72 && y == 37)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 73 && y == 37)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 74 && y == 37)
        begin
            pixel_data <= 16'b01100_001110_10001;
        end
        else if (x == 75 && y == 37)
        begin
            pixel_data <= 16'b01010_001010_01010;
        end
        else if (x == 20 && y == 38)
        begin
            pixel_data <= 16'b01101_001111_10001;
        end
        else if (x == 21 && y == 38)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 22 && y == 38)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 23 && y == 38)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 24 && y == 38)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 25 && y == 38)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 26 && y == 38)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 27 && y == 38)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 28 && y == 38)
        begin
            pixel_data <= 16'b01101_001110_10000;
        end
        else if (x == 67 && y == 38)
        begin
            pixel_data <= 16'b01100_001101_10001;
        end
        else if (x == 68 && y == 38)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 69 && y == 38)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 70 && y == 38)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 71 && y == 38)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 72 && y == 38)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 73 && y == 38)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 74 && y == 38)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 75 && y == 38)
        begin
            pixel_data <= 16'b01100_001101_10001;
        end
        else if (x == 20 && y == 39)
        begin
            pixel_data <= 16'b01110_001110_10010;
        end
        else if (x == 21 && y == 39)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 22 && y == 39)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 23 && y == 39)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 24 && y == 39)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 25 && y == 39)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 26 && y == 39)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 27 && y == 39)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 28 && y == 39)
        begin
            pixel_data <= 16'b01100_001110_10001;
        end
        else if (x == 67 && y == 39)
        begin
            pixel_data <= 16'b01101_001110_10001;
        end
        else if (x == 68 && y == 39)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 69 && y == 39)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 70 && y == 39)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 71 && y == 39)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 72 && y == 39)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 73 && y == 39)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 74 && y == 39)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 75 && y == 39)
        begin
            pixel_data <= 16'b01100_001101_10000;
        end
        else if (x == 20 && y == 40)
        begin
            pixel_data <= 16'b01110_001110_10000;
        end
        else if (x == 21 && y == 40)
        begin
            pixel_data <= 16'b01011_001101_10001;
        end
        else if (x == 22 && y == 40)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 23 && y == 40)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 24 && y == 40)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 25 && y == 40)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 26 && y == 40)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 27 && y == 40)
        begin
            pixel_data <= 16'b01011_001101_10001;
        end
        else if (x == 28 && y == 40)
        begin
            pixel_data <= 16'b01100_001101_10010;
        end
        else if (x == 67 && y == 40)
        begin
            pixel_data <= 16'b01011_001101_10001;
        end
        else if (x == 68 && y == 40)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 69 && y == 40)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 70 && y == 40)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 71 && y == 40)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 72 && y == 40)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 73 && y == 40)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 74 && y == 40)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 75 && y == 40)
        begin
            pixel_data <= 16'b01100_001101_10001;
        end
        else if (x == 21 && y == 41)
        begin
            pixel_data <= 16'b01101_001111_10001;
        end
        else if (x == 22 && y == 41)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 23 && y == 41)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 24 && y == 41)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 25 && y == 41)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 26 && y == 41)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 27 && y == 41)
        begin
            pixel_data <= 16'b01100_001110_10001;
        end
        else if (x == 68 && y == 41)
        begin
            pixel_data <= 16'b01101_001110_10001;
        end
        else if (x == 69 && y == 41)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 70 && y == 41)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 71 && y == 41)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 72 && y == 41)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 73 && y == 41)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 74 && y == 41)
        begin
            pixel_data <= 16'b01101_010000_10001;
        end
        else if (x == 22 && y == 42)
        begin
            pixel_data <= 16'b01101_001110_10001;
        end
        else if (x == 23 && y == 42)
        begin
            pixel_data <= 16'b01011_001101_10001;
        end
        else if (x == 24 && y == 42)
        begin
            pixel_data <= 16'b01100_001110_10010;
        end
        else if (x == 25 && y == 42)
        begin
            pixel_data <= 16'b01010_001101_10001;
        end
        else if (x == 26 && y == 42)
        begin
            pixel_data <= 16'b01100_001110_10000;
        end
        else if (x == 69 && y == 42)
        begin
            pixel_data <= 16'b01110_010000_10001;
        end
        else if (x == 70 && y == 42)
        begin
            pixel_data <= 16'b01011_001101_10001;
        end
        else if (x == 71 && y == 42)
        begin
            pixel_data <= 16'b01011_001110_10001;
        end
        else if (x == 72 && y == 42)
        begin
            pixel_data <= 16'b01011_001101_10001;
        end
        else if (x == 73 && y == 42)
        begin
            pixel_data <= 16'b01101_001111_10001;
        end
        
        // selection
        else if (is_rectangle_border(x, y, rectangle_border_x, rectangle_border_y, rectangle_border_a, rectangle_border_b)) pixel_data <= rectangle_border;
        
        else pixel_data <= background;
    end
endmodule
