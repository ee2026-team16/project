`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.04.2024 12:03:17
// Design Name: 
// Module Name: UART_RX
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
// This file contains the UART Transmitter.  This transmitter is able
// to transmit 8 bits of serial data, one start bit, one stop bit,
// and no parity bit.  When transmit is complete o_Tx_done will be
// driven high for one clock cycle.
//
// Set Parameter CLKS_PER_BIT as follows:
// CLKS_PER_BIT = (Frequency of i_Clock)/(Frequency of UART)
// Example: 25 MHz Clock, 115200 baud UART
// (100_000_000)/(115200) = 868 (was 217 prev)
//////////////////////////////////////////////////////////////////////////////////

module UART_TX 
  #(parameter CLKS_PER_BIT = 868)
  (
   input       i_clk,
   input       i_TX_DV,     // flag=1 : to start tx for IDLE -> start bit 1 clk cycle
   input [7:0] i_TX_Byte,   // data
   output reg  o_TX_Active,
   output reg  o_TX_Serial, // JA1 default high
   output reg  o_TX_Done    // flag=1: finish tx!
   );
  // states
  localparam IDLE         = 2'b00;
  localparam TX_START_BIT = 2'b01;
  localparam TX_DATA_BITS = 2'b10;
  localparam TX_STOP_BIT  = 2'b11;
  
  reg [2:0] r_SM_Main = 0;
  reg [9:0] r_Clock_Count;   
  reg [2:0] r_Bit_Index;
  reg [7:0] r_TX_Data;


  // Purpose: Control TX state machine
  always @(posedge i_clk)
  begin
      o_TX_Done <= 1'b0;

      case (r_SM_Main)
      IDLE :
        begin
          o_TX_Serial   <= 1'b1;         // Drive Line High for Idle
          r_Clock_Count <= 0;
          r_Bit_Index   <= 0;
          
          if (i_TX_DV == 1'b1)
          begin
            r_TX_Data   <= i_TX_Byte;   // store data in reg (good practice)
            r_SM_Main   <= TX_START_BIT;
            o_TX_Active <= 1'b1;
          end
          else  //i_TX_DV flag=0 : no transmit
            r_SM_Main <= IDLE;
        end // case: IDLE
      
      
      // Send out Start Bit. Start bit = 0
      TX_START_BIT :
        begin
          o_TX_Serial <= 1'b0;  // pull line to LOW (start bit)
          
          // Wait CLKS_PER_BIT-1 clock cycles for start bit to finish
          if (r_Clock_Count < CLKS_PER_BIT-1)   // len of start bit
          begin
            r_Clock_Count <= r_Clock_Count + 1;
            r_SM_Main     <= TX_START_BIT;
          end
          else  // @ end of start bit
          begin
            r_Clock_Count <= 0;
            r_SM_Main     <= TX_DATA_BITS;
          end
        end // case: TX_START_BIT
      
      
      // Wait CLKS_PER_BIT-1 clock cycles for data bits to finish         
      TX_DATA_BITS :
        begin
          o_TX_Serial <= r_TX_Data[r_Bit_Index];    // tx from LSB to MSB
          
          if (r_Clock_Count < CLKS_PER_BIT-1)
          begin
            r_Clock_Count <= r_Clock_Count + 1;
            r_SM_Main     <= TX_DATA_BITS;
          end
          else  // @ start of next bit
          begin
            r_Clock_Count <= 0;
            
            // Check if we have sent out all bits
            if (r_Bit_Index < 7)
            begin
              r_Bit_Index <= r_Bit_Index + 1;
              r_SM_Main   <= TX_DATA_BITS;
            end
            else    // after all data bits
            begin
              r_Bit_Index <= 0;
              r_SM_Main   <= TX_STOP_BIT;
            end
          end 
        end // case: TX_DATA_BITS
      
      
      // Send out Stop bit.  Stop bit = 1
      TX_STOP_BIT :
        begin
          o_TX_Serial <= 1'b1;  // stop bit = 1
          
          // Wait CLKS_PER_BIT-1 clock cycles for Stop bit to finish
          if (r_Clock_Count < CLKS_PER_BIT-1)
          begin
            r_Clock_Count <= r_Clock_Count + 1;
            r_SM_Main     <= TX_STOP_BIT;
          end
          else  // @ end of stop bit
          begin
            o_TX_Done     <= 1'b1;
            r_Clock_Count <= 0;
            r_SM_Main     <= IDLE;
            o_TX_Active <= 1'b0;
          end 
        end // case: TX_STOP_BIT      
      
      default :
        r_SM_Main <= IDLE;
      
    endcase
    
  end // always @ (posedge i_Clock)

  
endmodule
