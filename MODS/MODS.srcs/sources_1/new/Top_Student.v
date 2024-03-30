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
    inout PS2Clk, PS2Data
);
    //  clocks
    wire clk_25m, clk_12p5m, clk_6p25m, clk_1000, clk_1;
    flexible_clock_module flexible_clock_module_25m (
        .basys_clock(clk),
        .my_m_value(1),
        .my_clk(clk_25m)
    );
    flexible_clock_module flexible_clock_module_12p5m (
        .basys_clock(clk),
        .my_m_value(3),
        .my_clk(clk_12p5m)
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
    flexible_clock_module flexible_clock_module_1 (
        .basys_clock(clk),
        .my_m_value(49999999),
        .my_clk(clk_1)
    );
    
    // debounced buttons
    wire debounced_btnC, debounced_btnU, debounced_btnL, debounced_btnR, debounced_btnD;
    debounce(clk_1000, btnC, debounced_btnC);
    debounce(clk_1000, btnU, debounced_btnU);
    debounce(clk_1000, btnL, debounced_btnL);
    debounce(clk_1000, btnR, debounced_btnR);
    debounce(clk_1000, btnD, debounced_btnD);
    
    // ---------- oled ----------
    // constants
    reg [15:0] black = 16'b0;
    reg [15:0] white = 16'b11111_111111_11111;
    
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
    
//    assign led[15] = left;
//    assign led[14] = middle;
//    assign led[13] = right;
    
    // ---------- paint ----------
    //  inputs
    wire enable; // disable = 0
    assign enable = sw[8];
    
    wire paint_reset;
    assign paint_reset = sw[8] == 0 || right;
    
    //  outputs
    wire [15:0] colour_chooser;
    
    wire [6:0] paint_seg;
    //  initialize
    paint(
        .mouse_x(xpos),
        .mouse_y(ypos),
        .mouse_l(left),
        .reset(paint_reset),
        .pixel_index(pixel_index),
        .enable(enable),
        .clk_100M(clk),
        .clk_25M(clk_25m),
        .clk_12p5M(clk_12p5m),
        .clk_6p25M(clk_6p25m),
        .slow_clk(clk_1),
        .seg(paint_seg),
//        .led(led),
        .colour_chooser(colour_chooser)
    );

    // ---------- tasks ----------
    wire clicked_start, clicked_settings;
    wire [15:0] main_menu_pixel_data;
    main_menu(clk, pixel_index, main_menu_pixel_data, debounced_btnC, debounced_btnL, debounced_btnR, clicked_start, clicked_settings);
    
    wire clicked_back;
    wire [15:0] settings_menu_pixel_data;
    wire [4:0] volume_level; // goes from 0 to 9
    settings_menu(clk, pixel_index, settings_menu_pixel_data, debounced_btnC, debounced_btnU, debounced_btnL, debounced_btnR, debounced_btnD, clicked_back, volume_level);
    
    // ---------- state machine ----------
    reg [31:0] MAIN = 0;
    reg [31:0] SETTINGS = 1;
    reg [31:0] START = 2;
    
    reg [31:0] state;
    
    initial
    begin
        state = MAIN;
    end
        
    always @ (posedge clk)
    begin
        if (state == MAIN && clicked_start) state <= START;
        else if (state == MAIN && clicked_settings) state <= SETTINGS;
        else if (state == SETTINGS && clicked_back) state <= MAIN;
        
        case (state)
            MAIN: pixel_data <= main_menu_pixel_data;
            SETTINGS: pixel_data <= settings_menu_pixel_data;
            START: pixel_data <= 16'b11111_000000_00000;
            default: pixel_data <= black;
        endcase
    end
    
    
    
endmodule