`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.03.2024 17:09:14
// Design Name: 
// Module Name: settings_menu
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


module settings_menu(
    input clk,
    input [12:0] pixel_index,
    output reg [15:0] pixel_data,
    input btnC, btnU, btnL, btnR, btnD,
    output reg clicked_back = 0,
    output reg [4:0] volume_level = 5
);
    reg [15:0] background = 16'b11100_100101_00111;
    reg [15:0] title_text = 16'b00111_000000_00010;
    reg [15:0] back_text = 16'b01101_010010_00010;
    reg [15:0] rectangle_border = 16'b10011_100111_10011;
    reg [15:0] volume_slider_border = 16'b00001_000110_00011;
    reg [15:0] volume_slider_full = 16'b00000_011110_11011;
    reg [15:0] volume_slider_empty = 16'b01100_011010_01101;
    reg [15:0] volume_slider_cursor = 16'b11110_111110_11101;
    
    wire clk_25m, clk_1000;
    flexible_clock_module flexible_clock_module_25m (
        .basys_clock(clk),
        .my_m_value(1),
        .my_clk(clk_25m)
    );
    flexible_clock_module flexible_clock_module_1000 (
        .basys_clock(clk),
        .my_m_value(49999),
        .my_clk(clk_1000)
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
    
    reg [7:0] volume_slider_origin_x = 48;
    reg [7:0] volume_slider_origin_y = 32;
    reg [7:0] width = 30;
    reg [7:0] height = 6;
    function is_volume_slider_border;
        input [7:0] curr_x;
        input [7:0] curr_y;
        begin
            is_volume_slider_border = 0;
    
            if (curr_y == volume_slider_origin_y + height / 2 ||
                curr_y == volume_slider_origin_y - height / 2)
                begin
                    if (curr_x >= volume_slider_origin_x - width / 2 &&
                        curr_x <= volume_slider_origin_x + width / 2)
                        begin
                            is_volume_slider_border = 1;
                        end
                end
            else if (curr_x == volume_slider_origin_x + width / 2 ||
                    curr_x == volume_slider_origin_x - width / 2)
                    begin
                        if (curr_y >= volume_slider_origin_y - height / 2 &&
                            curr_y <= volume_slider_origin_y + height / 2)
                            begin
                                is_volume_slider_border = 1;
                            end
                    end
        end
    endfunction
    
    function is_rectangle;
        input [7:0] curr_x;
        input [7:0] curr_y;
        input [7:0] origin_x;
        input [7:0] origin_y;
        input [7:0] width;
        input [7:0] length;
        begin
            is_rectangle = 0;
            
            if (curr_x >= origin_x &&
                curr_x < origin_x + width &&
                curr_y >= origin_y && 
                curr_y < origin_y + length)
                begin
                    is_rectangle = 1;
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
    
    // selection at back
    reg [7:0] select_back_x = 48;
    reg [7:0] select_back_y = 54;
    reg [7:0] select_back_a = 14;
    reg [7:0] select_back_b = 5;
    
    // selection at slider
    reg [7:0] select_slider_x = 48;
    reg [7:0] select_slider_y = 32;
    reg [7:0] select_slider_a = 17;
    reg [7:0] select_slider_b = 4;
        
    reg [7:0] rectangle_border_x = 128;
    reg [7:0] rectangle_border_y = 128;
    reg [7:0] rectangle_border_a = 128;
    reg [7:0] rectangle_border_b = 128;
    
    always @ (posedge clk)
    begin
        if (rectangle_border_y == 128 && btnU)
            begin
                rectangle_border_x = select_slider_x;
                rectangle_border_y = select_slider_y;
                rectangle_border_a = select_slider_a;
                rectangle_border_b = select_slider_b;
            end
        else if (rectangle_border_y == 128 && btnD)
            begin
                rectangle_border_x = select_back_x;
                rectangle_border_y = select_back_y;
                rectangle_border_a = select_back_a;
                rectangle_border_b = select_back_b;
            end
        else if (rectangle_border_y == select_back_y && btnU)
            begin
                rectangle_border_x = select_slider_x;
                rectangle_border_y = select_slider_y;
                rectangle_border_a = select_slider_a;
                rectangle_border_b = select_slider_b;
            end
        else if (rectangle_border_y == select_slider_y && btnD)
            begin
                rectangle_border_x = select_back_x;
                rectangle_border_y = select_back_y;
                rectangle_border_a = select_back_a;
                rectangle_border_b = select_back_b;
            end
        
        if (rectangle_border_y == select_back_y && btnC)
            begin
                clicked_back = 1;
                rectangle_border_x = 128;
                rectangle_border_y = 128;
                rectangle_border_a = 128;
                rectangle_border_b = 128;
            end
        else
            begin
                clicked_back = 0;
            end
    end
    
    reg [7:0] volume_slider_cursor_x;
    reg [7:0] volume_slider_cursor_y;
    initial
    begin
        volume_slider_cursor_x = 48;
        volume_slider_cursor_y = 30;
    end
    always @ (posedge clk_1000)
    begin
        if (rectangle_border_y == select_slider_y && btnR && volume_slider_cursor_x < 60)
            begin
                volume_slider_cursor_x <= volume_slider_cursor_x + 3;
                volume_level <= volume_level + 1;
            end
        else if (rectangle_border_y == select_slider_y && btnL && volume_slider_cursor_x > 35)
            begin
                volume_slider_cursor_x <= volume_slider_cursor_x - 3;
                volume_level <= volume_level - 1;
            end
    end
    
    reg [7:0] x, y;
    always @ (posedge clk_25m)
    begin
        x = pixel_index % 96;
        y = pixel_index / 96;
        
        // SETTINGS
        if (is_char(x, y, 8, 8, 83)) pixel_data <= title_text;
        else if (is_char(x, y, 13, 8, 69)) pixel_data <= title_text;
        else if (is_char(x, y, 18, 8, 84)) pixel_data <= title_text;
        else if (is_char(x, y, 23, 8, 84)) pixel_data <= title_text;
        else if (is_char(x, y, 28, 8, 73)) pixel_data <= title_text;
        else if (is_char(x, y, 30, 8, 78)) pixel_data <= title_text;
        else if (is_char(x, y, 35, 8, 71)) pixel_data <= title_text;
        else if (is_char(x, y, 41, 8, 83)) pixel_data <= title_text;
        
        // BACK
        else if (is_char(x, y, 39, 52, 66)) pixel_data <= back_text;
        else if (is_char(x, y, 44, 52, 65)) pixel_data <= back_text;
        else if (is_char(x, y, 49, 52, 67)) pixel_data <= back_text;
        else if (is_char(x, y, 54, 52, 75)) pixel_data <= back_text;
        
        // volume slider
        else if (is_volume_slider_border(x, y)) pixel_data <= volume_slider_border;
        else if (is_rectangle(x, y, volume_slider_cursor_x, volume_slider_cursor_y, 2, height)) pixel_data <= volume_slider_cursor;
        else if (is_rectangle(x, y, volume_slider_origin_x - width / 2, volume_slider_cursor_y, volume_slider_cursor_x - (volume_slider_origin_x - width / 2), height)) pixel_data <= volume_slider_full;
        else if (is_rectangle(x, y, volume_slider_cursor_x + 2, volume_slider_cursor_y, volume_slider_origin_x + width / 2 - volume_slider_cursor_x, height)) pixel_data <= volume_slider_empty;
        
        // selection
        else if (is_rectangle_border(x, y, rectangle_border_x, rectangle_border_y, rectangle_border_a, rectangle_border_b)) pixel_data <= rectangle_border;
        
        else pixel_data <= background;
    end
    
endmodule
