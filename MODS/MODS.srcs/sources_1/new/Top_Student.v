`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: Mohamed
//  STUDENT B NAME: Joshua
//  STUDENT C NAME: Jun Yong
//  STUDENT D NAME: Sean
//
//////////////////////////////////////////////////////////////////////////////////


module Top_Student (
    input clk,
    input [15:0] sw,
    output [15:0] led,
    output [6:0] seg,
    output dp,
    output [3:0] an,
    input btnC, btnU, btnL, btnR, btnD,
    output [7:0] JC,
    output [7:0] JB,
    inout PS2Clk, PS2Data
);
    //  clocks
    wire clk_25m, clk_6p25m, clk_1000;
    flexible_clock_module flexible_clock_module_25m (
        .basys_clock(clk),
        .my_m_value(1),
        .my_clk(clk_25m)
    );
    flexible_clock_module flexible_clock_module_6p25m (
        .basys_clock(clk),
        .my_m_value(7),
        .my_clk(clk_6p25m)
    );
    flexible_clock_module flexible_clock_module_1000 (
        .basys_clock(clk),
        .my_m_value(49999),
        .my_clk(clk_1000)
    );
    
    // ---------- oled ----------    
    //  inputs
    reg reset = 0;
    reg [15:0] pixel_data;
    
    //  outputs
    wire frame_begin;
    wire [12:0] pixel_index;
    wire sending_pixels;
    wire sample_pixel;
    
    //  initialize
    Oled_Display(
        .clk(clk_6p25m), 
        .reset(reset), 
        .frame_begin(frame_begin), 
        .sending_pixels(sending_pixels),
        .sample_pixel(sample_pixel),
        .pixel_index(pixel_index),
        .pixel_data(pixel_data),
        .cs(JC[0]), 
        .sdin(JC[1]), 
        .sclk(JC[3]), 
        .d_cn(JC[4]), 
        .resn(JC[5]), 
        .vccen(JC[6]),
        .pmoden(JC[7])
    );
    
    // ---------- mouse ----------
    //  inputs
    reg rst = 0;
    reg [11:0] value = 12'b0;
    reg setx, sety, setmax_x, setmax_y = 0;
    
    //  outputs
    wire [11:0] xpos, ypos;
    wire [3:0] zpos;
    wire left, middle, right;
    wire new_event;
        
    //  initialize
    MouseCtl(
        .clk(clk),
        .rst(rst),
        .value(value),
        .setx(setx),
        .sety(sety),
        .setmax_x(setmax_x),
        .setmax_y(setmax_y),
        .xpos(xpos),
        .ypos(ypos),
        .zpos(zpos),
        .left(left),
        .middle(middle),
        .right(right),
        .new_event(new_event),
        .ps2_clk(PS2Clk),
        .ps2_data(PS2Data)
    );
    
    // ---------- tasks ----------
    // debounced buttons
    wire debounced_btnC, debounced_btnU, debounced_btnL, debounced_btnR, debounced_btnD;
    debounce(clk_1000, btnC, debounced_btnC);
    debounce(clk_1000, btnU, debounced_btnU);
    debounce(clk_1000, btnL, debounced_btnL);
    debounce(clk_1000, btnR, debounced_btnR);
    debounce(clk_1000, btnD, debounced_btnD);

    // debounced mouse left
    wire debounced_left;
    debounce(clk_1000, left, debounced_left);

    wire clicked_start, clicked_settings_main;
    wire clicked_settings;
    wire [15:0] main_menu_pixel_data;
    main_menu(clk, pixel_index, main_menu_pixel_data, debounced_btnC, debounced_btnL, debounced_btnR, xpos, ypos, debounced_left, clicked_start, clicked_settings_main);
    
    wire clicked_back;
    wire [15:0] settings_menu_pixel_data;
    wire [4:0] volume_level; // goes from 0 to 9
    wire [4:0] animation_level; // goes from 0 to 9
    settings_menu(clk, pixel_index, settings_menu_pixel_data, debounced_btnC, debounced_btnU, debounced_btnL, debounced_btnR, debounced_btnD, xpos, ypos, debounced_left, clicked_back, volume_level, animation_level);
    
    wire clicked_home_win;
    wire clicked_home_lose;
    wire clicked_settings_win;
    wire clicked_settings_lose;
    wire clicked_home;
    wire [15:0] game_over_win_pixel_data;
    wire [15:0] game_over_lose_pixel_data;
    game_over_menu game_over_win_menu(clk, pixel_index, game_over_win_pixel_data, 1, debounced_btnC, debounced_btnL, debounced_btnR, xpos, ypos, debounced_left, clicked_home_win, clicked_settings_win);
    game_over_menu game_over_lose_menu(clk, pixel_index, game_over_lose_pixel_data, 0, debounced_btnC, debounced_btnL, debounced_btnR, xpos, ypos, debounced_left, clicked_home_lose, clicked_settings_lose);
    
    // wire clicked_home_tutorial_page_1;
    // wire clicked_next_tutorial_page_1;
    // wire clicked_back_tutorial_page_2;
    // wire clicked_next_tutorial_page_2;
    // wire clicked_back_tutorial_page_3;
    // wire clicked_home_tutorial_page_3;
    // wire [15:0] tutorial_menu_page_1_pixel_data;
    // wire [15:0] tutorial_menu_page_2_pixel_data;
    // wire [15:0] tutorial_menu_page_3_pixel_data;
    // tutorial_menu_page_1(clk, pixel_index, tutorial_menu_page_1_pixel_data, debounced_btnC, debounced_btnL, debounced_btnR, clicked_home_tutorial_page_1, clicked_next_tutorial_page_1);
    // tutorial_menu_page_2(clk, pixel_index, tutorial_menu_page_2_pixel_data, debounced_btnC, debounced_btnL, debounced_btnR, clicked_back_tutorial_page_2, clicked_next_tutorial_page_2);
    // tutorial_menu_page_3(clk, pixel_index, tutorial_menu_page_3_pixel_data, debounced_btnC, debounced_btnL, debounced_btnR, clicked_back_tutorial_page_3, clicked_home_tutorial_page_3);
        
    assign clicked_home = clicked_home_win || clicked_home_lose;
    assign clicked_settings = clicked_settings_main || clicked_settings_win || clicked_settings_lose;

    reg wipe_main_settings_active = 0;
    wire wipe_main_settings_end;
    wire [15:0] wipe_main_settings_pixel_data;
    wipe_animation wipe_main_settings(clk, pixel_index, wipe_main_settings_pixel_data, main_menu_pixel_data, settings_menu_pixel_data, wipe_main_settings_active, wipe_main_settings_end, animation_level);

    reg wipe_settings_main_active = 0;
    wire wipe_settings_main_end;
    wire [15:0] wipe_settings_main_pixel_data;
    wipe_animation wipe_settings_main(clk, pixel_index, wipe_settings_main_pixel_data, settings_menu_pixel_data, main_menu_pixel_data, wipe_settings_main_active, wipe_settings_main_end, animation_level);

    reg fade_win_main_active = 0;
    wire fade_win_main_end;
    wire [15:0] fade_win_main_pixel_data;
    fade_animation(clk, pixel_index, fade_win_main_pixel_data, game_over_win_pixel_data, main_menu_pixel_data, fade_win_main_active, fade_win_main_end, animation_level);

    reg fade_lose_main_active = 0;
    wire fade_lose_main_end;
    wire [15:0] fade_lose_main_pixel_data;
    fade_animation(clk, pixel_index, fade_lose_main_pixel_data, game_over_lose_pixel_data, main_menu_pixel_data, fade_lose_main_active, fade_lose_main_end, animation_level);
    
    reg game_start; //game_start = 1 is start, 0 is not start
    wire game_stop; //game_stop = 1 is stop, 0 is not stop
    wire game_moving; //game_moving = 1 is moving, 0 is not moving

    Count_Down_Timer timer(
        .pb_start(game_start),
        .basys_clk(clk),
        .seg(seg),
        .dp(dp),
        .an(an),
        .stopped(game_stop),
        .moving(game_moving)
    );
    
    wire [31:0] points;
    
    wire [15:0] mole_sequence_pixel_data;
    wire [31:0] total_points, mole_y [2:0];
    wire bomb_defused, mole_state [2:0];
    
    mole_sequence game(
        .is_master(1),
        .input_mole_state0(0),
        .input_mole_state1(0), 
        .input_mole_state2(0),
        .input_mole_y0(0), 
        .input_mole_y1(0), 
        .input_mole_y2(0),
        .basys_clock(clk), 
        .clk_25MHz(clk_25m), 
        .reset(game_stop),
        .left_click(left),
        .btnC(btnC), 
        .btnU(btnU),
        .btnL(btnL),
        .btnR(btnR),
        .btnD(btnD),
        .xpos(xpos), 
        .ypos(ypos),
        .pixel_index(pixel_index), 
        .switch_points(points),
        .oled_data(mole_sequence_pixel_data),
        .total_points(total_points),
        .bomb_defused(bomb_defused),
        .mole_state0(mole_state[0]),
        .mole_state1(mole_state[1]),
        .mole_state2(mole_state[2]),
        .mole_y0(mole_y[0]),
        .mole_y1(mole_y[1]),
        .mole_y2(mole_y[2])
    );
    
    LED_Switch_Random unit(
        .enable(game_moving),
        .defuse(bomb_defused),
        .stop(game_stop),
        .basys_clk(clk),
        .sw(sw),
        .led(led),
        .points(points)
        );
    
    Music_player Music(
        .volume(volume_level), //assume 0 - 9;
        .start(1),
        .clk(clk_25m),
        .o_audio(JB[0]),
        .gain(JB[1]),
        .shutdown(JB[3])
    );
    
    // ---------- state machine ----------
    reg [3:0] MAIN = 0;
    reg [3:0] SETTINGS = 1;
    reg [3:0] START = 2;
    reg [3:0] GAME_OVER_WIN = 3;
    reg [3:0] GAME_OVER_LOSE = 4;
    // reg [3:0] TUTORIAL_PAGE_1 = 4'b0101;
    // reg [3:0] TUTORIAL_PAGE_2 = 4'b0110;
    // reg [3:0] TUTORIAL_PAGE_3 = 4'b0111;
    reg [3:0] WIPE_MAIN_SETTINGS = 5;
    reg [3:0] WIPE_SETTINGS_MAIN = 6;
    reg [3:0] FADE_WIN_MAIN = 7;
    reg [3:0] FADE_LOSE_MAIN = 8;
    
    reg [3:0] state;

    initial
    begin
        state = MAIN;
    end
        
    always @ (posedge clk)
    begin
        if (state == MAIN && clicked_start) state <= START;
        else if (state == START && game_stop) state <= GAME_OVER_WIN; //go to game_over directly
        else if (state == MAIN && clicked_settings) begin state <= WIPE_MAIN_SETTINGS; wipe_main_settings_active <= 1; end
        else if (state == WIPE_MAIN_SETTINGS && wipe_main_settings_end) begin state <= SETTINGS; wipe_main_settings_active <= 0; end
        // else if (state == MAIN && clicked_tutorial) state <= TUTORIAL_PAGE_1;
        else if (state == SETTINGS && clicked_back) begin state <= WIPE_SETTINGS_MAIN; wipe_settings_main_active <= 1; end
        else if (state == WIPE_SETTINGS_MAIN && wipe_settings_main_end) begin state <= MAIN; wipe_settings_main_active <= 0; end
        else if (state == GAME_OVER_WIN && clicked_home) begin state <= FADE_WIN_MAIN; fade_win_main_active <= 1; end
        else if (state == FADE_WIN_MAIN && fade_win_main_end) begin state <= MAIN; fade_win_main_active <= 0; end
        else if (state == GAME_OVER_LOSE && clicked_home) begin state <= FADE_LOSE_MAIN; fade_lose_main_active <= 1; end
        else if (state == FADE_LOSE_MAIN && fade_lose_main_end) begin state <= MAIN; fade_lose_main_active <= 0; end
        else if ((state == GAME_OVER_WIN || state == GAME_OVER_LOSE) && clicked_settings) state <= SETTINGS;
        // else if (state == TUTORIAL_PAGE_1 && clicked_home_tutorial_page_1) state <= MAIN;
        // else if (state == TUTORIAL_PAGE_1 && clicked_next_tutorial_page_1) state <= TUTORIAL_PAGE_2;
        // else if (state == TUTORIAL_PAGE_2 && clicked_back_tutorial_page_2) state <= TUTORIAL_PAGE_1;
        // else if (state == TUTORIAL_PAGE_2 && clicked_next_tutorial_page_2) state <= TUTORIAL_PAGE_3;
        // else if (state == TUTORIAL_PAGE_3 && clicked_back_tutorial_page_3) state <= TUTORIAL_PAGE_2;
        // else if (state == TUTORIAL_PAGE_3 && clicked_home_tutorial_page_3) state <= MAIN;
        
        game_start = (state == START) ? 1 : 0;
        
        case (state)
            MAIN: pixel_data <= main_menu_pixel_data;
            SETTINGS: pixel_data <= settings_menu_pixel_data;
            START: pixel_data <= mole_sequence_pixel_data;
            GAME_OVER_WIN: pixel_data <= game_over_win_pixel_data;
            GAME_OVER_LOSE: pixel_data <= game_over_lose_pixel_data;
            // TUTORIAL_PAGE_1: pixel_data <= tutorial_menu_page_1_pixel_data;
            // TUTORIAL_PAGE_2: pixel_data <= tutorial_menu_page_2_pixel_data;
            // TUTORIAL_PAGE_3: pixel_data <= tutorial_menu_page_3_pixel_data;
            WIPE_MAIN_SETTINGS: pixel_data <= wipe_main_settings_pixel_data;
            WIPE_SETTINGS_MAIN: pixel_data <= wipe_settings_main_pixel_data;
            FADE_WIN_MAIN: pixel_data <= fade_win_main_pixel_data;
            FADE_LOSE_MAIN: pixel_data <= fade_lose_main_pixel_data;
            default: pixel_data <= 16'b0;
        endcase
    end
    
endmodule