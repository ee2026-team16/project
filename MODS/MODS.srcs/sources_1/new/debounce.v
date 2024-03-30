`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.03.2024 21:46:31
// Design Name: 
// Module Name: debounce
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


//module debounce(input clk, btn_in, output reg btn_out = 0);    
//    reg is_debounce = 0;
//    reg [31:0] debounce_counter = 32'b0;
    
//    wire clk_1000;
//    flexible_clock_module flexible_clock_1000 (clk, 49999, clk_1000);
    
//    reg prev_btn;
//    always @ (posedge clk_1000)
//    begin
//        prev_btn <= btn_in;
        
//        if (prev_btn == 1 && btn_in == 0)
//            begin
//                btn_out <= 1;
//                is_debounce <= 1;
//            end
//        else
//            begin
//                btn_out <= 0;
//            end
        
//        if (is_debounce)
//            begin
//                if (debounce_counter == 200)
//                    begin
//                        is_debounce <= 0;
//                        debounce_counter <= 0;
//                    end
//                else
//                    begin
//                        debounce_counter <= debounce_counter + 1;
//                    end
//            end
//    end
//endmodule

module debounce(input clk_1000, btn_in, output reg btn_out = 0);    
    reg state = 0;
    reg [31:0] debounce_counter = 32'b0;
    
    always @ (posedge clk_1000)
    begin
        case (state)
            0:
                begin
                    if (btn_in == 1)
                        begin
                            btn_out <= 1;
                            state <= 1;
                        end
                end
            1:
                begin
                    if (debounce_counter == 200)
                        begin
                            state <= 0;
                            debounce_counter <= 0;
                        end
                    else
                        begin
                            btn_out <= 0;
                            debounce_counter <= debounce_counter + 1;
                        end
                end
        endcase
    end
endmodule