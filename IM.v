`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:36:31 11/24/2018 
// Design Name: 
// Module Name:    IM 
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
module IM(
    input [31:0] instr_addr, // actually is PC in here 
    output [31:0] instr
    );
	 reg [31:0] Memory [1023:0];  // ????
	 
	 initial 
	   $readmemh("code.txt", Memory);//, 0, 1024
		
	 assign instr = Memory[instr_addr[11:2]];   // kick out the lower 2bit of PC, so it's aligned four byte


endmodule
