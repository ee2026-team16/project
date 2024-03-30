`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.03.2024 20:10:04
// Design Name: 
// Module Name: random_number_generator_led
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


module random_number_generator_led(input basys_clock, input [31:0] prev_number, output reg [31:0] new_number);
    always @ (posedge basys_clock)
    begin
        new_number = prev_number ^ ((prev_number << 13 & 32'hFFFFFFFF));
        new_number = new_number ^ ((prev_number >> 17 & 32'hFFFFFFFF));
        new_number = new_number ^ ((prev_number << 5 & 32'hFFFFFFFF));
    end
    
endmodule