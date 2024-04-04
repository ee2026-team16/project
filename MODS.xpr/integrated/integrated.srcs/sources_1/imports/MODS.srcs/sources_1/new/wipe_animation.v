`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.04.2024 00:29:54
// Design Name: 
// Module Name: wipe_animation
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


module wipe_animation(
    input clk,
    input [12:0] pixel_index,
    output reg [15:0] pixel_data,
    input [15:0] pixel_data_old,
    input [15:0] pixel_data_new,
    input is_active,
    output reg has_end,
    input [4:0] duration
);
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
    
    reg [15:0] animation_counter;
    always @ (posedge clk_10)
    begin
        if (is_active == 0)
        begin
            animation_counter <= 0;
            has_end <= 0;
        end
        else if (animation_counter == 25200) // LCM of 10, 20, 30, 40, 50, 60, 70, 80, 90, 100
        begin
            has_end <= 1;
        end
        else
        begin
            animation_counter <= (animation_counter + 25200 / (10 * duration));
        end
    end

    wire [7:0] x_boundary;
    assign x_boundary = 96 * animation_counter / 25200;

    reg [7:0] x, y;
    always @ (posedge clk_25m)
    begin
        x = pixel_index % 96;
        y = pixel_index / 96;

        if (x == x_boundary) pixel_data <= 16'b00000_000000_00000;
        else if (x < x_boundary) pixel_data <= pixel_data_new;
        else if (x > x_boundary) pixel_data <= pixel_data_old;
    end
endmodule
