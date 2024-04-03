`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.03.2024 19:46:08
// Design Name: 
// Module Name: game_over_menu
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


module game_over_menu(
    input clk,
    input [12:0] pixel_index,
    output reg [15:0] pixel_data,
    input is_win,
    input btnC, btnL, btnR,
    output reg clicked_home, clicked_settings
);
    reg [15:0] background = 16'b11100_100101_00111;
    reg [15:0] title_text = 16'b00111_000000_00010;
    reg [15:0] home_text = 16'b01101_010010_00010;
    reg [15:0] settings_gear = 16'b00110_100011_01000;
    reg [15:0] rectangle_border = 16'b10011_100111_10011;
    
    wire clk_25m, clk_10;
    flexible_clock_module flexible_clock_module_25m (
        .basys_clock(clk),
        .my_m_value(1),
        .my_clk(clk_25m)
    );
    flexible_clock_module flexible_clock_module_10 (
        .basys_clock(clk),
        .my_m_value(4999999),
        .my_clk(clk_10)
    );
    
    reg [7:0] a = 5;
    reg [7:0] b = 1;
    reg [7:0] c = 5;
    reg [7:0] n = 6;
    function is_gear;
        input [7:0] curr_x;
        input [7:0] curr_y;
        input [7:0] center_x;
        input [7:0] center_y;
        real theta;
        integer index, i;
        reg [7:0] x_lut [0:63];
        reg [7:0] y_lut [0:63];
        
        begin
            index = 0;
            for (theta = 0; theta <= 3.141592 * 2; theta = theta + 0.1)
            begin
                x_lut[index] = (a + (1.0 / b) * $tanh(c * $sin(n * theta))) * $cos(theta);
                y_lut[index] = (a + (1.0 / b) * $tanh(c * $sin(n * theta))) * $sin(theta);
                
                index = index + 1;
            end
            
            is_gear = 0;
            for (i = 0; i < index; i = i + 1)
            begin
                if (curr_x == center_x + x_lut[i] && curr_y == center_y + y_lut[i])
                begin
                    is_gear = 1;
                end
            end
        end
    endfunction
    
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
    
    reg [7:0] origin_y = 12;
    reg [7:0] amplitude = 5;
    reg [7:0] frequency = 1;
    reg [7:0] phase = 0;
    function [7:0] simple_harmonic_motion;
        input [7:0] counter;
        integer i;
        real t;
        reg [7:0] sine_lut [0:96];
        begin
            i = 0;
            for (t = 0; t <= 1; t = t + 0.05)
                begin
                    sine_lut[i] = amplitude * $sin(2 * 3.141592 * frequency * t + phase);
                    i = i + 1;
                end
            simple_harmonic_motion = origin_y + sine_lut[counter];
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
    
    // selection at home
    reg [7:0] select_home_x = 32;
    reg [7:0] select_home_y = 54;
    reg [7:0] select_home_a = 13;
    reg [7:0] select_home_b = 5;
    
    // selection at settings
    reg [7:0] select_settings_x = 64;
    reg [7:0] select_settings_y = 54;
    reg [7:0] select_settings_a = 7;
    reg [7:0] select_settings_b = 7;
    
    reg [7:0] rectangle_border_x = 128;
    reg [7:0] rectangle_border_y = 128;
    reg [7:0] rectangle_border_a = 128;
    reg [7:0] rectangle_border_b = 128;
        
    always @ (posedge clk)
    begin
        if (rectangle_border_x == 128 && btnL)
            begin
                rectangle_border_x = select_home_x;
                rectangle_border_y = select_home_y;
                rectangle_border_a = select_home_a;
                rectangle_border_b = select_home_b;
            end
        else if (rectangle_border_x == 128 && btnR)
            begin
                rectangle_border_x = select_settings_x;
                rectangle_border_y = select_settings_y;
                rectangle_border_a = select_settings_a;
                rectangle_border_b = select_settings_b;
            end
        else if (rectangle_border_x == select_home_x && btnR)
            begin
                rectangle_border_x = select_settings_x;
                rectangle_border_y = select_settings_y;
                rectangle_border_a = select_settings_a;
                rectangle_border_b = select_settings_b;
            end
        else if (rectangle_border_x == select_settings_x && btnL)
            begin
                rectangle_border_x = select_home_x;
                rectangle_border_y = select_home_y;
                rectangle_border_a = select_home_a;
                rectangle_border_b = select_home_b;
            end
        
        if (rectangle_border_x == select_home_x && btnC)
            begin
                clicked_home = 1;
                rectangle_border_x = 128;
                rectangle_border_y = 128;
                rectangle_border_a = 128;
                rectangle_border_b = 128;
            end
        else
            begin
                clicked_home = 0;
            end
            
        if (rectangle_border_x == select_settings_x && btnC)
            begin
                clicked_settings = 1;
                rectangle_border_x = 128;
                rectangle_border_y = 128;
                rectangle_border_a = 128;
                rectangle_border_b = 128;
            end
        else
            begin
                clicked_settings = 0;
            end
    end
    
    reg [7:0] simple_harmonic_counter = 0;
    always @ (posedge clk_10)
    begin
        simple_harmonic_counter <= (simple_harmonic_counter + 1) % 20;
    end
    
    
    reg [7:0] x, y;
    always @ (posedge clk_25m)
    begin
        x = pixel_index % 96;
        y = pixel_index / 96;
        
        // "HOME"
        if (is_char(x, y, 23, 52, 72)) pixel_data <= home_text;
        else if (is_char(x, y, 28, 52, 79)) pixel_data <= home_text;
        else if (is_char(x, y, 33, 52, 77)) pixel_data <= home_text;
        else if (is_char(x, y, 38, 52, 69)) pixel_data <= home_text;
        
        // "GAME OVER"
        else if (is_char(x, y, 27, simple_harmonic_motion(simple_harmonic_counter), 71)) pixel_data <= title_text;
        else if (is_char(x, y, 32, simple_harmonic_motion((simple_harmonic_counter + 2) % 20), 65)) pixel_data <= title_text;
        else if (is_char(x, y, 37, simple_harmonic_motion((simple_harmonic_counter + 4) % 20), 77)) pixel_data <= title_text;
        else if (is_char(x, y, 43, simple_harmonic_motion((simple_harmonic_counter + 6) % 20), 69)) pixel_data <= title_text;
        
        else if (is_char(x, y, 53, simple_harmonic_motion((simple_harmonic_counter + 10) % 20), 79)) pixel_data <= title_text;
        else if (is_char(x, y, 58, simple_harmonic_motion((simple_harmonic_counter + 12) % 20), 86)) pixel_data <= title_text;
        else if (is_char(x, y, 64, simple_harmonic_motion((simple_harmonic_counter + 14) % 20), 69)) pixel_data <= title_text;
        else if (is_char(x, y, 69, simple_harmonic_motion((simple_harmonic_counter + 16) % 20), 82)) pixel_data <= title_text;
        
        // "YOU WIN"
        else if (is_char(x, y, 33, 32, 89)) pixel_data <= title_text;
        else if (is_char(x, y, 38, 32, 79)) pixel_data <= title_text;
        else if (is_char(x, y, 43, 32, 85)) pixel_data <= title_text;
        
        else if (is_char(x, y, 53, 32, is_win ? 87 : 76)) pixel_data <= title_text;
        else if (is_char(x, y, is_win ? 59 : 58, 32, is_win ? 73 : 79)) pixel_data <= title_text;
        else if (is_char(x, y, is_win ? 62 : 63, 32, is_win ? 78 : 83)) pixel_data <= title_text;
        else if (is_char(x, y, is_win ? 68 : 68, 32, is_win ? 0 : 69)) pixel_data <= title_text;
        
        // selection
        else if (is_rectangle_border(x, y, rectangle_border_x, rectangle_border_y, rectangle_border_a, rectangle_border_b)) pixel_data <= rectangle_border;
                
        // settings gear
        else if (is_gear(x, y, 64, 54)) pixel_data <= settings_gear;
        
        else pixel_data <= background;
    end
endmodule