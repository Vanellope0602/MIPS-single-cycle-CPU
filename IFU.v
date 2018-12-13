`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:38:31 11/24/2018 
// Design Name: 
// Module Name:    IFU 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module IFU(
    input if_beq,
	 input zero,
	 
	 input if_jr,
	 input if_jal,
	 
	 input [31:0] GPRrs,
    
    input reset,
    input clk,
    output [31:0] instr_out,
	 output [31:0] pc_plus4,
	 output reg [31:0] PC
    );
	 wire [1:0] sel;
	 reg [31:0] pc_plus_4;
	 //reg [31:0] sign_ext_instr;
	 initial begin
		//if(instr_out[15] == 0) sign_ext_instr = {16'b0000_0000_0000_0000, instr_out[15:0]};
		//else if(instr_out[15] == 1) sign_ext_instr = {16'b1111_1111_1111_1111, instr_out[15:0]};
		PC = 32'h00003000;
		pc_plus_4 = 32'h00003004;
	 end
	 
	 assign sel = (if_beq == 1 && zero == 1)? 1:
			 (if_jal == 1)? 2:
			 (if_jr == 1 )? 3:0;
			 
    assign pc_plus4 = pc_plus_4;  //assign port to an integer / reg
 	 always @(PC) begin
	   pc_plus_4 = PC + 4;
	 end
	 
	 always @(posedge clk) begin
		if(reset ==0 ) begin
			case(sel)
				0: begin
					PC <= PC + 4;
				end
				1: begin
				   if(instr_out[15] == 0) begin
						PC <= PC+4 + { 14'b00000000000000 ,instr_out[15:0] , 2'b00};
					end
					else if(instr_out[15] == 1) begin
						PC <= PC+4 + { 14'b11111111111111 ,instr_out[15:0] , 2'b00};
					end
				end
				2:begin
					PC <= {PC[31:28],instr_out[25:0], 2'b00};// jal 
				end
				3: begin
					PC <= GPRrs;  // jr
				end
			
			endcase
		end
		else if(reset == 1) begin
			PC <= 32'h00003000;  //复位后，PC指向0x0000_3000
		end
	 end
	 
	 IM instr_memory  (
    .instr_addr(PC),  // PC 10bits as address 
    .instr(instr_out)  //IM's output name is instr, and we connect a wire called instr to it ,use wire instr in IFU module 
    );

	 
	
endmodule
