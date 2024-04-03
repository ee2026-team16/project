`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Mohamed Abubaker Mustafa Abdelaal Elsayed
//////////////////////////////////////////////////////////////////////////////////


module defuse_sequence(input basys_clock, clk_25MHz, btnC, btnU, btnL, btnR, btnD, launch, input [12:0] pixel_index, output reg [15:0] oled_data, output reg [31:0] correct_press_count = 0);
    parameter BLACK = 16'b00000_000000_00000; // else case
    parameter RED = 16'b11111_000000_00000;
    parameter ORANGE = 16'b11111_011000_00000;
    parameter GREEN = 16'b00000_111111_00000;
    parameter GREY = 16'b01000_010000_01000;
    parameter YELLOW = 16'b11111_111111_00000;
    parameter bomb = 16'b0;
    parameter bomb_fuse = 16'b01110_011101_01110;
    parameter bomb_fire = 16'b11100_001010_00000;
    parameter background = 16'b11100_100101_00111;
    parameter background_green = 16'b00110_110001_00110;
    
    reg [31:0] x, y;
    reg [31:0] state = 1;
    reg [31:0] defuse_state = 1;
    wire [31:0] prev_generated_state, generated_state;
    reg [31:0] count = 0, random_number = 0, show_bomb_count = 0;
    reg button_pressed = 0;
    
    random_number_generator unit(basys_clock, state, generated_state);
   
    reg circleC, circleU, circleL, circleR, circleD;
    
    wire only_btnC, only_btnU, only_btnL, only_btnR, only_btnD;
    assign only_btnC = btnC && !(btnU || btnL || btnR || btnD);
    assign only_btnU = btnU && !(btnC || btnL || btnR || btnD);
    assign only_btnL = btnL && !(btnC || btnU || btnR || btnD);
    assign only_btnR = btnR && !(btnC || btnU || btnL || btnD);
    assign only_btnD = btnD && !(btnC || btnU || btnL || btnR);
    
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
    
    function alert;
        input [31:0] curr_x;
        input [31:0] curr_y;
        input [31:0] origin_x;
        input [31:0] origin_y;
        reg [31:0] x, y;
        begin
            x = curr_x - origin_x;
            y = curr_y - origin_y; 
            if ((x == 1 && y == 0) || 
            (x == 2 && y == 0) || 
            (x == 0 && y == 1) || 
            (x == 3 && y == 1) || 
            (x == 0 && y == 2) || 
            (x == 1 && y == 2) || 
            (x == 2 && y == 2) || 
            (x == 3 && y == 2) || 
            (x == 0 && y == 3) || 
            (x == 3 && y == 3) || 
            (x == 0 && y == 4) || 
            (x == 3 && y == 4) || 
            (x == 5 && y == 0) || 
            (x == 5 && y == 1) || 
            (x == 5 && y == 2) || 
            (x == 5 && y == 3) || 
            (x == 5 && y == 4) || 
            (x == 6 && y == 4) || 
            (x == 7 && y == 4) || 
            (x == 8 && y == 4) || 
            (x == 10 && y == 0) || 
            (x == 11 && y == 0) || 
            (x == 12 && y == 0) || 
            (x == 13 && y == 0) || 
            (x == 10 && y == 1) || 
            (x == 10 && y == 2) || 
            (x == 11 && y == 2) || 
            (x == 12 && y == 2) || 
            (x == 13 && y == 2) || 
            (x == 10 && y == 3) || 
            (x == 10 && y == 4) || 
            (x == 11 && y == 4) || 
            (x == 12 && y == 4) || 
            (x == 13 && y == 4) || 
            (x == 15 && y == 0) || 
            (x == 16 && y == 0) || 
            (x == 17 && y == 0) || 
            (x == 15 && y == 1) || 
            (x == 18 && y == 1) || 
            (x == 15 && y == 2) || 
            (x == 16 && y == 2) || 
            (x == 17 && y == 2) || 
            (x == 15 && y == 3) || 
            (x == 17 && y == 3) || 
            (x == 15 && y == 4) || 
            (x == 18 && y == 4) || 
            (x == 20 && y == 0) || 
            (x == 21 && y == 0) || 
            (x == 22 && y == 0) || 
            (x == 21 && y == 1) || 
            (x == 21 && y == 2) || 
            (x == 21 && y == 3) || 
            (x == 21 && y == 4) || 
            (x == 24 && y == 0) || 
            (x == 24 && y == 1) || 
            (x == 24 && y == 3) || 
            (x == 24 && y == 4) || 
            (x == 25 && y == 0) || 
            (x == 25 && y == 1) || 
            (x == 25 && y == 3) || 
            (x == 25 && y == 4) || 
            (x == 28 && y == 0) || 
            (x == 29 && y == 0) || 
            (x == 30 && y == 0) || 
            (x == 28 && y == 1) || 
            (x == 31 && y == 1) || 
            (x == 28 && y == 2) || 
            (x == 31 && y == 2) || 
            (x == 28 && y == 3) || 
            (x == 31 && y == 3) || 
            (x == 28 && y == 4) || 
            (x == 29 && y == 4) || 
            (x == 30 && y == 4) || 
            (x == 33 && y == 0) || 
            (x == 34 && y == 0) || 
            (x == 35 && y == 0) || 
            (x == 36 && y == 0) || 
            (x == 33 && y == 1) || 
            (x == 33 && y == 2) || 
            (x == 34 && y == 2) || 
            (x == 35 && y == 2) || 
            (x == 36 && y == 2) || 
            (x == 33 && y == 3) || 
            (x == 33 && y == 4) || 
            (x == 34 && y == 4) || 
            (x == 35 && y == 4) || 
            (x == 36 && y == 4) || 
            (x == 38 && y == 0) || 
            (x == 39 && y == 0) || 
            (x == 40 && y == 0) || 
            (x == 41 && y == 0) || 
            (x == 38 && y == 1) || 
            (x == 38 && y == 2) || 
            (x == 39 && y == 2) || 
            (x == 40 && y == 2) || 
            (x == 41 && y == 2) || 
            (x == 38 && y == 3) || 
            (x == 38 && y == 4) || 
            (x == 43 && y == 0) || 
            (x == 46 && y == 0) || 
            (x == 43 && y == 1) || 
            (x == 46 && y == 1) || 
            (x == 43 && y == 2) || 
            (x == 46 && y == 2) || 
            (x == 43 && y == 3) || 
            (x == 46 && y == 3) || 
            (x == 44 && y == 4) || 
            (x == 45 && y == 4) || 
            (x == 48 && y == 0) || 
            (x == 49 && y == 0) || 
            (x == 50 && y == 0) || 
            (x == 51 && y == 0) || 
            (x == 48 && y == 1) || 
            (x == 48 && y == 2) || 
            (x == 49 && y == 2) || 
            (x == 50 && y == 2) || 
            (x == 51 && y == 2) || 
            (x == 51 && y == 3) || 
            (x == 48 && y == 4) || 
            (x == 49 && y == 4) || 
            (x == 50 && y == 4) || 
            (x == 51 && y == 4) || 
            (x == 53 && y == 0) || 
            (x == 54 && y == 0) || 
            (x == 55 && y == 0) || 
            (x == 56 && y == 0) || 
            (x == 53 && y == 1) || 
            (x == 53 && y == 2) || 
            (x == 54 && y == 2) || 
            (x == 55 && y == 2) || 
            (x == 56 && y == 2) || 
            (x == 53 && y == 3) || 
            (x == 53 && y == 4) || 
            (x == 54 && y == 4) || 
            (x == 55 && y == 4) || 
            (x == 56 && y == 4) || 
            (x == 59 && y == 0) || 
            (x == 60 && y == 0) || 
            (x == 61 && y == 0) || 
            (x == 59 && y == 1) || 
            (x == 62 && y == 1) || 
            (x == 59 && y == 2) || 
            (x == 60 && y == 2) || 
            (x == 61 && y == 2) || 
            (x == 59 && y == 3) || 
            (x == 62 && y == 3) || 
            (x == 59 && y == 4) || 
            (x == 60 && y == 4) || 
            (x == 61 && y == 4) || 
            (x == 65 && y == 0) || 
            (x == 66 && y == 0) || 
            (x == 64 && y == 1) || 
            (x == 67 && y == 1) || 
            (x == 64 && y == 2) || 
            (x == 67 && y == 2) || 
            (x == 64 && y == 3) || 
            (x == 67 && y == 3) || 
            (x == 65 && y == 4) || 
            (x == 66 && y == 4) || 
            (x == 69 && y == 0) || 
            (x == 73 && y == 0) || 
            (x == 69 && y == 1) || 
            (x == 70 && y == 1) || 
            (x == 72 && y == 1) || 
            (x == 73 && y == 1) || 
            (x == 69 && y == 2) || 
            (x == 71 && y == 2) || 
            (x == 73 && y == 2) || 
            (x == 69 && y == 3) || 
            (x == 73 && y == 3) || 
            (x == 69 && y == 4) || 
            (x == 73 && y == 4) || 
            (x == 75 && y == 0) || 
            (x == 76 && y == 0) || 
            (x == 77 && y == 0) || 
            (x == 75 && y == 1) || 
            (x == 78 && y == 1) || 
            (x == 75 && y == 2) || 
            (x == 76 && y == 2) || 
            (x == 77 && y == 2) || 
            (x == 75 && y == 3) || 
            (x == 78 && y == 3) || 
            (x == 75 && y == 4) || 
            (x == 76 && y == 4) || 
            (x == 77 && y == 4) || 
            (x == 80 && y == 0) || 
            (x == 80 && y == 1) || 
            (x == 80 && y == 3) ) begin
                alert = 1;
            end
            else begin
                alert = 0;
            end
        end
    endfunction
    

    always @ (posedge clk_25MHz)
    begin
        y = pixel_index / 96;
        x = pixel_index % 96;
        
        if (!launch) begin
            count = 0;
            defuse_state = 1;
            correct_press_count = 0;
            show_bomb_count = 0;
        end
                   
        count <= (count == 12500001) ? 0 : count + 1;
        show_bomb_count <= (count == 0) ? show_bomb_count + 1 : show_bomb_count;
  
        circleC = (((y - 32) ** 2 + (x - 48) ** 2) < 64);
        circleL = (((y - 32) ** 2 + (x - 28) ** 2) < 64);
        circleR = (((y - 32) ** 2 + (x - 68) ** 2) < 64);
        circleU = (((y - 14) ** 2 + (x - 48) ** 2) < 64);
        circleD = (((y - 50) ** 2 + (x - 48) ** 2) < 64);
        
        
        state <= ((defuse_state == 1 && only_btnC) || (defuse_state == 2 && only_btnL) || (defuse_state == 3 && only_btnR) || (defuse_state == 4 && only_btnU) || (defuse_state == 5 && only_btnD)) ? (generated_state) : state;
        defuse_state <= state % 5 + 1;
        button_pressed <= (count == 0) ? 0 : button_pressed;
        if (!button_pressed && ((defuse_state == 1 && only_btnC) || (defuse_state == 2 && only_btnL) || (defuse_state == 3 && only_btnR) || (defuse_state == 4 && only_btnU) || (defuse_state == 5 && only_btnD))) begin
            correct_press_count <= correct_press_count + 1;
            button_pressed = 1;
        end
        //prints: Alert
        if (show_bomb_count > 6) begin
            if (alert(x, y, 1, 1)) begin
                oled_data <= BLACK;
            end
            else if (circleC) begin
                oled_data <= (defuse_state == 1) ? YELLOW : GREY;
            end
            else if (circleL) begin
                oled_data <= (defuse_state == 2) ? YELLOW : GREY;
            end
            else if (circleR) begin
                oled_data <= (defuse_state == 3) ? YELLOW : GREY;
            end
            else if (circleU) begin
                oled_data <= (defuse_state == 4) ? YELLOW : GREY;
            end
            else if (circleD) begin
                oled_data <= (defuse_state == 5) ? YELLOW : GREY;
            end
            else begin
                oled_data <= background_green;
            end
        end
        else begin
            if (is_bomb_fuse(x, y, 70, 25)) oled_data <= bomb_fuse;
            else if (is_bomb(x, y, 68, 33)) oled_data <= bomb;
            else if (is_bomb_fire(x, y, 84, 35)) oled_data <= bomb_fire;
            else oled_data <= background_green;
        end  
    end
endmodule