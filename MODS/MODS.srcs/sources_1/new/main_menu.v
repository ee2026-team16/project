`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.03.2024 19:05:09
// Design Name: 
// Module Name: main_menu
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

module main_menu(
    input clk,
    input [12:0] pixel_index,
    output reg [15:0] pixel_data,
    input btnC, btnL, btnR,
    output reg clicked_start, clicked_settings
);
    reg [15:0] background = 16'b11100_100101_00111;
    reg [15:0] title_text = 16'b00111_000000_00010;
    reg [15:0] start_text = 16'b01101_010010_00010;
    reg [15:0] settings_gear = 16'b00110_100011_01000;
    reg [15:0] rectangle_border = 16'b10011_100111_10011;
//    reg [15:0] mole_body = 16'b01111_010110_01000;
//    reg [15:0] mole_eye = 16'b0;
    reg [15:0] fire = 16'b11100_001010_00000;
    reg [15:0] bomb = 16'b0;
    reg [15:0] bomb_fuse = 16'b01110_011101_01110;
    reg [15:0] bomb_fire = 16'b11100_001010_00000;

    wire clk_25m;
    flexible_clock_module flexible_clock_module_25m (
        .basys_clock(clk),
        .my_m_value(1),
        .my_clk(clk_25m)
    );
    
//    function is_mole;
//        input [7:0] curr_x;
//        input [7:0] curr_y;
//        input [7:0] origin_x;
//        input [7:0] origin_y;
//        begin
//            if ((curr_y >= origin_y) &&
//                (curr_y < origin_y + 16) &&
//                (curr_x >= origin_x) &&
//                (curr_x < origin_x + 12))
//                is_mole = 1;
//            else
//                is_mole = 0;
//        end
//    endfunction
    
//    function is_mole_eye;
//        input [7:0] curr_x;
//        input [7:0] curr_y;
//        input [7:0] origin_x;
//        input [7:0] origin_y;
//        begin
//            if ((curr_y == origin_y) && (curr_x == origin_x || curr_x == origin_x + 4))
//                is_mole_eye = 1;
//            else
//                is_mole_eye = 0;
//        end
//    endfunction
            
    reg [7:0] bomb_radius = 8;
    function is_bomb;
        input [7:0] curr_x;
        input [7:0] curr_y;
        input [7:0] center_x;
        input [7:0] center_y;
        integer distance_sq;
    
        begin
            distance_sq = (curr_x - center_x)**2 + (curr_y - center_y)**2;
            if (distance_sq <= bomb_radius**2)
                is_bomb = 1;
            else
                is_bomb = 0;
        end
    endfunction
    
    reg [7:0] bomb_fuse_amplitude = 5;
    reg [7:0] bomb_fuse_period = 12;
    function is_bomb_fuse;
        input [7:0] curr_x;
        input [7:0] curr_y;
        input [7:0] origin_x;
        input [7:0] origin_y;
        integer i;
        reg [7:0] sine_lut [0:96];
        
        begin
            // sine lut
            for (i = 0; i <= bomb_fuse_period; i = i + 1)
                begin
                    sine_lut[i] = bomb_fuse_amplitude * ($sin(2 * 3.141592 * i / bomb_fuse_period));
                end
                   
            is_bomb_fuse = 0;
            for (i = 0; i < bomb_fuse_period; i = i + 1)
            begin
                if (curr_x == origin_x + i)
                begin
                    // piecewise linear interpolation
                    if ((origin_y - sine_lut[i] <= origin_y - sine_lut[i + 1] && curr_y >= origin_y - sine_lut[i] && curr_y < origin_y - sine_lut[i + 1]) ||
                        (origin_y - sine_lut[i] > origin_y - sine_lut[i + 1] && curr_y >= origin_y - sine_lut[i + 1] && curr_y < origin_y - sine_lut[i]))
                    begin
                        is_bomb_fuse = 1;
                    end
                end
            end
        end
    endfunction
    
    reg [7:0] bomb_fire_amplitude = 10;
    function is_bomb_fire;
        input [7:0] curr_x;
        input [7:0] curr_y;
        input [7:0] origin_x;
        input [7:0] origin_y;
        real i;
        integer index;
        reg [7:0] x_lut [0:20];
        reg [7:0] y_lut [0:20];
        reg [7:0] x_prev, y_prev;
        reg [7:0] x_curr, y_curr;
        integer winding_number;
        
        begin
            for (index = 0; index <= 20; index = index + 1)
            begin
                i = -1.0 + (index * 0.1);
                x_lut[index] = bomb_fire_amplitude * i * (i * i - 1);
                y_lut[index] = bomb_fire_amplitude * i * i + bomb_fire_amplitude;
            end
            
            winding_number = 0;
            for (index = 0; index < 20; index = index + 1)
            begin
                // winding number line segments
                x_prev = origin_x + x_lut[index];
                y_prev = origin_y - y_lut[index];
                x_curr = origin_x + x_lut[index + 1];
                y_curr = origin_y - y_lut[index + 1];
                
                // winding number ray
                if ((y_prev <= curr_y && y_curr > curr_y) || (y_prev > curr_y && y_curr <= curr_y)) begin
                    if (curr_x < (x_curr - x_prev) * (curr_y - y_prev) / (y_curr - y_prev) + x_prev)
                        winding_number = winding_number + 1;
                end
            end
            
            // odd winding number = point inside curve
            is_bomb_fire = (winding_number % 2 == 1);
        end
    endfunction
    
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
    
    // selection at start
    reg [7:0] select_start_x = 34;
    reg [7:0] select_start_y = 54;
    reg [7:0] select_start_a = 14;
    reg [7:0] select_start_b = 5;
    
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
                rectangle_border_x = select_start_x;
                rectangle_border_y = select_start_y;
                rectangle_border_a = select_start_a;
                rectangle_border_b = select_start_b;
            end
        else if (rectangle_border_x == 128 && btnR)
            begin
                rectangle_border_x = select_settings_x;
                rectangle_border_y = select_settings_y;
                rectangle_border_a = select_settings_a;
                rectangle_border_b = select_settings_b;
            end
        else if (rectangle_border_x == select_start_x && btnR)
            begin
                rectangle_border_x = select_settings_x;
                rectangle_border_y = select_settings_y;
                rectangle_border_a = select_settings_a;
                rectangle_border_b = select_settings_b;
            end
        else if (rectangle_border_x == select_settings_x && btnL)
            begin
                rectangle_border_x = select_start_x;
                rectangle_border_y = select_start_y;
                rectangle_border_a = select_start_a;
                rectangle_border_b = select_start_b;
            end
        
        if (rectangle_border_x == select_start_x && btnC)
            begin
                clicked_start = 1;
                rectangle_border_x = 128;
                rectangle_border_y = 128;
                rectangle_border_a = 128;
                rectangle_border_b = 128;
            end
        else
            begin
                clicked_start = 0;
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
    
    reg [7:0] x, y;
    always @ (posedge clk_25m)
    begin
        x = pixel_index % 96;
        y = pixel_index / 96;
        
        // "WHACK-A-MOLE
        if (is_char(x, y, 8, 8, 87)) pixel_data <= title_text;
        else if (is_char(x, y, 13, 8, 72)) pixel_data <= title_text;
        else if (is_char(x, y, 18, 8, 65)) pixel_data <= title_text;
        else if (is_char(x, y, 23, 8, 67)) pixel_data <= title_text;
        else if (is_char(x, y, 28, 8, 75)) pixel_data <= title_text;
        else if (is_char(x, y, 33, 8, 45)) pixel_data <= title_text;
        else if (is_char(x, y, 38, 8, 65)) pixel_data <= title_text;
        else if (is_char(x, y, 43, 8, 45)) pixel_data <= title_text;
        else if (is_char(x, y, 48, 8, 77)) pixel_data <= title_text;
        else if (is_char(x, y, 53, 8, 79)) pixel_data <= title_text;
        else if (is_char(x, y, 58, 8, 76)) pixel_data <= title_text;
        else if (is_char(x, y, 63, 8, 69)) pixel_data <= title_text;
        
        // "START"
        else if (is_char(x, y, 23, 52, 83)) pixel_data <= start_text;
        else if (is_char(x, y, 28, 52, 84)) pixel_data <= start_text;
        else if (is_char(x, y, 33, 52, 65)) pixel_data <= start_text;
        else if (is_char(x, y, 38, 52, 82)) pixel_data <= start_text;
        else if (is_char(x, y, 43, 52, 84)) pixel_data <= start_text;
        
        // selection
        else if (is_rectangle_border(x, y, rectangle_border_x, rectangle_border_y, rectangle_border_a, rectangle_border_b)) pixel_data <= rectangle_border;
        
        // settings gear
        else if (is_gear(x, y, 64, 54)) pixel_data <= settings_gear;
        
        // mole 1
        else if (x == 18 && y == 24)
        begin
            pixel_data <= 16'b00011_000011_00011;
        end
        else if (x == 19 && y == 24)
        begin
            pixel_data <= 16'b00011_000011_00011;
        end
        else if (x == 20 && y == 24)
        begin
            pixel_data <= 16'b00011_000011_00011;
        end
        else if (x == 21 && y == 24)
        begin
            pixel_data <= 16'b00011_000011_00011;
        end
        else if (x == 15 && y == 25)
        begin
            pixel_data <= 16'b00001_000001_00001;
        end
        else if (x == 16 && y == 25)
        begin
            pixel_data <= 16'b00011_000011_00011;
        end
        else if (x == 17 && y == 25)
        begin
            pixel_data <= 16'b00101_000101_00101;
        end
        else if (x == 18 && y == 25)
        begin
            pixel_data <= 16'b10100_010100_10100;
        end
        else if (x == 19 && y == 25)
        begin
            pixel_data <= 16'b10101_010101_10101;
        end
        else if (x == 20 && y == 25)
        begin
            pixel_data <= 16'b10101_010101_10101;
        end
        else if (x == 21 && y == 25)
        begin
            pixel_data <= 16'b10011_010011_10011;
        end
        else if (x == 22 && y == 25)
        begin
            pixel_data <= 16'b00100_000100_00100;
        end
        else if (x == 23 && y == 25)
        begin
            pixel_data <= 16'b00011_000011_00011;
        end
        else if (x == 24 && y == 25)
        begin
            pixel_data <= 16'b00010_000010_00010;
        end
        else if (x == 15 && y == 26)
        begin
            pixel_data <= 16'b00010_000010_00010;
        end
        else if (x == 16 && y == 26)
        begin
            pixel_data <= 16'b10011_010011_10011;
        end
        else if (x == 17 && y == 26)
        begin
            pixel_data <= 16'b10001_010001_10001;
        end
        else if (x == 18 && y == 26)
        begin
            pixel_data <= 16'b10010_010010_10010;
        end
        else if (x == 19 && y == 26)
        begin
            pixel_data <= 16'b10101_010101_10101;
        end
        else if (x == 20 && y == 26)
        begin
            pixel_data <= 16'b10101_010101_10101;
        end
        else if (x == 21 && y == 26)
        begin
            pixel_data <= 16'b10010_010010_10010;
        end
        else if (x == 22 && y == 26)
        begin
            pixel_data <= 16'b10010_010010_10010;
        end
        else if (x == 23 && y == 26)
        begin
            pixel_data <= 16'b10010_010010_10010;
        end
        else if (x == 24 && y == 26)
        begin
            pixel_data <= 16'b00001_000001_00001;
        end
        else if (x == 14 && y == 27)
        begin
            pixel_data <= 16'b00001_000001_00001;
        end
        else if (x == 15 && y == 27)
        begin
            pixel_data <= 16'b00101_000101_00101;
        end
        else if (x == 16 && y == 27)
        begin
            pixel_data <= 16'b10011_010011_10011;
        end
        else if (x == 17 && y == 27)
        begin
            pixel_data <= 16'b00101_000101_00101;
        end
        else if (x == 18 && y == 27)
        begin
            pixel_data <= 16'b00010_000010_00010;
        end
        else if (x == 19 && y == 27)
        begin
            pixel_data <= 16'b10100_010100_10100;
        end
        else if (x == 20 && y == 27)
        begin
            pixel_data <= 16'b10100_010100_10100;
        end
        else if (x == 21 && y == 27)
        begin
            pixel_data <= 16'b00101_000101_00101;
        end
        else if (x == 22 && y == 27)
        begin
            pixel_data <= 16'b00010_000010_00010;
        end
        else if (x == 23 && y == 27)
        begin
            pixel_data <= 16'b10010_010010_10010;
        end
        else if (x == 24 && y == 27)
        begin
            pixel_data <= 16'b00100_000100_00100;
        end
        else if (x == 25 && y == 27)
        begin
            pixel_data <= 16'b00001_000001_00001;
        end
        else if (x == 14 && y == 28)
        begin
            pixel_data <= 16'b00010_000010_00010;
        end
        else if (x == 15 && y == 28)
        begin
            pixel_data <= 16'b10011_010011_10011;
        end
        else if (x == 16 && y == 28)
        begin
            pixel_data <= 16'b10111_010111_10111;
        end
        else if (x == 17 && y == 28)
        begin
            pixel_data <= 16'b11001_011001_11001;
        end
        else if (x == 18 && y == 28)
        begin
            pixel_data <= 16'b00110_000110_00110;
        end
        else if (x == 19 && y == 28)
        begin
            pixel_data <= 16'b10100_010100_10100;
        end
        else if (x == 20 && y == 28)
        begin
            pixel_data <= 16'b10111_010111_10111;
        end
        else if (x == 21 && y == 28)
        begin
            pixel_data <= 16'b11001_011001_11001;
        end
        else if (x == 22 && y == 28)
        begin
            pixel_data <= 16'b00110_000110_00110;
        end
        else if (x == 23 && y == 28)
        begin
            pixel_data <= 16'b10100_010100_10100;
        end
        else if (x == 24 && y == 28)
        begin
            pixel_data <= 16'b10011_010011_10011;
        end
        else if (x == 25 && y == 28)
        begin
            pixel_data <= 16'b00001_000001_00001;
        end
        else if (x == 14 && y == 29)
        begin
            pixel_data <= 16'b00010_000010_00010;
        end
        else if (x == 15 && y == 29)
        begin
            pixel_data <= 16'b10100_010100_10100;
        end
        else if (x == 16 && y == 29)
        begin
            pixel_data <= 16'b10110_010110_10110;
        end
        else if (x == 17 && y == 29)
        begin
            pixel_data <= 16'b10110_010110_10110;
        end
        else if (x == 18 && y == 29)
        begin
            pixel_data <= 16'b10010_010010_10010;
        end
        else if (x == 19 && y == 29)
        begin
            pixel_data <= 16'b10010_010010_10010;
        end
        else if (x == 20 && y == 29)
        begin
            pixel_data <= 16'b10010_010010_10010;
        end
        else if (x == 21 && y == 29)
        begin
            pixel_data <= 16'b10011_010011_10011;
        end
        else if (x == 22 && y == 29)
        begin
            pixel_data <= 16'b10101_010101_10101;
        end
        else if (x == 23 && y == 29)
        begin
            pixel_data <= 16'b10110_010110_10110;
        end
        else if (x == 24 && y == 29)
        begin
            pixel_data <= 16'b10100_010100_10100;
        end
        else if (x == 25 && y == 29)
        begin
            pixel_data <= 16'b00001_000001_00001;
        end
        else if (x == 14 && y == 30)
        begin
            pixel_data <= 16'b00010_000010_00010;
        end
        else if (x == 15 && y == 30)
        begin
            pixel_data <= 16'b10100_010100_10100;
        end
        else if (x == 16 && y == 30)
        begin
            pixel_data <= 16'b10110_010110_10110;
        end
        else if (x == 17 && y == 30)
        begin
            pixel_data <= 16'b10001_010001_10001;
        end
        else if (x == 18 && y == 30)
        begin
            pixel_data <= 16'b00110_000100_00101;
        end
        else if (x == 19 && y == 30)
        begin
            pixel_data <= 16'b00101_000100_00100;
        end
        else if (x == 20 && y == 30)
        begin
            pixel_data <= 16'b00101_000100_00100;
        end
        else if (x == 21 && y == 30)
        begin
            pixel_data <= 16'b00110_000101_00101;
        end
        else if (x == 22 && y == 30)
        begin
            pixel_data <= 16'b10010_010010_10010;
        end
        else if (x == 23 && y == 30)
        begin
            pixel_data <= 16'b10110_010110_10110;
        end
        else if (x == 24 && y == 30)
        begin
            pixel_data <= 16'b10011_010011_10011;
        end
        else if (x == 25 && y == 30)
        begin
            pixel_data <= 16'b00001_000001_00001;
        end
        else if (x == 14 && y == 31)
        begin
            pixel_data <= 16'b00010_000010_00010;
        end
        else if (x == 15 && y == 31)
        begin
            pixel_data <= 16'b10100_010100_10100;
        end
        else if (x == 16 && y == 31)
        begin
            pixel_data <= 16'b10100_010100_10100;
        end
        else if (x == 17 && y == 31)
        begin
            pixel_data <= 16'b00111_000110_00110;
        end
        else if (x == 18 && y == 31)
        begin
            pixel_data <= 16'b10111_001111_10000;
        end
        else if (x == 19 && y == 31)
        begin
            pixel_data <= 16'b11000_010000_10001;
        end
        else if (x == 20 && y == 31)
        begin
            pixel_data <= 16'b11001_010000_10001;
        end
        else if (x == 21 && y == 31)
        begin
            pixel_data <= 16'b10110_001110_01111;
        end
        else if (x == 22 && y == 31)
        begin
            pixel_data <= 16'b00110_000101_00110;
        end
        else if (x == 23 && y == 31)
        begin
            pixel_data <= 16'b10100_010100_10100;
        end
        else if (x == 24 && y == 31)
        begin
            pixel_data <= 16'b10100_010100_10100;
        end
        else if (x == 25 && y == 31)
        begin
            pixel_data <= 16'b00001_000001_00001;
        end
        else if (x == 14 && y == 32)
        begin
            pixel_data <= 16'b00010_000010_00010;
        end
        else if (x == 15 && y == 32)
        begin
            pixel_data <= 16'b10100_010100_10100;
        end
        else if (x == 16 && y == 32)
        begin
            pixel_data <= 16'b10110_010110_10110;
        end
        else if (x == 17 && y == 32)
        begin
            pixel_data <= 16'b10011_010011_10011;
        end
        else if (x == 18 && y == 32)
        begin
            pixel_data <= 16'b00101_000100_00100;
        end
        else if (x == 19 && y == 32)
        begin
            pixel_data <= 16'b00100_000011_00100;
        end
        else if (x == 20 && y == 32)
        begin
            pixel_data <= 16'b00100_000011_00100;
        end
        else if (x == 21 && y == 32)
        begin
            pixel_data <= 16'b00110_000101_00101;
        end
        else if (x == 22 && y == 32)
        begin
            pixel_data <= 16'b10011_010011_10011;
        end
        else if (x == 23 && y == 32)
        begin
            pixel_data <= 16'b10110_010110_10110;
        end
        else if (x == 24 && y == 32)
        begin
            pixel_data <= 16'b10011_010011_10011;
        end
        else if (x == 25 && y == 32)
        begin
            pixel_data <= 16'b00001_000001_00001;
        end
        else if (x == 14 && y == 33)
        begin
            pixel_data <= 16'b00010_000010_00010;
        end
        else if (x == 15 && y == 33)
        begin
            pixel_data <= 16'b10100_010100_10100;
        end
        else if (x == 16 && y == 33)
        begin
            pixel_data <= 16'b10110_010110_10110;
        end
        else if (x == 17 && y == 33)
        begin
            pixel_data <= 16'b10101_010101_10101;
        end
        else if (x == 18 && y == 33)
        begin
            pixel_data <= 16'b10100_010100_10100;
        end
        else if (x == 19 && y == 33)
        begin
            pixel_data <= 16'b10100_010100_10100;
        end
        else if (x == 20 && y == 33)
        begin
            pixel_data <= 16'b10100_010100_10100;
        end
        else if (x == 21 && y == 33)
        begin
            pixel_data <= 16'b10100_010100_10100;
        end
        else if (x == 22 && y == 33)
        begin
            pixel_data <= 16'b10110_010110_10110;
        end
        else if (x == 23 && y == 33)
        begin
            pixel_data <= 16'b10110_010110_10110;
        end
        else if (x == 24 && y == 33)
        begin
            pixel_data <= 16'b10100_010100_10100;
        end
        else if (x == 25 && y == 33)
        begin
            pixel_data <= 16'b00001_000001_00001;
        end
        else if (x == 14 && y == 34)
        begin
            pixel_data <= 16'b00001_000001_00001;
        end
        else if (x == 15 && y == 34)
        begin
            pixel_data <= 16'b10001_010001_10001;
        end
        else if (x == 16 && y == 34)
        begin
            pixel_data <= 16'b10110_010110_10110;
        end
        else if (x == 17 && y == 34)
        begin
            pixel_data <= 16'b10110_010110_10110;
        end
        else if (x == 18 && y == 34)
        begin
            pixel_data <= 16'b10110_010110_10110;
        end
        else if (x == 19 && y == 34)
        begin
            pixel_data <= 16'b10110_010110_10110;
        end
        else if (x == 20 && y == 34)
        begin
            pixel_data <= 16'b10110_010110_10110;
        end
        else if (x == 21 && y == 34)
        begin
            pixel_data <= 16'b10110_010110_10110;
        end
        else if (x == 22 && y == 34)
        begin
            pixel_data <= 16'b10110_010110_10110;
        end
        else if (x == 23 && y == 34)
        begin
            pixel_data <= 16'b10110_010110_10110;
        end
        else if (x == 24 && y == 34)
        begin
            pixel_data <= 16'b10001_010001_10001;
        end
        else if (x == 25 && y == 34)
        begin
            pixel_data <= 16'b00000_000001_00001;
        end
        else if (x == 13 && y == 35)
        begin
            pixel_data <= 16'b00011_000010_00010;
        end
        else if (x == 14 && y == 35)
        begin
            pixel_data <= 16'b00011_000010_00010;
        end
        else if (x == 15 && y == 35)
        begin
            pixel_data <= 16'b00101_000100_00100;
        end
        else if (x == 16 && y == 35)
        begin
            pixel_data <= 16'b10010_010010_10010;
        end
        else if (x == 17 && y == 35)
        begin
            pixel_data <= 16'b10110_010110_10110;
        end
        else if (x == 18 && y == 35)
        begin
            pixel_data <= 16'b10110_010110_10110;
        end
        else if (x == 19 && y == 35)
        begin
            pixel_data <= 16'b10110_010110_10110;
        end
        else if (x == 20 && y == 35)
        begin
            pixel_data <= 16'b10110_010110_10110;
        end
        else if (x == 21 && y == 35)
        begin
            pixel_data <= 16'b10110_010110_10110;
        end
        else if (x == 22 && y == 35)
        begin
            pixel_data <= 16'b10110_010110_10110;
        end
        else if (x == 23 && y == 35)
        begin
            pixel_data <= 16'b10001_010001_10001;
        end
        else if (x == 24 && y == 35)
        begin
            pixel_data <= 16'b00100_000100_00100;
        end
        else if (x == 25 && y == 35)
        begin
            pixel_data <= 16'b00011_000010_00010;
        end
        else if (x == 26 && y == 35)
        begin
            pixel_data <= 16'b00011_000010_00010;
        end
        else if (x == 11 && y == 36)
        begin
            pixel_data <= 16'b00010_000001_00001;
        end
        else if (x == 12 && y == 36)
        begin
            pixel_data <= 16'b00110_000100_00100;
        end
        else if (x == 13 && y == 36)
        begin
            pixel_data <= 16'b11010_010001_10011;
        end
        else if (x == 14 && y == 36)
        begin
            pixel_data <= 16'b11100_010010_10100;
        end
        else if (x == 15 && y == 36)
        begin
            pixel_data <= 16'b11001_010000_10010;
        end
        else if (x == 16 && y == 36)
        begin
            pixel_data <= 16'b00111_000110_00110;
        end
        else if (x == 17 && y == 36)
        begin
            pixel_data <= 16'b10010_010010_10010;
        end
        else if (x == 18 && y == 36)
        begin
            pixel_data <= 16'b10011_010011_10011;
        end
        else if (x == 19 && y == 36)
        begin
            pixel_data <= 16'b10011_010011_10011;
        end
        else if (x == 20 && y == 36)
        begin
            pixel_data <= 16'b10011_010011_10011;
        end
        else if (x == 21 && y == 36)
        begin
            pixel_data <= 16'b10011_010011_10011;
        end
        else if (x == 22 && y == 36)
        begin
            pixel_data <= 16'b10001_010001_10001;
        end
        else if (x == 23 && y == 36)
        begin
            pixel_data <= 16'b01000_000110_00110;
        end
        else if (x == 24 && y == 36)
        begin
            pixel_data <= 16'b11010_010001_10011;
        end
        else if (x == 25 && y == 36)
        begin
            pixel_data <= 16'b11100_010010_10100;
        end
        else if (x == 26 && y == 36)
        begin
            pixel_data <= 16'b11010_010001_10010;
        end
        else if (x == 27 && y == 36)
        begin
            pixel_data <= 16'b00101_000100_00100;
        end
        else if (x == 28 && y == 36)
        begin
            pixel_data <= 16'b00010_000001_00001;
        end
        else if (x == 10 && y == 37)
        begin
            pixel_data <= 16'b00001_000001_00000;
        end
        else if (x == 11 && y == 37)
        begin
            pixel_data <= 16'b00011_000010_00010;
        end
        else if (x == 12 && y == 37)
        begin
            pixel_data <= 16'b11010_010001_10011;
        end
        else if (x == 13 && y == 37)
        begin
            pixel_data <= 16'b11011_010010_10100;
        end
        else if (x == 14 && y == 37)
        begin
            pixel_data <= 16'b11110_010011_10101;
        end
        else if (x == 15 && y == 37)
        begin
            pixel_data <= 16'b11011_010010_10100;
        end
        else if (x == 16 && y == 37)
        begin
            pixel_data <= 16'b11001_010001_10010;
        end
        else if (x == 17 && y == 37)
        begin
            pixel_data <= 16'b00011_000010_00010;
        end
        else if (x == 18 && y == 37)
        begin
            pixel_data <= 16'b00010_000010_00001;
        end
        else if (x == 19 && y == 37)
        begin
            pixel_data <= 16'b00011_000010_00001;
        end
        else if (x == 20 && y == 37)
        begin
            pixel_data <= 16'b00011_000010_00001;
        end
        else if (x == 21 && y == 37)
        begin
            pixel_data <= 16'b00010_000010_00001;
        end
        else if (x == 22 && y == 37)
        begin
            pixel_data <= 16'b00011_000010_00011;
        end
        else if (x == 23 && y == 37)
        begin
            pixel_data <= 16'b11010_010001_10010;
        end
        else if (x == 24 && y == 37)
        begin
            pixel_data <= 16'b11011_010010_10100;
        end
        else if (x == 25 && y == 37)
        begin
            pixel_data <= 16'b11110_010011_10101;
        end
        else if (x == 26 && y == 37)
        begin
            pixel_data <= 16'b11011_010010_10100;
        end
        else if (x == 27 && y == 37)
        begin
            pixel_data <= 16'b11001_010000_10010;
        end
        else if (x == 28 && y == 37)
        begin
            pixel_data <= 16'b00001_000001_00001;
        end
        else if (x == 29 && y == 37)
        begin
            pixel_data <= 16'b00001_000001_00000;
        end
        else if (x == 8 && y == 38)
        begin
            pixel_data <= 16'b00001_000000_00000;
        end
        else if (x == 9 && y == 38)
        begin
            pixel_data <= 16'b00100_000010_00001;
        end
        else if (x == 10 && y == 38)
        begin
            pixel_data <= 16'b01110_001000_00101;
        end
        else if (x == 11 && y == 38)
        begin
            pixel_data <= 16'b00110_000011_00011;
        end
        else if (x == 12 && y == 38)
        begin
            pixel_data <= 16'b10110_001111_10000;
        end
        else if (x == 13 && y == 38)
        begin
            pixel_data <= 16'b01000_000101_00101;
        end
        else if (x == 14 && y == 38)
        begin
            pixel_data <= 16'b10110_001110_10000;
        end
        else if (x == 15 && y == 38)
        begin
            pixel_data <= 16'b01000_000101_00101;
        end
        else if (x == 16 && y == 38)
        begin
            pixel_data <= 16'b10110_001110_10000;
        end
        else if (x == 17 && y == 38)
        begin
            pixel_data <= 16'b00101_000011_00010;
        end
        else if (x == 18 && y == 38)
        begin
            pixel_data <= 16'b01111_001001_00110;
        end
        else if (x == 19 && y == 38)
        begin
            pixel_data <= 16'b10001_001001_00110;
        end
        else if (x == 20 && y == 38)
        begin
            pixel_data <= 16'b10001_001001_00110;
        end
        else if (x == 21 && y == 38)
        begin
            pixel_data <= 16'b01110_001000_00101;
        end
        else if (x == 22 && y == 38)
        begin
            pixel_data <= 16'b00101_000011_00011;
        end
        else if (x == 23 && y == 38)
        begin
            pixel_data <= 16'b10110_001110_10000;
        end
        else if (x == 24 && y == 38)
        begin
            pixel_data <= 16'b01000_000101_00101;
        end
        else if (x == 25 && y == 38)
        begin
            pixel_data <= 16'b10110_001110_01111;
        end
        else if (x == 26 && y == 38)
        begin
            pixel_data <= 16'b01000_000101_00101;
        end
        else if (x == 27 && y == 38)
        begin
            pixel_data <= 16'b10110_001110_10000;
        end
        else if (x == 28 && y == 38)
        begin
            pixel_data <= 16'b00101_000011_00010;
        end
        else if (x == 29 && y == 38)
        begin
            pixel_data <= 16'b01110_001000_00101;
        end
        else if (x == 30 && y == 38)
        begin
            pixel_data <= 16'b00011_000010_00001;
        end
        else if (x == 8 && y == 39)
        begin
            pixel_data <= 16'b00001_000001_00000;
        end
        else if (x == 9 && y == 39)
        begin
            pixel_data <= 16'b10000_001001_00110;
        end
        else if (x == 10 && y == 39)
        begin
            pixel_data <= 16'b10010_001011_00111;
        end
        else if (x == 11 && y == 39)
        begin
            pixel_data <= 16'b01111_001001_00110;
        end
        else if (x == 12 && y == 39)
        begin
            pixel_data <= 16'b00101_000011_00010;
        end
        else if (x == 13 && y == 39)
        begin
            pixel_data <= 16'b01110_001000_00101;
        end
        else if (x == 14 && y == 39)
        begin
            pixel_data <= 16'b00101_000011_00010;
        end
        else if (x == 15 && y == 39)
        begin
            pixel_data <= 16'b01110_001000_00101;
        end
        else if (x == 16 && y == 39)
        begin
            pixel_data <= 16'b00101_000011_00010;
        end
        else if (x == 17 && y == 39)
        begin
            pixel_data <= 16'b10000_001001_00110;
        end
        else if (x == 18 && y == 39)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 19 && y == 39)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 20 && y == 39)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 21 && y == 39)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 22 && y == 39)
        begin
            pixel_data <= 16'b01111_001001_00110;
        end
        else if (x == 23 && y == 39)
        begin
            pixel_data <= 16'b00110_000011_00010;
        end
        else if (x == 24 && y == 39)
        begin
            pixel_data <= 16'b01110_001000_00101;
        end
        else if (x == 25 && y == 39)
        begin
            pixel_data <= 16'b00110_000011_00011;
        end
        else if (x == 26 && y == 39)
        begin
            pixel_data <= 16'b01110_001000_00101;
        end
        else if (x == 27 && y == 39)
        begin
            pixel_data <= 16'b00101_000011_00010;
        end
        else if (x == 28 && y == 39)
        begin
            pixel_data <= 16'b10000_001001_00110;
        end
        else if (x == 29 && y == 39)
        begin
            pixel_data <= 16'b10010_001011_00111;
        end
        else if (x == 30 && y == 39)
        begin
            pixel_data <= 16'b01111_001001_00110;
        end
        else if (x == 31 && y == 39)
        begin
            pixel_data <= 16'b00001_000000_00000;
        end
        else if (x == 8 && y == 40)
        begin
            pixel_data <= 16'b00001_000001_00000;
        end
        else if (x == 9 && y == 40)
        begin
            pixel_data <= 16'b01111_001001_00110;
        end
        else if (x == 10 && y == 40)
        begin
            pixel_data <= 16'b10010_001011_00111;
        end
        else if (x == 11 && y == 40)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 12 && y == 40)
        begin
            pixel_data <= 16'b10000_001001_00110;
        end
        else if (x == 13 && y == 40)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 14 && y == 40)
        begin
            pixel_data <= 16'b10000_001001_00110;
        end
        else if (x == 15 && y == 40)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 16 && y == 40)
        begin
            pixel_data <= 16'b10000_001001_00110;
        end
        else if (x == 17 && y == 40)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 18 && y == 40)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 19 && y == 40)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 20 && y == 40)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 21 && y == 40)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 22 && y == 40)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 23 && y == 40)
        begin
            pixel_data <= 16'b10000_001001_00110;
        end
        else if (x == 24 && y == 40)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 25 && y == 40)
        begin
            pixel_data <= 16'b10001_001010_00110;
        end
        else if (x == 26 && y == 40)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 27 && y == 40)
        begin
            pixel_data <= 16'b10000_001010_00110;
        end
        else if (x == 28 && y == 40)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 29 && y == 40)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 30 && y == 40)
        begin
            pixel_data <= 16'b01111_001000_00110;
        end
        else if (x == 31 && y == 40)
        begin
            pixel_data <= 16'b00001_000000_00000;
        end
        else if (x == 8 && y == 41)
        begin
            pixel_data <= 16'b00001_000000_00000;
        end
        else if (x == 9 && y == 41)
        begin
            pixel_data <= 16'b00011_000001_00001;
        end
        else if (x == 10 && y == 41)
        begin
            pixel_data <= 16'b01111_001001_00110;
        end
        else if (x == 11 && y == 41)
        begin
            pixel_data <= 16'b10001_001010_00110;
        end
        else if (x == 12 && y == 41)
        begin
            pixel_data <= 16'b10010_001011_00111;
        end
        else if (x == 13 && y == 41)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 14 && y == 41)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 15 && y == 41)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 16 && y == 41)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 17 && y == 41)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 18 && y == 41)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 19 && y == 41)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 20 && y == 41)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 21 && y == 41)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 22 && y == 41)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 23 && y == 41)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 24 && y == 41)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 25 && y == 41)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 26 && y == 41)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 27 && y == 41)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 28 && y == 41)
        begin
            pixel_data <= 16'b10001_001010_00110;
        end
        else if (x == 29 && y == 41)
        begin
            pixel_data <= 16'b01111_001001_00110;
        end
        else if (x == 30 && y == 41)
        begin
            pixel_data <= 16'b00010_000001_00001;
        end
        else if (x == 10 && y == 42)
        begin
            pixel_data <= 16'b00001_000000_00000;
        end
        else if (x == 11 && y == 42)
        begin
            pixel_data <= 16'b00011_000001_00001;
        end
        else if (x == 12 && y == 42)
        begin
            pixel_data <= 16'b01111_001001_00110;
        end
        else if (x == 13 && y == 42)
        begin
            pixel_data <= 16'b10001_001010_00110;
        end
        else if (x == 14 && y == 42)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 15 && y == 42)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 16 && y == 42)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 17 && y == 42)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 18 && y == 42)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 19 && y == 42)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 20 && y == 42)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 21 && y == 42)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 22 && y == 42)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 23 && y == 42)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 24 && y == 42)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 25 && y == 42)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 26 && y == 42)
        begin
            pixel_data <= 16'b10001_001010_00110;
        end
        else if (x == 27 && y == 42)
        begin
            pixel_data <= 16'b01111_001000_00110;
        end
        else if (x == 28 && y == 42)
        begin
            pixel_data <= 16'b00010_000001_00001;
        end
        else if (x == 29 && y == 42)
        begin
            pixel_data <= 16'b00001_000000_00000;
        end
        else if (x == 30 && y == 42)
        begin
            pixel_data <= 16'b00000_000001_00001;
        end
        else if (x == 12 && y == 43)
        begin
            pixel_data <= 16'b00001_000000_00000;
        end
        else if (x == 13 && y == 43)
        begin
            pixel_data <= 16'b00011_000001_00001;
        end
        else if (x == 14 && y == 43)
        begin
            pixel_data <= 16'b01111_001001_00110;
        end
        else if (x == 15 && y == 43)
        begin
            pixel_data <= 16'b10000_001001_00110;
        end
        else if (x == 16 && y == 43)
        begin
            pixel_data <= 16'b10000_001001_00110;
        end
        else if (x == 17 && y == 43)
        begin
            pixel_data <= 16'b10000_001001_00110;
        end
        else if (x == 18 && y == 43)
        begin
            pixel_data <= 16'b10000_001001_00110;
        end
        else if (x == 19 && y == 43)
        begin
            pixel_data <= 16'b10000_001001_00110;
        end
        else if (x == 20 && y == 43)
        begin
            pixel_data <= 16'b10000_001001_00110;
        end
        else if (x == 21 && y == 43)
        begin
            pixel_data <= 16'b10000_001001_00110;
        end
        else if (x == 22 && y == 43)
        begin
            pixel_data <= 16'b10000_001001_00110;
        end
        else if (x == 23 && y == 43)
        begin
            pixel_data <= 16'b10000_001001_00110;
        end
        else if (x == 24 && y == 43)
        begin
            pixel_data <= 16'b10000_001001_00110;
        end
        else if (x == 25 && y == 43)
        begin
            pixel_data <= 16'b01111_001000_00110;
        end
        else if (x == 26 && y == 43)
        begin
            pixel_data <= 16'b00010_000001_00000;
        end
        else if (x == 27 && y == 43)
        begin
            pixel_data <= 16'b00001_000000_00000;
        end
        else if (x == 14 && y == 44)
        begin
            pixel_data <= 16'b00001_000001_00000;
        end
        else if (x == 15 && y == 44)
        begin
            pixel_data <= 16'b00001_000001_00000;
        end
        else if (x == 16 && y == 44)
        begin
            pixel_data <= 16'b00001_000000_00000;
        end
        else if (x == 17 && y == 44)
        begin
            pixel_data <= 16'b00001_000000_00000;
        end
        else if (x == 18 && y == 44)
        begin
            pixel_data <= 16'b00001_000000_00000;
        end
        else if (x == 19 && y == 44)
        begin
            pixel_data <= 16'b00001_000000_00000;
        end
        else if (x == 20 && y == 44)
        begin
            pixel_data <= 16'b00001_000000_00000;
        end
        else if (x == 21 && y == 44)
        begin
            pixel_data <= 16'b00001_000000_00000;
        end
        else if (x == 22 && y == 44)
        begin
            pixel_data <= 16'b00001_000000_00000;
        end
        else if (x == 23 && y == 44)
        begin
            pixel_data <= 16'b00001_000000_00000;
        end
        else if (x == 24 && y == 44)
        begin
            pixel_data <= 16'b00001_000001_00000;
        end
        else if (x == 25 && y == 44)
        begin
            pixel_data <= 16'b00001_000000_00000;
        end
        
        
        
        
        
        // mole 2
        else if (x == 44 && y == 24)
        begin
            pixel_data <= 16'b00011_000011_00011;
        end
        else if (x == 45 && y == 24)
        begin
            pixel_data <= 16'b00011_000011_00011;
        end
        else if (x == 46 && y == 24)
        begin
            pixel_data <= 16'b00011_000011_00011;
        end
        else if (x == 47 && y == 24)
        begin
            pixel_data <= 16'b00011_000011_00011;
        end
        else if (x == 41 && y == 25)
        begin
            pixel_data <= 16'b00001_000001_00001;
        end
        else if (x == 42 && y == 25)
        begin
            pixel_data <= 16'b00011_000011_00011;
        end
        else if (x == 43 && y == 25)
        begin
            pixel_data <= 16'b00101_000101_00101;
        end
        else if (x == 44 && y == 25)
        begin
            pixel_data <= 16'b10100_010100_10100;
        end
        else if (x == 45 && y == 25)
        begin
            pixel_data <= 16'b10101_010101_10101;
        end
        else if (x == 46 && y == 25)
        begin
            pixel_data <= 16'b10101_010101_10101;
        end
        else if (x == 47 && y == 25)
        begin
            pixel_data <= 16'b10011_010011_10011;
        end
        else if (x == 48 && y == 25)
        begin
            pixel_data <= 16'b00100_000100_00100;
        end
        else if (x == 49 && y == 25)
        begin
            pixel_data <= 16'b00011_000011_00011;
        end
        else if (x == 50 && y == 25)
        begin
            pixel_data <= 16'b00010_000010_00010;
        end
        else if (x == 41 && y == 26)
        begin
            pixel_data <= 16'b00010_000010_00010;
        end
        else if (x == 42 && y == 26)
        begin
            pixel_data <= 16'b10011_010011_10011;
        end
        else if (x == 43 && y == 26)
        begin
            pixel_data <= 16'b10001_010001_10001;
        end
        else if (x == 44 && y == 26)
        begin
            pixel_data <= 16'b10010_010010_10010;
        end
        else if (x == 45 && y == 26)
        begin
            pixel_data <= 16'b10101_010101_10101;
        end
        else if (x == 46 && y == 26)
        begin
            pixel_data <= 16'b10101_010101_10101;
        end
        else if (x == 47 && y == 26)
        begin
            pixel_data <= 16'b10010_010010_10010;
        end
        else if (x == 48 && y == 26)
        begin
            pixel_data <= 16'b10010_010010_10010;
        end
        else if (x == 49 && y == 26)
        begin
            pixel_data <= 16'b10010_010010_10010;
        end
        else if (x == 50 && y == 26)
        begin
            pixel_data <= 16'b00001_000001_00001;
        end
        else if (x == 40 && y == 27)
        begin
            pixel_data <= 16'b00001_000001_00001;
        end
        else if (x == 41 && y == 27)
        begin
            pixel_data <= 16'b00101_000101_00101;
        end
        else if (x == 42 && y == 27)
        begin
            pixel_data <= 16'b10011_010011_10011;
        end
        else if (x == 43 && y == 27)
        begin
            pixel_data <= 16'b00101_000101_00101;
        end
        else if (x == 44 && y == 27)
        begin
            pixel_data <= 16'b00010_000010_00010;
        end
        else if (x == 45 && y == 27)
        begin
            pixel_data <= 16'b10100_010100_10100;
        end
        else if (x == 46 && y == 27)
        begin
            pixel_data <= 16'b10100_010100_10100;
        end
        else if (x == 47 && y == 27)
        begin
            pixel_data <= 16'b00101_000101_00101;
        end
        else if (x == 48 && y == 27)
        begin
            pixel_data <= 16'b00010_000010_00010;
        end
        else if (x == 49 && y == 27)
        begin
            pixel_data <= 16'b10010_010010_10010;
        end
        else if (x == 50 && y == 27)
        begin
            pixel_data <= 16'b00100_000100_00100;
        end
        else if (x == 51 && y == 27)
        begin
            pixel_data <= 16'b00001_000001_00001;
        end
        else if (x == 40 && y == 28)
        begin
            pixel_data <= 16'b00010_000010_00010;
        end
        else if (x == 41 && y == 28)
        begin
            pixel_data <= 16'b10011_010011_10011;
        end
        else if (x == 42 && y == 28)
        begin
            pixel_data <= 16'b10111_010111_10111;
        end
        else if (x == 43 && y == 28)
        begin
            pixel_data <= 16'b11001_011001_11001;
        end
        else if (x == 44 && y == 28)
        begin
            pixel_data <= 16'b00110_000110_00110;
        end
        else if (x == 45 && y == 28)
        begin
            pixel_data <= 16'b10100_010100_10100;
        end
        else if (x == 46 && y == 28)
        begin
            pixel_data <= 16'b10111_010111_10111;
        end
        else if (x == 47 && y == 28)
        begin
            pixel_data <= 16'b11001_011001_11001;
        end
        else if (x == 48 && y == 28)
        begin
            pixel_data <= 16'b00110_000110_00110;
        end
        else if (x == 49 && y == 28)
        begin
            pixel_data <= 16'b10100_010100_10100;
        end
        else if (x == 50 && y == 28)
        begin
            pixel_data <= 16'b10011_010011_10011;
        end
        else if (x == 51 && y == 28)
        begin
            pixel_data <= 16'b00001_000001_00001;
        end
        else if (x == 40 && y == 29)
        begin
            pixel_data <= 16'b00010_000010_00010;
        end
        else if (x == 41 && y == 29)
        begin
            pixel_data <= 16'b10100_010100_10100;
        end
        else if (x == 42 && y == 29)
        begin
            pixel_data <= 16'b10110_010110_10110;
        end
        else if (x == 43 && y == 29)
        begin
            pixel_data <= 16'b10110_010110_10110;
        end
        else if (x == 44 && y == 29)
        begin
            pixel_data <= 16'b10010_010010_10010;
        end
        else if (x == 45 && y == 29)
        begin
            pixel_data <= 16'b10010_010010_10010;
        end
        else if (x == 46 && y == 29)
        begin
            pixel_data <= 16'b10010_010010_10010;
        end
        else if (x == 47 && y == 29)
        begin
            pixel_data <= 16'b10011_010011_10011;
        end
        else if (x == 48 && y == 29)
        begin
            pixel_data <= 16'b10101_010101_10101;
        end
        else if (x == 49 && y == 29)
        begin
            pixel_data <= 16'b10110_010110_10110;
        end
        else if (x == 50 && y == 29)
        begin
            pixel_data <= 16'b10100_010100_10100;
        end
        else if (x == 51 && y == 29)
        begin
            pixel_data <= 16'b00001_000001_00001;
        end
        else if (x == 40 && y == 30)
        begin
            pixel_data <= 16'b00010_000010_00010;
        end
        else if (x == 41 && y == 30)
        begin
            pixel_data <= 16'b10100_010100_10100;
        end
        else if (x == 42 && y == 30)
        begin
            pixel_data <= 16'b10110_010110_10110;
        end
        else if (x == 43 && y == 30)
        begin
            pixel_data <= 16'b10001_010001_10001;
        end
        else if (x == 44 && y == 30)
        begin
            pixel_data <= 16'b00110_000100_00101;
        end
        else if (x == 45 && y == 30)
        begin
            pixel_data <= 16'b00101_000100_00100;
        end
        else if (x == 46 && y == 30)
        begin
            pixel_data <= 16'b00101_000100_00100;
        end
        else if (x == 47 && y == 30)
        begin
            pixel_data <= 16'b00110_000101_00101;
        end
        else if (x == 48 && y == 30)
        begin
            pixel_data <= 16'b10010_010010_10010;
        end
        else if (x == 49 && y == 30)
        begin
            pixel_data <= 16'b10110_010110_10110;
        end
        else if (x == 50 && y == 30)
        begin
            pixel_data <= 16'b10011_010011_10011;
        end
        else if (x == 51 && y == 30)
        begin
            pixel_data <= 16'b00001_000001_00001;
        end
        else if (x == 40 && y == 31)
        begin
            pixel_data <= 16'b00010_000010_00010;
        end
        else if (x == 41 && y == 31)
        begin
            pixel_data <= 16'b10100_010100_10100;
        end
        else if (x == 42 && y == 31)
        begin
            pixel_data <= 16'b10100_010100_10100;
        end
        else if (x == 43 && y == 31)
        begin
            pixel_data <= 16'b00111_000110_00110;
        end
        else if (x == 44 && y == 31)
        begin
            pixel_data <= 16'b10111_001111_10000;
        end
        else if (x == 45 && y == 31)
        begin
            pixel_data <= 16'b11000_010000_10001;
        end
        else if (x == 46 && y == 31)
        begin
            pixel_data <= 16'b11001_010000_10001;
        end
        else if (x == 47 && y == 31)
        begin
            pixel_data <= 16'b10110_001110_01111;
        end
        else if (x == 48 && y == 31)
        begin
            pixel_data <= 16'b00110_000101_00110;
        end
        else if (x == 49 && y == 31)
        begin
            pixel_data <= 16'b10100_010100_10100;
        end
        else if (x == 50 && y == 31)
        begin
            pixel_data <= 16'b10100_010100_10100;
        end
        else if (x == 51 && y == 31)
        begin
            pixel_data <= 16'b00001_000001_00001;
        end
        else if (x == 40 && y == 32)
        begin
            pixel_data <= 16'b00010_000010_00010;
        end
        else if (x == 41 && y == 32)
        begin
            pixel_data <= 16'b10100_010100_10100;
        end
        else if (x == 42 && y == 32)
        begin
            pixel_data <= 16'b10110_010110_10110;
        end
        else if (x == 43 && y == 32)
        begin
            pixel_data <= 16'b10011_010011_10011;
        end
        else if (x == 44 && y == 32)
        begin
            pixel_data <= 16'b00101_000100_00100;
        end
        else if (x == 45 && y == 32)
        begin
            pixel_data <= 16'b00100_000011_00100;
        end
        else if (x == 46 && y == 32)
        begin
            pixel_data <= 16'b00100_000011_00100;
        end
        else if (x == 47 && y == 32)
        begin
            pixel_data <= 16'b00110_000101_00101;
        end
        else if (x == 48 && y == 32)
        begin
            pixel_data <= 16'b10011_010011_10011;
        end
        else if (x == 49 && y == 32)
        begin
            pixel_data <= 16'b10110_010110_10110;
        end
        else if (x == 50 && y == 32)
        begin
            pixel_data <= 16'b10011_010011_10011;
        end
        else if (x == 51 && y == 32)
        begin
            pixel_data <= 16'b00001_000001_00001;
        end
        else if (x == 40 && y == 33)
        begin
            pixel_data <= 16'b00010_000010_00010;
        end
        else if (x == 41 && y == 33)
        begin
            pixel_data <= 16'b10100_010100_10100;
        end
        else if (x == 42 && y == 33)
        begin
            pixel_data <= 16'b10110_010110_10110;
        end
        else if (x == 43 && y == 33)
        begin
            pixel_data <= 16'b10101_010101_10101;
        end
        else if (x == 44 && y == 33)
        begin
            pixel_data <= 16'b10100_010100_10100;
        end
        else if (x == 45 && y == 33)
        begin
            pixel_data <= 16'b10100_010100_10100;
        end
        else if (x == 46 && y == 33)
        begin
            pixel_data <= 16'b10100_010100_10100;
        end
        else if (x == 47 && y == 33)
        begin
            pixel_data <= 16'b10100_010100_10100;
        end
        else if (x == 48 && y == 33)
        begin
            pixel_data <= 16'b10110_010110_10110;
        end
        else if (x == 49 && y == 33)
        begin
            pixel_data <= 16'b10110_010110_10110;
        end
        else if (x == 50 && y == 33)
        begin
            pixel_data <= 16'b10100_010100_10100;
        end
        else if (x == 51 && y == 33)
        begin
            pixel_data <= 16'b00001_000001_00001;
        end
        else if (x == 40 && y == 34)
        begin
            pixel_data <= 16'b00001_000001_00001;
        end
        else if (x == 41 && y == 34)
        begin
            pixel_data <= 16'b10001_010001_10001;
        end
        else if (x == 42 && y == 34)
        begin
            pixel_data <= 16'b10110_010110_10110;
        end
        else if (x == 43 && y == 34)
        begin
            pixel_data <= 16'b10110_010110_10110;
        end
        else if (x == 44 && y == 34)
        begin
            pixel_data <= 16'b10110_010110_10110;
        end
        else if (x == 45 && y == 34)
        begin
            pixel_data <= 16'b10110_010110_10110;
        end
        else if (x == 46 && y == 34)
        begin
            pixel_data <= 16'b10110_010110_10110;
        end
        else if (x == 47 && y == 34)
        begin
            pixel_data <= 16'b10110_010110_10110;
        end
        else if (x == 48 && y == 34)
        begin
            pixel_data <= 16'b10110_010110_10110;
        end
        else if (x == 49 && y == 34)
        begin
            pixel_data <= 16'b10110_010110_10110;
        end
        else if (x == 50 && y == 34)
        begin
            pixel_data <= 16'b10001_010001_10001;
        end
        else if (x == 51 && y == 34)
        begin
            pixel_data <= 16'b00000_000001_00001;
        end
        else if (x == 39 && y == 35)
        begin
            pixel_data <= 16'b00011_000010_00010;
        end
        else if (x == 40 && y == 35)
        begin
            pixel_data <= 16'b00011_000010_00010;
        end
        else if (x == 41 && y == 35)
        begin
            pixel_data <= 16'b00101_000100_00100;
        end
        else if (x == 42 && y == 35)
        begin
            pixel_data <= 16'b10010_010010_10010;
        end
        else if (x == 43 && y == 35)
        begin
            pixel_data <= 16'b10110_010110_10110;
        end
        else if (x == 44 && y == 35)
        begin
            pixel_data <= 16'b10110_010110_10110;
        end
        else if (x == 45 && y == 35)
        begin
            pixel_data <= 16'b10110_010110_10110;
        end
        else if (x == 46 && y == 35)
        begin
            pixel_data <= 16'b10110_010110_10110;
        end
        else if (x == 47 && y == 35)
        begin
            pixel_data <= 16'b10110_010110_10110;
        end
        else if (x == 48 && y == 35)
        begin
            pixel_data <= 16'b10110_010110_10110;
        end
        else if (x == 49 && y == 35)
        begin
            pixel_data <= 16'b10001_010001_10001;
        end
        else if (x == 50 && y == 35)
        begin
            pixel_data <= 16'b00100_000100_00100;
        end
        else if (x == 51 && y == 35)
        begin
            pixel_data <= 16'b00011_000010_00010;
        end
        else if (x == 52 && y == 35)
        begin
            pixel_data <= 16'b00011_000010_00010;
        end
        else if (x == 37 && y == 36)
        begin
            pixel_data <= 16'b00010_000001_00001;
        end
        else if (x == 38 && y == 36)
        begin
            pixel_data <= 16'b00110_000100_00100;
        end
        else if (x == 39 && y == 36)
        begin
            pixel_data <= 16'b11010_010001_10011;
        end
        else if (x == 40 && y == 36)
        begin
            pixel_data <= 16'b11100_010010_10100;
        end
        else if (x == 41 && y == 36)
        begin
            pixel_data <= 16'b11001_010000_10010;
        end
        else if (x == 42 && y == 36)
        begin
            pixel_data <= 16'b00111_000110_00110;
        end
        else if (x == 43 && y == 36)
        begin
            pixel_data <= 16'b10010_010010_10010;
        end
        else if (x == 44 && y == 36)
        begin
            pixel_data <= 16'b10011_010011_10011;
        end
        else if (x == 45 && y == 36)
        begin
            pixel_data <= 16'b10011_010011_10011;
        end
        else if (x == 46 && y == 36)
        begin
            pixel_data <= 16'b10011_010011_10011;
        end
        else if (x == 47 && y == 36)
        begin
            pixel_data <= 16'b10011_010011_10011;
        end
        else if (x == 48 && y == 36)
        begin
            pixel_data <= 16'b10001_010001_10001;
        end
        else if (x == 49 && y == 36)
        begin
            pixel_data <= 16'b01000_000110_00110;
        end
        else if (x == 50 && y == 36)
        begin
            pixel_data <= 16'b11010_010001_10011;
        end
        else if (x == 51 && y == 36)
        begin
            pixel_data <= 16'b11100_010010_10100;
        end
        else if (x == 52 && y == 36)
        begin
            pixel_data <= 16'b11010_010001_10010;
        end
        else if (x == 53 && y == 36)
        begin
            pixel_data <= 16'b00101_000100_00100;
        end
        else if (x == 54 && y == 36)
        begin
            pixel_data <= 16'b00010_000001_00001;
        end
        else if (x == 36 && y == 37)
        begin
            pixel_data <= 16'b00001_000001_00000;
        end
        else if (x == 37 && y == 37)
        begin
            pixel_data <= 16'b00011_000010_00010;
        end
        else if (x == 38 && y == 37)
        begin
            pixel_data <= 16'b11010_010001_10011;
        end
        else if (x == 39 && y == 37)
        begin
            pixel_data <= 16'b11011_010010_10100;
        end
        else if (x == 40 && y == 37)
        begin
            pixel_data <= 16'b11110_010011_10101;
        end
        else if (x == 41 && y == 37)
        begin
            pixel_data <= 16'b11011_010010_10100;
        end
        else if (x == 42 && y == 37)
        begin
            pixel_data <= 16'b11001_010001_10010;
        end
        else if (x == 43 && y == 37)
        begin
            pixel_data <= 16'b00011_000010_00010;
        end
        else if (x == 44 && y == 37)
        begin
            pixel_data <= 16'b00010_000010_00001;
        end
        else if (x == 45 && y == 37)
        begin
            pixel_data <= 16'b00011_000010_00001;
        end
        else if (x == 46 && y == 37)
        begin
            pixel_data <= 16'b00011_000010_00001;
        end
        else if (x == 47 && y == 37)
        begin
            pixel_data <= 16'b00010_000010_00001;
        end
        else if (x == 48 && y == 37)
        begin
            pixel_data <= 16'b00011_000010_00011;
        end
        else if (x == 49 && y == 37)
        begin
            pixel_data <= 16'b11010_010001_10010;
        end
        else if (x == 50 && y == 37)
        begin
            pixel_data <= 16'b11011_010010_10100;
        end
        else if (x == 51 && y == 37)
        begin
            pixel_data <= 16'b11110_010011_10101;
        end
        else if (x == 52 && y == 37)
        begin
            pixel_data <= 16'b11011_010010_10100;
        end
        else if (x == 53 && y == 37)
        begin
            pixel_data <= 16'b11001_010000_10010;
        end
        else if (x == 54 && y == 37)
        begin
            pixel_data <= 16'b00001_000001_00001;
        end
        else if (x == 55 && y == 37)
        begin
            pixel_data <= 16'b00001_000001_00000;
        end
        else if (x == 34 && y == 38)
        begin
            pixel_data <= 16'b00001_000000_00000;
        end
        else if (x == 35 && y == 38)
        begin
            pixel_data <= 16'b00100_000010_00001;
        end
        else if (x == 36 && y == 38)
        begin
            pixel_data <= 16'b01110_001000_00101;
        end
        else if (x == 37 && y == 38)
        begin
            pixel_data <= 16'b00110_000011_00011;
        end
        else if (x == 38 && y == 38)
        begin
            pixel_data <= 16'b10110_001111_10000;
        end
        else if (x == 39 && y == 38)
        begin
            pixel_data <= 16'b01000_000101_00101;
        end
        else if (x == 40 && y == 38)
        begin
            pixel_data <= 16'b10110_001110_10000;
        end
        else if (x == 41 && y == 38)
        begin
            pixel_data <= 16'b01000_000101_00101;
        end
        else if (x == 42 && y == 38)
        begin
            pixel_data <= 16'b10110_001110_10000;
        end
        else if (x == 43 && y == 38)
        begin
            pixel_data <= 16'b00101_000011_00010;
        end
        else if (x == 44 && y == 38)
        begin
            pixel_data <= 16'b01111_001001_00110;
        end
        else if (x == 45 && y == 38)
        begin
            pixel_data <= 16'b10001_001001_00110;
        end
        else if (x == 46 && y == 38)
        begin
            pixel_data <= 16'b10001_001001_00110;
        end
        else if (x == 47 && y == 38)
        begin
            pixel_data <= 16'b01110_001000_00101;
        end
        else if (x == 48 && y == 38)
        begin
            pixel_data <= 16'b00101_000011_00011;
        end
        else if (x == 49 && y == 38)
        begin
            pixel_data <= 16'b10110_001110_10000;
        end
        else if (x == 50 && y == 38)
        begin
            pixel_data <= 16'b01000_000101_00101;
        end
        else if (x == 51 && y == 38)
        begin
            pixel_data <= 16'b10110_001110_01111;
        end
        else if (x == 52 && y == 38)
        begin
            pixel_data <= 16'b01000_000101_00101;
        end
        else if (x == 53 && y == 38)
        begin
            pixel_data <= 16'b10110_001110_10000;
        end
        else if (x == 54 && y == 38)
        begin
            pixel_data <= 16'b00101_000011_00010;
        end
        else if (x == 55 && y == 38)
        begin
            pixel_data <= 16'b01110_001000_00101;
        end
        else if (x == 56 && y == 38)
        begin
            pixel_data <= 16'b00011_000010_00001;
        end
        else if (x == 34 && y == 39)
        begin
            pixel_data <= 16'b00001_000001_00000;
        end
        else if (x == 35 && y == 39)
        begin
            pixel_data <= 16'b10000_001001_00110;
        end
        else if (x == 36 && y == 39)
        begin
            pixel_data <= 16'b10010_001011_00111;
        end
        else if (x == 37 && y == 39)
        begin
            pixel_data <= 16'b01111_001001_00110;
        end
        else if (x == 38 && y == 39)
        begin
            pixel_data <= 16'b00101_000011_00010;
        end
        else if (x == 39 && y == 39)
        begin
            pixel_data <= 16'b01110_001000_00101;
        end
        else if (x == 40 && y == 39)
        begin
            pixel_data <= 16'b00101_000011_00010;
        end
        else if (x == 41 && y == 39)
        begin
            pixel_data <= 16'b01110_001000_00101;
        end
        else if (x == 42 && y == 39)
        begin
            pixel_data <= 16'b00101_000011_00010;
        end
        else if (x == 43 && y == 39)
        begin
            pixel_data <= 16'b10000_001001_00110;
        end
        else if (x == 44 && y == 39)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 45 && y == 39)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 46 && y == 39)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 47 && y == 39)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 48 && y == 39)
        begin
            pixel_data <= 16'b01111_001001_00110;
        end
        else if (x == 49 && y == 39)
        begin
            pixel_data <= 16'b00110_000011_00010;
        end
        else if (x == 50 && y == 39)
        begin
            pixel_data <= 16'b01110_001000_00101;
        end
        else if (x == 51 && y == 39)
        begin
            pixel_data <= 16'b00110_000011_00011;
        end
        else if (x == 52 && y == 39)
        begin
            pixel_data <= 16'b01110_001000_00101;
        end
        else if (x == 53 && y == 39)
        begin
            pixel_data <= 16'b00101_000011_00010;
        end
        else if (x == 54 && y == 39)
        begin
            pixel_data <= 16'b10000_001001_00110;
        end
        else if (x == 55 && y == 39)
        begin
            pixel_data <= 16'b10010_001011_00111;
        end
        else if (x == 56 && y == 39)
        begin
            pixel_data <= 16'b01111_001001_00110;
        end
        else if (x == 57 && y == 39)
        begin
            pixel_data <= 16'b00001_000000_00000;
        end
        else if (x == 34 && y == 40)
        begin
            pixel_data <= 16'b00001_000001_00000;
        end
        else if (x == 35 && y == 40)
        begin
            pixel_data <= 16'b01111_001001_00110;
        end
        else if (x == 36 && y == 40)
        begin
            pixel_data <= 16'b10010_001011_00111;
        end
        else if (x == 37 && y == 40)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 38 && y == 40)
        begin
            pixel_data <= 16'b10000_001001_00110;
        end
        else if (x == 39 && y == 40)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 40 && y == 40)
        begin
            pixel_data <= 16'b10000_001001_00110;
        end
        else if (x == 41 && y == 40)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 42 && y == 40)
        begin
            pixel_data <= 16'b10000_001001_00110;
        end
        else if (x == 43 && y == 40)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 44 && y == 40)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 45 && y == 40)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 46 && y == 40)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 47 && y == 40)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 48 && y == 40)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 49 && y == 40)
        begin
            pixel_data <= 16'b10000_001001_00110;
        end
        else if (x == 50 && y == 40)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 51 && y == 40)
        begin
            pixel_data <= 16'b10001_001010_00110;
        end
        else if (x == 52 && y == 40)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 53 && y == 40)
        begin
            pixel_data <= 16'b10000_001010_00110;
        end
        else if (x == 54 && y == 40)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 55 && y == 40)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 56 && y == 40)
        begin
            pixel_data <= 16'b01111_001000_00110;
        end
        else if (x == 57 && y == 40)
        begin
            pixel_data <= 16'b00001_000000_00000;
        end
        else if (x == 34 && y == 41)
        begin
            pixel_data <= 16'b00001_000000_00000;
        end
        else if (x == 35 && y == 41)
        begin
            pixel_data <= 16'b00011_000001_00001;
        end
        else if (x == 36 && y == 41)
        begin
            pixel_data <= 16'b01111_001001_00110;
        end
        else if (x == 37 && y == 41)
        begin
            pixel_data <= 16'b10001_001010_00110;
        end
        else if (x == 38 && y == 41)
        begin
            pixel_data <= 16'b10010_001011_00111;
        end
        else if (x == 39 && y == 41)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 40 && y == 41)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 41 && y == 41)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 42 && y == 41)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 43 && y == 41)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 44 && y == 41)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 45 && y == 41)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 46 && y == 41)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 47 && y == 41)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 48 && y == 41)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 49 && y == 41)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 50 && y == 41)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 51 && y == 41)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 52 && y == 41)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 53 && y == 41)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 54 && y == 41)
        begin
            pixel_data <= 16'b10001_001010_00110;
        end
        else if (x == 55 && y == 41)
        begin
            pixel_data <= 16'b01111_001001_00110;
        end
        else if (x == 56 && y == 41)
        begin
            pixel_data <= 16'b00010_000001_00001;
        end
        else if (x == 36 && y == 42)
        begin
            pixel_data <= 16'b00001_000000_00000;
        end
        else if (x == 37 && y == 42)
        begin
            pixel_data <= 16'b00011_000001_00001;
        end
        else if (x == 38 && y == 42)
        begin
            pixel_data <= 16'b01111_001001_00110;
        end
        else if (x == 39 && y == 42)
        begin
            pixel_data <= 16'b10001_001010_00110;
        end
        else if (x == 40 && y == 42)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 41 && y == 42)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 42 && y == 42)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 43 && y == 42)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 44 && y == 42)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 45 && y == 42)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 46 && y == 42)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 47 && y == 42)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 48 && y == 42)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 49 && y == 42)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 50 && y == 42)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 51 && y == 42)
        begin
            pixel_data <= 16'b10010_001010_00111;
        end
        else if (x == 52 && y == 42)
        begin
            pixel_data <= 16'b10001_001010_00110;
        end
        else if (x == 53 && y == 42)
        begin
            pixel_data <= 16'b01111_001000_00110;
        end
        else if (x == 54 && y == 42)
        begin
            pixel_data <= 16'b00010_000001_00001;
        end
        else if (x == 55 && y == 42)
        begin
            pixel_data <= 16'b00001_000000_00000;
        end
        else if (x == 56 && y == 42)
        begin
            pixel_data <= 16'b00000_000001_00001;
        end
        else if (x == 38 && y == 43)
        begin
            pixel_data <= 16'b00001_000000_00000;
        end
        else if (x == 39 && y == 43)
        begin
            pixel_data <= 16'b00011_000001_00001;
        end
        else if (x == 40 && y == 43)
        begin
            pixel_data <= 16'b01111_001001_00110;
        end
        else if (x == 41 && y == 43)
        begin
            pixel_data <= 16'b10000_001001_00110;
        end
        else if (x == 42 && y == 43)
        begin
            pixel_data <= 16'b10000_001001_00110;
        end
        else if (x == 43 && y == 43)
        begin
            pixel_data <= 16'b10000_001001_00110;
        end
        else if (x == 44 && y == 43)
        begin
            pixel_data <= 16'b10000_001001_00110;
        end
        else if (x == 45 && y == 43)
        begin
            pixel_data <= 16'b10000_001001_00110;
        end
        else if (x == 46 && y == 43)
        begin
            pixel_data <= 16'b10000_001001_00110;
        end
        else if (x == 47 && y == 43)
        begin
            pixel_data <= 16'b10000_001001_00110;
        end
        else if (x == 48 && y == 43)
        begin
            pixel_data <= 16'b10000_001001_00110;
        end
        else if (x == 49 && y == 43)
        begin
            pixel_data <= 16'b10000_001001_00110;
        end
        else if (x == 50 && y == 43)
        begin
            pixel_data <= 16'b10000_001001_00110;
        end
        else if (x == 51 && y == 43)
        begin
            pixel_data <= 16'b01111_001000_00110;
        end
        else if (x == 52 && y == 43)
        begin
            pixel_data <= 16'b00010_000001_00000;
        end
        else if (x == 53 && y == 43)
        begin
            pixel_data <= 16'b00001_000000_00000;
        end
        else if (x == 40 && y == 44)
        begin
            pixel_data <= 16'b00001_000001_00000;
        end
        else if (x == 41 && y == 44)
        begin
            pixel_data <= 16'b00001_000001_00000;
        end
        else if (x == 42 && y == 44)
        begin
            pixel_data <= 16'b00001_000000_00000;
        end
        else if (x == 43 && y == 44)
        begin
            pixel_data <= 16'b00001_000000_00000;
        end
        else if (x == 44 && y == 44)
        begin
            pixel_data <= 16'b00001_000000_00000;
        end
        else if (x == 45 && y == 44)
        begin
            pixel_data <= 16'b00001_000000_00000;
        end
        else if (x == 46 && y == 44)
        begin
            pixel_data <= 16'b00001_000000_00000;
        end
        else if (x == 47 && y == 44)
        begin
            pixel_data <= 16'b00001_000000_00000;
        end
        else if (x == 48 && y == 44)
        begin
            pixel_data <= 16'b00001_000000_00000;
        end
        else if (x == 49 && y == 44)
        begin
            pixel_data <= 16'b00001_000000_00000;
        end
        else if (x == 50 && y == 44)
        begin
            pixel_data <= 16'b00001_000001_00000;
        end
        else if (x == 51 && y == 44)
        begin
            pixel_data <= 16'b00001_000000_00000;
        end
        
        // bomb
        else if (is_bomb_fuse(x, y, 70, 25)) pixel_data <= bomb_fuse;
        else if (is_bomb(x, y, 68, 33)) pixel_data <= bomb;
        else if (is_bomb_fire(x, y, 84, 35)) pixel_data <= bomb_fire;
        
        else pixel_data <= background;
    end
endmodule
