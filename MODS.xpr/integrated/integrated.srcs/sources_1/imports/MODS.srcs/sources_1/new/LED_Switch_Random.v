`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.03.2024 19:08:15
// Design Name: 
// Module Name: LED_Switch_Random
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


module LED_Switch_Random(
    input enable,
    input defuse,
    input stop,
    input basys_clk,
    input [15:0] sw,
    output [15:0] led,
    output reg [31:0] points = 0
    );
   
    wire clk_1Hz;
    flexible_clock_module flexible_clock_module_1Hz (
        .basys_clock(basys_clk),
        .my_m_value(49999999),
        .my_clk(clk_1Hz)
    );   
    
    wire clk_10Hz;
    flexible_clock_module flexible_clock_module_10Hz (
        .basys_clock(basys_clk),
        .my_m_value(4999999),
        .my_clk(clk_10Hz)
    ); 
    
    wire clk_10kHz;
    flexible_clock_module flexible_clock_module_10kHz (
        .basys_clock(basys_clk),
        .my_m_value(4999),
        .my_clk(clk_10kHz)
    ); 
    
    reg [15:0] old_led_number = 16'h5050;
    wire [15:0] new_led_number;
    reg [15:0] led_state; 
    reg [15:0] old_switch_state;
    reg [15:0] changed; // 0 is not changed, 1 is changed
    reg [15:0] blinking; // then assign blinking & led_state, 0 for blinking, 1 for no blinking
    reg blink_check; // 1 is blinking. 0 is not blinking
    reg [2:0] time_counter;
    
    reg [15:0] cannot_blinking_score; // 0 is can, 1 is cannot
    reg done; // for seeing of points
    
    random_number_generator_led unit(
    .basys_clock(clk_10kHz),
    .prev_number(old_led_number),
    .new_number(new_led_number)
    );
  
    assign led = led_state & blinking; 
    always @ (posedge clk_10kHz)
    begin
    if((enable== 1) &&(stop == 0))
    begin
        done = 0;
    end
    else
    begin
        done = 1;
    end
    if(done == 0)
    begin
        if(defuse == 1)
        begin
            if(blink_check == 0)
            begin
            cannot_blinking_score = 0;
            if(changed[0] == 0)
            begin
                if((led_state[0] == 1)&& (sw[0]==~old_switch_state[0]))
                    begin
                    points = points+ 1;
                    changed[0] = 1;
                    led_state[0] = 0;
                    end
                else
                    begin
                    changed[0] = 0;
                    led_state[0] = new_led_number[0];
                    end
            end
            else
            begin
                changed[0] = 1;
                led_state[0] = 0;
            end
            if(changed[1] == 0)
            begin
                if((led_state[1] == 1)&& (sw[1]==~old_switch_state[1]))
                begin
                    points = points+ 1;
                    changed[1] = 1;
                    led_state[1] = 0;
                end
                else
                begin
                    changed[1] = 0;
                    led_state[1] = new_led_number[1];
                end
            end
            else
            begin
                changed[1] = 1;
                led_state[1] = 0;
            end         
            if(changed[2] == 0)
            begin
                if((led_state[2] == 1)&& (sw[2]==~old_switch_state[2]))
                begin
                    points = points+ 1;
                    changed[2] = 1;
                    led_state[2] = 0;
                end
                else
                begin
                    changed[2] = 0;
                    led_state[2] = new_led_number[2];
                end
            end
            else
            begin
                changed[2] = 1;
                led_state[2] = 0;
            end
            if(changed[3] == 0)
            begin
                if((led_state[3] == 1)&& (sw[3]==~old_switch_state[3]))
                begin
                    points = points+ 1;
                    changed[3] = 1;
                    led_state[3] = 0;
                end
                else
                begin
                    changed[3] = 0;
                    led_state[3] = new_led_number[3];
                end
            end
            else
            begin
                changed[3] = 1;
                led_state[3] = 0;
            end
            if(changed[4] == 0)
            begin
                if((led_state[4] == 1)&& (sw[4]==~old_switch_state[4]))
                begin
                    points = points+ 1;
                    changed[4] = 1;
                    led_state[4] = 0;
                end
                else
                begin
                    changed[4] = 0;
                    led_state[4] = new_led_number[4];
                end
            end
            else
            begin
                changed[4] = 1;
                led_state[4] = 0;
            end
            if(changed[5] == 0)
            begin
                if((led_state[5] == 1)&& (sw[5]==~old_switch_state[5]))
                begin
                    points = points+ 1;
                    changed[5] = 1;
                    led_state[5] = 0;
                end
                else
                begin
                    changed[5] = 0;
                    led_state[5] = new_led_number[5];
                end
            end
            else
            begin
                changed[5] = 1;
                led_state[5] = 0;
            end
            if(changed[6] == 0)
            begin
            if((led_state[6] == 1)&& (sw[6]==~old_switch_state[6]))
                begin
                    points = points+ 1;
                    changed[6] = 1;
                    led_state[6] = 0;
                end
                else
                begin
                    changed[6] = 0;
                    led_state[6] = new_led_number[6];
                end
            end
            else
            begin
                changed[6] = 1;
                led_state[6] = 0;
            end
            if(changed[7] == 0)
            begin
                if((led_state[7] == 1)&& (sw[7]==~old_switch_state[7]))
                begin
                    points = points+ 1;
                    changed[7] = 1;
                    led_state[7] = 0;
                end
                else
                begin
                    changed[7] = 0;
                    led_state[7] = new_led_number[7];
                end
            end
            else
                begin
                    changed[7] = 1;
                    led_state[7] = 0;
                end
            if(changed[8] == 0)
                begin
                    if((led_state[8] == 1)&& (sw[8]==~old_switch_state[8]))
                    begin
                        points = points+ 1;
                        changed[8] = 1;
                        led_state[8] = 0;
                    end
                    else
                    begin
                        changed[8] = 0;
                        led_state[8] = new_led_number[8];
                    end
                end
                else
                    begin
                        changed[8] = 1;
                        led_state[8] = 0;
                    end 
            if(changed[9] == 0)                    
                begin
                if((led_state[9] == 1)&& (sw[9]==~old_switch_state[9]))
                begin
                    points = points+ 1;
                    changed[9] = 1;
                    led_state[9] = 0;
                end
                else
                begin
                    changed[9] = 0;
                    led_state[9] = new_led_number[9];
                end
            end
            else
                begin
                    changed[9] = 1;
                    led_state[9] = 0;
                end
            if(changed[10] == 0)  
            begin
                if((led_state[10] == 1)&& (sw[10]==~old_switch_state[10]))
                begin
                    points = points+ 1;
                    changed[10] = 1;
                    led_state[10] = 0;
                end
                else
                begin
                    changed[10] = 0;
                    led_state[10] = new_led_number[10];
                end
            end
            else
            begin
                changed[10] = 1;
                led_state[10] = 0;
            end                
            if(changed[11] == 0)  
            begin
                if((led_state[11] == 1)&& (sw[11]==~old_switch_state[11]))
                begin
                    points = points+ 1;
                    changed[11] = 1;
                    led_state[11] = 0;
                end
                else
                begin
                    changed[11] = 0;
                    led_state[11] = new_led_number[1];
                end
            end
            else
            begin
                changed[10] = 1;
                led_state[10] = 0;
            end  
            if(changed[12] == 0)  
            begin
                if((led_state[12] == 1)&& (sw[12]==~old_switch_state[12]))
                begin
                    points = points+ 1;
                    changed[12] = 1;
                    led_state[12] = 0;
                end
                else
                begin
                    changed[12] = 0;
                    led_state[12] = new_led_number[12];
                end
            end
            else
            begin
                changed[12] = 1;
                led_state[12] = 0;
            end
            if(changed[13] == 0)  
            begin
                if((led_state[13] == 1)&& (sw[13]==~old_switch_state[13]))
                begin
                    points = points+ 1;
                    changed[13] = 1;
                    led_state[13] = 0;
                end
                else
                begin
                    changed[13] = 0;
                    led_state[13] = new_led_number[13];
                end
            end
            else
            begin
                changed[13] = 1;
                led_state[13] = 0;
            end  
             if(changed[14] == 0)  
            begin
                if((led_state[14] == 1)&& (sw[14]==~old_switch_state[14]))
                begin
                    points = points+ 1;
                    changed[14] = 1;
                    led_state[14] = 0;
                end
                else
                begin
                    changed[14] = 0;
                    led_state[14] = new_led_number[14];
                end
            end
            else
            begin
                changed[14] = 1;
                led_state[14] = 0;
            end  
            if(changed[15] == 0)  
            begin
                if((led_state[15] == 1)&& (sw[15]==~old_switch_state[15]))
                begin
                    points = points+ 1;
                    changed[15] = 1;
                    led_state[15] = 0;
                end
                else
                begin
                    changed[15] = 0;
                    led_state[15] = new_led_number[15];
                end
            end
            else
            begin
                changed[15] = 1;
                led_state[15] = 0;
            end                                                       
            end //for blink_check
            else // blink_check =  1
            begin   
                changed = 0;  
                if(led_state[0] == 1)
                begin
                    if((cannot_blinking_score[0] == 0)&&(sw[0] == ~old_switch_state[0]))
                    begin
                        led_state[0] = 0;
                        points = points + 1;
                        cannot_blinking_score[0] = 1;
                    end
                    else
                    begin
                        led_state[0] = 1; 
                    end
                end
                else
                begin
                    led_state[0] = 0;
                end
                if(led_state[1] == 1)
                begin
                    if((cannot_blinking_score[1] == 0)&&(sw[1] == ~old_switch_state[1]))
                    begin
                        led_state[1] = 0;
                        points = points + 1;
                        cannot_blinking_score[1] = 1;
                    end
                    else
                    begin
                        led_state[1] = 1; 
                    end
                end
                else
                begin
                    led_state[1] = 0;
                end
                if(led_state[2] == 1)
                begin
                    if((cannot_blinking_score[2] == 0)&&(sw[2] == ~old_switch_state[2]))
                    begin
                        led_state[2] = 0;
                        points = points + 1;
                        cannot_blinking_score[2] = 1;
                    end
                    else
                    begin
                        led_state[2] = 1; 
                    end
                end
                else
                begin
                    led_state[2] = 0;
                end
                if(led_state[3] == 1)
                begin
                    if((cannot_blinking_score[3] == 0)&&(sw[3] == ~old_switch_state[3]))
                    begin
                        led_state[3] = 0;
                        points = points + 1;
                        cannot_blinking_score[3] = 1;
                    end
                    else
                    begin
                        led_state[3] = 1; 
                    end
                end
                else
                begin
                    led_state[3] = 0;
                end
                if(led_state[4] == 1)
                begin
                    if((cannot_blinking_score[4] == 0)&&(sw[4] == ~old_switch_state[4]))
                    begin
                        led_state[4] = 0;
                        points = points + 1;
                        cannot_blinking_score[4] = 1;
                    end
                    else
                    begin
                        led_state[4] = 1; 
                    end
                end
                else
                begin
                    led_state[4] = 0;
                end
                if(led_state[5] == 1)
                begin
                    if((cannot_blinking_score[5] == 0)&&(sw[5] == ~old_switch_state[5]))
                    begin
                        led_state[5] = 0;
                        points = points + 1;
                        cannot_blinking_score[5] = 1;
                    end
                    else
                    begin
                        led_state[5] = 1; 
                    end
                end
                else
                begin
                    led_state[5] = 0;
                end
                if(led_state[6] == 1)
                begin
                    if((cannot_blinking_score[6] == 0)&&(sw[6] == ~old_switch_state[6]))
                    begin
                        led_state[6] = 0;
                        points = points + 1;
                        cannot_blinking_score[6] = 1;
                    end
                    else
                    begin
                        led_state[6] = 1; 
                    end
                end
                else
                begin
                    led_state[6] = 0;
                end
                if(led_state[7] == 1)
                begin
                    if((cannot_blinking_score[7] == 0)&&(sw[7] == ~old_switch_state[7]))
                    begin
                        led_state[7] = 0;
                        points = points + 1;
                        cannot_blinking_score[7] = 1;
                    end
                    else
                    begin
                        led_state[7] = 1; 
                    end
                end
                else
                begin
                    led_state[7] = 0;
                end
                if(led_state[8] == 1)
                begin
                    if((cannot_blinking_score[8] == 0)&&(sw[8] == ~old_switch_state[8]))
                    begin
                        led_state[8] = 0;
                        points = points + 1;
                        cannot_blinking_score[8] = 1;
                    end
                    else
                    begin
                        led_state[8] = 1; 
                    end
                end
                else
                begin
                    led_state[8] = 0;
                end
                if(led_state[9] == 1)
                begin
                    if((cannot_blinking_score[9] == 0)&&(sw[9] == ~old_switch_state[9]))
                    begin
                        led_state[9] = 0;
                        points = points + 1;
                        cannot_blinking_score[9] = 1;
                    end
                    else
                    begin
                        led_state[9] = 1; 
                    end
                end
                else
                begin
                    led_state[9] = 0;
                end
                if(led_state[10] == 1)
                begin
                    if((cannot_blinking_score[10] == 0)&&(sw[10] == ~old_switch_state[10]))
                    begin
                        led_state[10] = 0;
                        points = points + 1;
                        cannot_blinking_score[10] = 1;
                    end
                    else
                    begin
                        led_state[10] = 1; 
                    end
                end
                else
                begin
                    led_state[10] = 0;
                end
                if(led_state[11] == 1)
                begin
                    if((cannot_blinking_score[11] == 0)&&(sw[11] == ~old_switch_state[11]))
                    begin
                        led_state[11] = 0;
                        points = points + 1;
                        cannot_blinking_score[11] = 1;
                    end
                    else
                    begin
                        led_state[11] = 1; 
                    end
                end
                else
                begin
                    led_state[11] = 0;
                end
                if(led_state[12] == 1)
                begin
                    if((cannot_blinking_score[12] == 0)&&(sw[12] == ~old_switch_state[12]))
                    begin
                        led_state[12] = 0;
                        points = points + 1;
                        cannot_blinking_score[12] = 1;
                    end
                    else
                    begin
                        led_state[12] = 1; 
                    end
                end
                else
                begin
                    led_state[12] = 0;
                end
                if(led_state[13] == 1)
                begin
                    if((cannot_blinking_score[13] == 0)&&(sw[13] == ~old_switch_state[13]))
                    begin
                        led_state[13] = 0;
                        points = points + 1;
                        cannot_blinking_score[13] = 1;
                    end
                    else
                    begin
                        led_state[13] = 1; 
                    end
                end
                else
                begin
                    led_state[13] = 0;
                end
                if(led_state[14] == 1)
                begin
                    if((cannot_blinking_score[14] == 0)&&(sw[14] == ~old_switch_state[14]))
                    begin
                        led_state[14] = 0;
                        points = points + 1;
                        cannot_blinking_score[14] = 1;
                    end
                    else
                    begin
                        led_state[14] = 1; 
                    end
                end
                else
                begin
                    led_state[14] = 0;
                end
                if(led_state[15] == 1)
                begin
                    if((cannot_blinking_score[15] == 0)&&(sw[15] == ~old_switch_state[15]))
                    begin
                        led_state[15] = 0;
                        points = points + 1;
                        cannot_blinking_score[15] = 1;
                    end
                    else
                    begin
                        led_state[15] = 1; 
                    end
                end
                else
                begin
                    led_state[15] = 0;
                end     
            end // end of blink_check = 1
        end //defuse =1
        else
        begin
            led_state = 16'h0000;    
        end
    end
    else
    begin // for done = 1
        led_state = 16'h0000;
        changed = 16'h0000;
        points = 0;     
    end
    end   

    always @ (posedge clk_1Hz)
    begin
        if(done == 0)
        begin
            time_counter <= (time_counter == 5)? 1: time_counter + 1;
            blink_check <= (time_counter == 4)? 1:0;
            if(time_counter == 5)
                begin
                old_switch_state = sw; 
                old_led_number = (old_led_number == 0) ? 1: new_led_number; 
                end
        end
        else
        begin
            time_counter = 1;
            blink_check = 0;
            old_led_number = 16'h5050;
        end
    end
    
    always @ (posedge clk_10Hz)
    begin
        if(done == 0)
        begin
            if(blink_check == 1)
            begin
                blinking = ~blinking;
            end
            else
            begin
                blinking = 16'hFFFF;
            end
        end
        else
        begin
            blinking = 16'h0000;
        end
    end

endmodule