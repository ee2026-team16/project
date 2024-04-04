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
    input [11:0] xpos, ypos,
    input left,
    output reg clicked_start, clicked_settings
);
    reg [15:0] background = 16'b11100_100101_00111;
    reg [15:0] title_text = 16'b00111_000000_00010;
    reg [15:0] subtitle_text = 16'b01101_010010_00010;
    reg [15:0] settings_gear = 16'b00110_100011_01000;
    reg [15:0] rectangle_border = 16'b10011_100111_10011;
    reg [15:0] fire = 16'b11100_001010_00000;
    reg [15:0] bomb = 16'b0;
    reg [15:0] bomb_fuse = 16'b01110_011101_01110;
    reg [15:0] bomb_fire = 16'b11100_001010_00000;
    reg [15:0] mouse = 16'b11111_000000_00000;
    reg [15:0] mole_outline = 16'b00011_000010_00010;
    reg [15:0] mole_body = 16'b11001_010011_01110;
    reg [15:0] mole_hands = 16'b11111_101000_10101;
    reg [15:0] mole_dirt = 16'b10010_001010_00111;

    wire clk_25m, clk_1000, clk_1;
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
    flexible_clock_module flexible_clock_module_1 (
        .basys_clock(clk),
        .my_m_value(49999999),
        .my_clk(clk_1)
    );
            
    reg [7:0] bomb_radius = 8;
    always @ (posedge clk_1)
    begin
        if (bomb_radius < 8)
            bomb_radius <= bomb_radius + 1;
        else
            bomb_radius <= 6;
    end
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
        reg [7:0] sine_lut [0:96];
        integer i;
        begin
            is_bomb_fuse = 0;

            for (i = 0; i < bomb_fuse_period; i = i + 1)
            begin
                sine_lut[i] = bomb_fuse_amplitude * ($sin(2 * 3.141592 * i / bomb_fuse_period));
            end

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
    
    function is_within_rectangle_border;
        input [11:0] xpos;
        input [11:0] ypos;
        input [7:0] origin_x;
        input [7:0] origin_y;
        input [7:0] a;
        input [7:0] b;
        begin
            if (xpos >= origin_x - a / 2 && xpos < origin_x + a / 2 && ypos >= origin_y - b / 2 && ypos < origin_y + b / 2)
                is_within_rectangle_border = 1;
            else
                is_within_rectangle_border = 0;
        end
    endfunction

    function is_mouse;
        input [7:0] curr_x;
        input [7:0] curr_y;
        input [11:0] xpos;
        input [11:0] ypos;
        begin
            if (((x - xpos) ** 2 + (y - ypos) ** 2) < 5)
                is_mouse = 1;
            else
                is_mouse = 0;
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
    reg [7:0] select_start_x = 33;
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
        if (is_within_rectangle_border(xpos, ypos, select_start_x, select_start_y, select_start_a, select_start_b))
            begin
                rectangle_border_x = select_start_x;
                rectangle_border_y = select_start_y;
                rectangle_border_a = select_start_a;
                rectangle_border_b = select_start_b;
            end
        else if (is_within_rectangle_border(xpos, ypos, select_settings_x, select_settings_y, select_settings_a, select_settings_b))
            begin
                rectangle_border_x = select_settings_x;
                rectangle_border_y = select_settings_y;
                rectangle_border_a = select_settings_a;
                rectangle_border_b = select_settings_b;
            end
        else if (rectangle_border_x == 128 && btnL)
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
        
        if (rectangle_border_x == select_start_x && (btnC || left))
            begin
                clicked_start = 1;
                clicked_settings = 0;
                rectangle_border_x = 128;
                rectangle_border_y = 128;
                rectangle_border_a = 128;
                rectangle_border_b = 128;
            end
        else if (rectangle_border_x == select_settings_x && (btnC || left))
            begin
                clicked_start = 0;
                clicked_settings = 1;
                rectangle_border_x = 128;
                rectangle_border_y = 128;
                rectangle_border_a = 128;
                rectangle_border_b = 128;
            end
        else
            begin
                clicked_start = 0;
                clicked_settings = 0;
            end
    end

    // mole 1
    assign mole_1_outline = (((y == 22) && ((x >= 20 && x < 22))) || 
    ((y == 23) && ((x >= 18 && x < 24))) || 
    ((y == 24) && ((x >= 16 && x < 19) || (x >= 23 && x < 25))) || 
    ((y == 25) && ((x >= 16 && x < 17) || (x >= 25 && x < 26))) || 
    ((y == 26) && ((x >= 15 && x < 17) || (x >= 18 && x < 20) || (x >= 22 && x < 24) || (x >= 25 && x < 26))) || 
    ((y == 27) && ((x >= 15 && x < 16) || (x >= 19 && x < 20) || (x >= 23 && x < 24) || (x >= 26 && x < 27))) || 
    ((y == 28) && ((x >= 15 && x < 16) || (x >= 26 && x < 27))) || 
    ((y == 29) && ((x >= 15 && x < 16) || (x >= 18 && x < 23) || (x >= 26 && x < 27))) || 
    ((y == 30) && ((x >= 15 && x < 16) || (x >= 18 && x < 20) || (x >= 22 && x < 24) || (x >= 26 && x < 27))) || 
    ((y == 31) && ((x >= 15 && x < 16) || (x >= 19 && x < 23) || (x >= 26 && x < 27))) || 
    ((y == 32) && ((x >= 15 && x < 16) || (x >= 26 && x < 27))) || 
    ((y == 33) && ((x >= 14 && x < 16) || (x >= 25 && x < 27))) || 
    ((y == 34) && ((x >= 13 && x < 17) || (x >= 25 && x < 28))) || 
    ((y == 35) && ((x >= 12 && x < 14) || (x >= 17 && x < 18) || (x >= 23 && x < 25) || (x >= 28 && x < 29))) || 
    ((y == 36) && ((x >= 10 && x < 13) || (x >= 18 && x < 24) || (x >= 29 && x < 31))) || 
    ((y == 37) && ((x >= 9 && x < 19) || (x >= 23 && x < 30) || (x >= 31 && x < 32))) || 
    ((y == 38) && ((x >= 9 && x < 10) || (x >= 13 && x < 18) || (x >= 24 && x < 25) || (x >= 26 && x < 27) || (x >= 28 && x < 29) || (x >= 32 && x < 33))) || 
    ((y == 39) && ((x >= 9 && x < 10) || (x >= 32 && x < 33))) || 
    ((y == 40) && ((x >= 10 && x < 11) || (x >= 31 && x < 32))) || 
    ((y == 41) && ((x >= 11 && x < 13) || (x >= 29 && x < 31))) || 
    ((y == 42) && ((x >= 13 && x < 15) || (x >= 27 && x < 29))) || 
    ((y == 43) && ((x >= 15 && x < 27))));

    assign mole_1_body = (((y == 24) && ((x >= 19 && x < 23))) || 
    ((y == 25) && ((x >= 17 && x < 25))) || 
    ((y == 26) && ((x >= 17 && x < 18) || (x >= 20 && x < 22) || (x >= 24 && x < 25))) || 
    ((y == 27) && ((x >= 16 && x < 18) || (x >= 20 && x < 22) || (x >= 24 && x < 26))) || 
    ((y == 28) && ((x >= 16 && x < 26))) || 
    ((y == 29) && ((x >= 16 && x < 19) || (x >= 23 && x < 26))) || 
    ((y == 30) && ((x >= 16 && x < 18) || (x >= 24 && x < 26))) || 
    ((y == 31) && ((x >= 16 && x < 19) || (x >= 23 && x < 26))) || 
    ((y == 32) && ((x >= 16 && x < 26))) || 
    ((y == 33) && ((x >= 16 && x < 26))) || 
    ((y == 34) && ((x >= 17 && x < 25))) || 
    ((y == 35) && ((x >= 18 && x < 24))));

    assign mole_1_hands = (((y == 30) && ((x >= 20 && x < 22))) || 
    ((y == 35) && ((x >= 14 && x < 16) || (x >= 25 && x < 28))) || 
    ((y == 36) && ((x >= 13 && x < 17) || (x >= 24 && x < 29))));

    assign mole_1_dirt = (((y == 37) && ((x >= 11 && x < 12) || (x >= 19 && x < 23) || (x >= 30 && x < 31))) || 
    ((y == 38) && ((x >= 10 && x < 13) || (x >= 14 && x < 15) || (x >= 16 && x < 17) || (x >= 18 && x < 24) || (x >= 25 && x < 26) || (x >= 27 && x < 28) || (x >= 29 && x < 32))) || 
    ((y == 39) && ((x >= 10 && x < 32))) || 
    ((y == 40) && ((x >= 11 && x < 31))) || 
    ((y == 41) && ((x >= 13 && x < 29))) || 
    ((y == 42) && ((x >= 15 && x < 27))));

    // mole 2
    assign mole_2_outline = (((y == 22) && ((x >= 46 && x < 48))) || 
    ((y == 23) && ((x >= 44 && x < 50))) || 
    ((y == 24) && ((x >= 42 && x < 45) || (x >= 49 && x < 51))) || 
    ((y == 25) && ((x >= 42 && x < 43) || (x >= 51 && x < 52))) || 
    ((y == 26) && ((x >= 41 && x < 43) || (x >= 44 && x < 46) || (x >= 48 && x < 50) || (x >= 51 && x < 52))) || 
    ((y == 27) && ((x >= 41 && x < 42) || (x >= 45 && x < 46) || (x >= 49 && x < 50) || (x >= 52 && x < 53))) || 
    ((y == 28) && ((x >= 41 && x < 42) || (x >= 52 && x < 53))) || 
    ((y == 29) && ((x >= 41 && x < 42) || (x >= 44 && x < 49) || (x >= 52 && x < 53))) || 
    ((y == 30) && ((x >= 41 && x < 42) || (x >= 44 && x < 46) || (x >= 48 && x < 50) || (x >= 52 && x < 53))) || 
    ((y == 31) && ((x >= 41 && x < 42) || (x >= 45 && x < 49) || (x >= 52 && x < 53))) || 
    ((y == 32) && ((x >= 41 && x < 42) || (x >= 52 && x < 53))) || 
    ((y == 33) && ((x >= 40 && x < 42) || (x >= 51 && x < 53))) || 
    ((y == 34) && ((x >= 39 && x < 43) || (x >= 51 && x < 54))) || 
    ((y == 35) && ((x >= 38 && x < 40) || (x >= 43 && x < 44) || (x >= 49 && x < 51) || (x >= 54 && x < 55))) || 
    ((y == 36) && ((x >= 36 && x < 39) || (x >= 44 && x < 50) || (x >= 55 && x < 57))) || 
    ((y == 37) && ((x >= 35 && x < 45) || (x >= 49 && x < 56) || (x >= 57 && x < 58))) || 
    ((y == 38) && ((x >= 35 && x < 36) || (x >= 39 && x < 44) || (x >= 50 && x < 51) || (x >= 52 && x < 53) || (x >= 54 && x < 55) || (x >= 58 && x < 59))) || 
    ((y == 39) && ((x >= 35 && x < 36) || (x >= 58 && x < 59))) || 
    ((y == 40) && ((x >= 36 && x < 37) || (x >= 57 && x < 58))) || 
    ((y == 41) && ((x >= 37 && x < 39) || (x >= 55 && x < 57))) || 
    ((y == 42) && ((x >= 39 && x < 41) || (x >= 53 && x < 55))) || 
    ((y == 43) && ((x >= 41 && x < 53))));

    assign mole_2_body = (((y == 24) && ((x >= 45 && x < 49))) || 
    ((y == 25) && ((x >= 43 && x < 51))) || 
    ((y == 26) && ((x >= 43 && x < 44) || (x >= 46 && x < 48) || (x >= 50 && x < 51))) || 
    ((y == 27) && ((x >= 42 && x < 44) || (x >= 46 && x < 48) || (x >= 50 && x < 52))) || 
    ((y == 28) && ((x >= 42 && x < 52))) || 
    ((y == 29) && ((x >= 42 && x < 45) || (x >= 49 && x < 52))) || 
    ((y == 30) && ((x >= 42 && x < 44) || (x >= 50 && x < 52))) || 
    ((y == 31) && ((x >= 42 && x < 45) || (x >= 49 && x < 52))) || 
    ((y == 32) && ((x >= 42 && x < 52))) || 
    ((y == 33) && ((x >= 42 && x < 52))) || 
    ((y == 34) && ((x >= 43 && x < 51))) || 
    ((y == 35) && ((x >= 44 && x < 50))));

    assign mole_2_hands = (((y == 30) && ((x >= 46 && x < 48))) || 
    ((y == 35) && ((x >= 40 && x < 42) || (x >= 51 && x < 54))) || 
    ((y == 36) && ((x >= 39 && x < 43) || (x >= 50 && x < 55))));

    assign mole_2_dirt = (((y == 37) && ((x >= 37 && x < 38) || (x >= 45 && x < 49) || (x >= 56 && x < 57))) || 
    ((y == 38) && ((x >= 36 && x < 39) || (x >= 40 && x < 41) || (x >= 42 && x < 43) || (x >= 44 && x < 50) || (x >= 51 && x < 52) || (x >= 53 && x < 54) || (x >= 55 && x < 58))) || 
    ((y == 39) && ((x >= 36 && x < 58))) || 
    ((y == 40) && ((x >= 37 && x < 57))) || 
    ((y == 41) && ((x >= 39 && x < 55))) || 
    ((y == 42) && ((x >= 41 && x < 53))));



    reg [7:0] x, y;
    always @ (posedge clk_25m)
    begin
        x = pixel_index % 96;
        y = pixel_index / 96;

        // mouse
        if (is_mouse(x, y, xpos, ypos)) pixel_data <= mouse;
        
        // "WHACK-A-MOLE"
        else if (is_char(x, y, 8, 8, 87)) pixel_data <= title_text;
        else if (is_char(x, y, 14, 8, 72)) pixel_data <= title_text;
        else if (is_char(x, y, 19, 8, 65)) pixel_data <= title_text;
        else if (is_char(x, y, 24, 8, 67)) pixel_data <= title_text;
        else if (is_char(x, y, 29, 8, 75)) pixel_data <= title_text;
        else if (is_char(x, y, 34, 8, 45)) pixel_data <= title_text;
        else if (is_char(x, y, 40, 8, 65)) pixel_data <= title_text;
        else if (is_char(x, y, 45, 8, 45)) pixel_data <= title_text;
        else if (is_char(x, y, 52, 8, 77)) pixel_data <= title_text;
        else if (is_char(x, y, 57, 8, 79)) pixel_data <= title_text;
        else if (is_char(x, y, 62, 8, 76)) pixel_data <= title_text;
        else if (is_char(x, y, 67, 8, 69)) pixel_data <= title_text;
        
        // "START"
        else if (is_char(x, y, 23, 52, 83)) pixel_data <= subtitle_text;
        else if (is_char(x, y, 28, 52, 84)) pixel_data <= subtitle_text;
        else if (is_char(x, y, 33, 52, 65)) pixel_data <= subtitle_text;
        else if (is_char(x, y, 38, 52, 82)) pixel_data <= subtitle_text;
        else if (is_char(x, y, 43, 52, 84)) pixel_data <= subtitle_text;
        
        // selection
        else if (is_rectangle_border(x, y, rectangle_border_x, rectangle_border_y, rectangle_border_a, rectangle_border_b)) pixel_data <= rectangle_border;
        
        // settings gear
        else if (is_gear(x, y, 64, 54)) pixel_data <= settings_gear;
        
        // mole 1
        else if (mole_1_outline) pixel_data <= mole_outline;
        else if (mole_1_body) pixel_data <= mole_body;
        else if (mole_1_hands) pixel_data <= mole_hands;
        else if (mole_1_dirt) pixel_data <= mole_dirt;

        // mole 2
        else if (mole_2_outline) pixel_data <= mole_outline;
        else if (mole_2_body) pixel_data <= mole_body;
        else if (mole_2_hands) pixel_data <= mole_hands;
        else if (mole_2_dirt) pixel_data <= mole_dirt;
        
        // bomb
        else if (is_bomb(x, y, 68, 33)) pixel_data <= bomb;
        else if (is_bomb_fuse(x, y, 70, 26)) pixel_data <= bomb_fuse;
        else if (is_bomb_fire(x, y, 82, 36)) pixel_data <= bomb_fire;
        
        else pixel_data <= background;
    end
endmodule
