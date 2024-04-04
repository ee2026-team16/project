`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/26/2024 04:43:40 PM
// Design Name: 
// Module Name: Count_Down_Timer
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


module Count_Down_Timer(
    input pb_start,
    input basys_clk,
    output [6:0] seg,
    output dp,
    output [3:0] an,
    output stop
    );
   
    wire clk_1Hz;
    flexible_clock_module flexible_clock_module_1Hz (
        .basys_clock(basys_clk),
        .my_m_value(49999999),
        .my_clk(clk_1Hz)
    ); 
    
    wire clk_100Hz;
    flexible_clock_module flexible_clock_module_100Hz (
        .basys_clock(basys_clk),
        .my_m_value(499999),
        .my_clk(clk_100Hz)
    ); 
    
    reg [31:0] timer_count = 90;
    reg digit = 0;
    reg [6:0] seg_display;
    reg [3:0] an_display;
    reg done = 1; //1 is done, 0 is not done
    reg [3:0]timer_digit;
    assign seg = seg_display;
    assign an = an_display;
    assign dp = 1;
    assign stop = done; //stop = 1 is stopped, stop = 0 is not stopped
       
    always @ (posedge clk_1Hz)
    begin
        if(done == 0)
        begin
            timer_count <= (timer_count == 0)? 0: timer_count - 1;
        end
        else
        begin
            timer_count = 90;
        end
    end 
    
    always @ (posedge clk_100Hz)
    begin
        if(done==1)
        begin
            if(pb_start == 1)
            begin
                done = 0;
            end
            else
            begin
                seg_display = 7'b1111111;
                an_display = 4'b1110; 
            end
        end
        else
            begin
            if(timer_count == 0)
            begin
                done = 1;
            end
            else
            begin
                if(digit == 0)
                    begin
                    an_display = 4'b1110;   
                    timer_digit = timer_count%10;        
                    end
                else
                    begin
                    an_display = 4'b1101;
                    timer_digit = timer_count/10;  
                    end
                digit = ~digit;
                case(timer_digit)
                9:
                    begin
                    seg_display = 7'b0010000;
                    end
                8:
                    begin
                    seg_display = 7'b0000000;
                    end
                7:
                    begin
                    seg_display = 7'b1111000;
                    end
                6:
                    begin
                    seg_display = 7'b0000010;
                    end
                5:
                    begin
                    seg_display = 7'b0010010;
                    end
                4:
                    begin
                    seg_display = 7'b0011001;
                    end
                3:
                    begin
                    seg_display = 7'b0110000;
                    end
                2:
                    begin
                    seg_display = 7'b0100100;
                    end
                1:
                    begin
                    seg_display = 7'b1111001;
                    end
                0:
                    begin
                    seg_display = 7'b1000000;
                    end
                endcase
            end
        end
    end
       
endmodule