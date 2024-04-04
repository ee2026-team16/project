`timescale 1ns / 1ps

// Engineer: Mohamed Abubaker Mustafa Abdelaal Elsayed


module mole_sequence(input is_master, input input_mole_state0, input_mole_state1, input_mole_state2, input [31:0] input_mole_y0, input_mole_y1, input_mole_y2, input basys_clock, clk_25MHz, reset, left_click, btnC, btnU, btnL, btnR, btnD, input [11:0] xpos, ypos, input [12:0] pixel_index, input [31:0] switch_points, output reg [15:0] oled_data, output reg [31:0] total_points = 0, output reg bomb_defused = 1, output mole_state0, mole_state1, mole_state2, output [31:0] mole_y0, mole_y1, mole_y2);
    parameter BLACK = 16'b00000_000000_00000; // else case
    parameter BLUE = 16'b00000_000000_11111;
    parameter WHITE = 16'b11111_111111_11111;
    parameter RED = 16'b11100_000110_00011;
    parameter ORANGE = 16'b11111_011000_00000;
    parameter BROWN = 16'b01011_001000_00100;
    parameter GREEN = 16'b00000_111111_00000;
    parameter GREY = 16'b01000_010000_01000;
    parameter background = 16'b11100_100101_00111;
    parameter background_green = 16'b00110_110001_00110;
    
    wire clk_1000;
    flexible_clock_module flexible_clock_1000 (basys_clock, 49999, clk_1000);
    
    reg [31:0] x, y, points = 0;
    reg mole_state[2:0], click_mole[2:0], mole_hit[2:0], wrong_hit = 0;
    wire [31:0] generated_mole_count [2:0], generated_mole_position_change[2:0];
    reg [31:0] prev_mole_count [2:0], mole_y[2:0], mole_position_change[2:0], mole_count [2:0], mole_dead_count [2:0], wrong_hit_count = 0, count = 0;
    reg start = 0, moleC, moleR, moleL, mouse_arrow;
    
    assign mole_state0 = mole_state[0];
    assign mole_state1 = mole_state[1];
    assign mole_state2 = mole_state[2];
    assign mole_y0 = mole_y[0];
    assign mole_y1 = mole_y[1];
    assign mole_y2 = mole_y[2];
    
    random_number_generator unit1(basys_clock, prev_mole_count[0], generated_mole_count[0]);
    random_number_generator unit2(basys_clock, prev_mole_count[1], generated_mole_count[1]);
    random_number_generator unit3(basys_clock, prev_mole_count[2], generated_mole_count[2]);
    
    
    random_number_generator unit4(basys_clock, mole_position_change[0], generated_mole_position_change[0]);
    random_number_generator unit5(basys_clock, mole_position_change[1], generated_mole_position_change[1]);
    random_number_generator unit6(basys_clock, mole_position_change[2], generated_mole_position_change[2]);
    
    
    //defuse sequence:
    reg [31:0] defuse_timer = 0, prev_defuse_length = 0, actual_defuse_length = 8;
    reg launch = 0;
    wire [31:0] correct_press_count, generated_defuse_length;
    wire [15:0] defuse_oled_data;
    random_number_generator unit7 (basys_clock, prev_defuse_length, generated_defuse_length);
    
    defuse_sequence unit8 (.basys_clock(basys_clock), 
    .clk_25MHz(clk_25MHz),
    .btnC(btnC), 
    .btnU(btnU), 
    .btnL(btnL), 
    .btnR(btnR),
    .btnD(btnD), 
    .launch(launch), 
    .pixel_index(pixel_index),
    .oled_data(defuse_oled_data),
    .correct_press_count(correct_press_count));

    wire [15:0] points_oled_data;
    point_display unit9(.clk_25MHz(clk_25MHz), .total_points(switch_points + points), .pixel_index(pixel_index), .oled_data(points_oled_data));
    
    
    wire debounced_left_click;
    debounce unit10 (clk_1000, left_click, debounced_left_click);
    
    
    always @ (posedge clk_25MHz) 
    begin
        y = pixel_index / 96;
        x = pixel_index % 96;
        if (start == 0 || !reset) begin
            bomb_defused = 1;
            total_points = 0; 
            mole_y[0] = 5;
            mole_y[1] = 0;
            mole_y[2] = 0; 
            mole_state[0] = 0;
            mole_state[1] = 0;
            mole_state[2] = 0;
            mole_count[0] = 0;
            mole_count[1] = 0;
            mole_count[2] = 0;
            prev_mole_count[0] = 1;
            prev_mole_count[1] = 1;
            prev_mole_count[2] = 1;
            mole_position_change[0] = 1;
            mole_position_change[1] = 1;
            mole_position_change[2] = 1;
            mole_hit[0] = 0;
            mole_hit[1] = 0;
            mole_hit[2] = 0;
            mole_dead_count[0] = 0;
            mole_dead_count[1] = 0;
            mole_dead_count[2] = 0;
            click_mole[0] = 0;
            click_mole[1] = 0;
            click_mole[2] = 0;
            wrong_hit = 0;
            wrong_hit_count = 0;
            start = 1;
            count = 0;
        end
        
        //counters and random variables
        count <= (count == 2500001) ? 0 : count + 1;
        
        prev_mole_count[0] <= generated_mole_count[0] + 1;
        mole_count[0] <= (mole_state[0]) ? ((count == 0) ? mole_count[0] + 1 : mole_count[0]) : 0;
        mole_state[0] <= (is_master) ? (((count == 0) && ((prev_mole_count[0] % 25 == 1 && mole_state[0] == 0) || mole_count[0] == 15)) ? ~mole_state[0] : mole_state[0]) : input_mole_state0;
        
        prev_mole_count[1] <= generated_mole_count[1] + 2; 
        mole_count[1] <= (mole_state[1]) ? ((count == 0) ? mole_count[1] + 1 : mole_count[1]) : 0; 
        mole_state[1] <= (is_master) ? (((count == 0) && ((prev_mole_count[1] % 25 == 1 && mole_state[1] == 0) || (mole_count[1] == 15))) ? ~mole_state[1] : mole_state[1]) : input_mole_state1;
        
        prev_mole_count[2] <= generated_mole_count[2] + 3; 
        mole_count[2] <= (mole_state[2]) ? ((count == 0) ? mole_count[2] + 1 : mole_count[2]) : 0; 
        mole_state[2] <= (is_master) ? (((count == 0) && ((prev_mole_count[2] % 25 == 1 && mole_state[2] == 0) || (mole_count[2] == 15))) ? ~mole_state[2] : mole_state[2]) : input_mole_state2;
        
        mole_position_change[0] <= (count == 0 && mole_state[0] == 0 && !mole_hit[0]) ? generated_mole_position_change[0] + 1 : mole_position_change[0];
        mole_position_change[1] <= (count == 0 && mole_state[1] == 0 && !mole_hit[1]) ? generated_mole_position_change[1] + 2: mole_position_change[1];
        mole_position_change[2] <= (count == 0 && mole_state[2] == 0 && !mole_hit[2]) ? generated_mole_position_change[2] + 3: mole_position_change[2];
        
        
        //display equations
        
        mole_y[1] <= (is_master) ? (32 + 5 - mole_position_change[1] % 12) : input_mole_y1;
        mole_y[0] <= (is_master) ? (32 + 4 - mole_position_change[0] % 12) : input_mole_y0;
        mole_y[2] <= (is_master) ? (32 + 6 - mole_position_change[2] % 12) : input_mole_y2;
        
        moleC = (((x - 48) ** 2 + (y - mole_y[1]) ** 2) <= 64);
        moleL = (((x - 24) ** 2 + (y - mole_y[0]) ** 2) <= 81) || (y > mole_y[0] && y <= mole_y[0] + 9 && x <= 24 + 9 && x >= 24 - 9);
        moleR = (((x - 72) ** 2 + (y - mole_y[2]) ** 2) <= 81) || (y > mole_y[2] && y <= mole_y[2] + 9 && x <= 72 + 9 && x >= 72 - 9);
        
        mouse_arrow = (((x - xpos) ** 2 + (y - ypos) ** 2) < 5);
        
        //displaying (points then moles)
        
        if (launch) begin
            oled_data <= defuse_oled_data;
        end 
        else if (mouse_arrow) begin
            oled_data <= RED;
        end                                                
        else if (moleC) begin
            oled_data <= (mole_state[1]) ? ((!mole_hit[1]) ? (((y == mole_y[1] - 4 || y == mole_y[1] - 3) && (x == 44 || x == 45 || x == 52 || x == 51)) ? WHITE : BROWN) : GREY) : background_green;
        end
        else if (moleL) begin
            oled_data <= (mole_state[0]) ? ((!mole_hit[0]) ? ((((y >= mole_y[0] - 4) && (y <= mole_y[0] - 2)) && (x == 20 || x == 21 || x == 28 || x == 27)) ? WHITE : BROWN) : GREY) : background_green;
        end
        else if (moleR) begin
            oled_data <= (mole_state[2]) ? ((!mole_hit[2]) ? (((y >= mole_y[2] - 4 && y <= mole_y[2] - 2) && (x == 68 || x == 69 || x == 76 || x == 75)) ? WHITE : BROWN) : GREY) : background_green;
        end
        else begin
            oled_data <= points_oled_data;
        end
        
        //mole clicking
        mole_dead_count[0] = (count == 0) ? ((mole_hit[0]) ? mole_dead_count[0] + 1 : 0) : mole_dead_count[0];  
        mole_dead_count[1] = (count == 0) ? ((mole_hit[1]) ? mole_dead_count[1] + 1 : 0) : mole_dead_count[1]; 
        mole_dead_count[2] = (count == 0) ? ((mole_hit[2]) ? mole_dead_count[2] + 1 : 0) : mole_dead_count[2]; 
        wrong_hit_count = (count == 0) ? ((wrong_hit) ? wrong_hit_count + 1 : 0) : wrong_hit_count;
        
        click_mole[0] = debounced_left_click && ((mole_y[0] - ypos) ** 2 + (24 - xpos) ** 2 <= 81);
        click_mole[1] = debounced_left_click && ((mole_y[1] - ypos) ** 2 + (48 - xpos) ** 2 <= 64);
        click_mole[2] = debounced_left_click && ((mole_y[2] - ypos) ** 2 + (72 - xpos) ** 2 <= 81); 
        
        mole_hit[0] = (mole_dead_count[0] > 6) ? 0 : mole_hit[0];
        mole_hit[1] = (mole_dead_count[1] > 6) ? 0 : mole_hit[1];
        mole_hit[2] = (mole_dead_count[2] > 6) ? 0 : mole_hit[2];
        wrong_hit = (wrong_hit_count > 1) ? 0 : wrong_hit;
        
        if (click_mole[0] && mole_state[0] && !mole_hit[0]) begin
            mole_hit[0] <= 1;
            points = points + 2;
        end
        if (click_mole[1] && mole_state[1] && !mole_hit[1]) begin
            mole_hit[1] <= 1;
            points = points + 2;
        end
        if (click_mole[2] && mole_state[2] && !mole_hit[2]) begin
            mole_hit[2] <= 1;
            points = points + 2;
        end   
        
        if (debounced_left_click && !wrong_hit && !(click_mole[0] && mole_state[0]) && !(click_mole[1] && mole_state[1]) && !(click_mole[2] && mole_state[2])) begin
            points = (points > 0) ? points - 1: 0;
            wrong_hit <= 1;
        end
        
        //defuse sequence
        prev_defuse_length <= (count == 0) ? (generated_defuse_length + 1) : prev_defuse_length;
        defuse_timer <= (defuse_timer == 302) ? ((count == 0) ? defuse_timer + 1 : defuse_timer) : 0;
        if (defuse_timer == 300) begin
            launch = 1;
            bomb_defused = 0;
            actual_defuse_length = 4 + (prev_defuse_length % 6);
        end
        if (correct_press_count == actual_defuse_length) begin
            launch = 0;
            bomb_defused = 1;
        end
        total_points <= points + switch_points;
    end
   
endmodule
