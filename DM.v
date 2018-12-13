`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:47:08 11/24/2018 
// Design Name: 
// Module Name:    DM 
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
module DM(
	input [31:0] PC,
    input [31:0] address,  //
    input [31:0] MemData,
    input MemWrite,
    input clk,
    input reset,
    output [31:0] data_output  
    );
	 integer i;
	 reg [31:0] Memory [1023:0];
	 
	 assign data_output = Memory[address[11:2]];
	 
	 initial begin
		for(i = 0; i<=1023; i = i+1)
			Memory[i] = 0;
	 end
	 always @(posedge clk) begin
		if(reset == 0) begin
			if(MemWrite) begin
				Memory[address[11:2]] <= MemData;
				//$display("memory data ");
				$display("@%h: *%h <= %h",PC, address, MemData);
			end
			
		end
		else if(reset == 1) begin
			for(i = 0; i<=1023; i = i+1)
				Memory[i] <= 0;
		end
	 end


endmodule
