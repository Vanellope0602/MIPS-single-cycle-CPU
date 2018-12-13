`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:43:09 11/24/2018 
// Design Name: 
// Module Name:    GRF 
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
module GRF(
	 input [31:0] PC,
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] WriteData, 
    input RegWrite,
    input clk,
    input reset,
    output [31:0] RD1,
    output [31:0] RD2
    );
	 integer i;
	 reg [31:0] regfile [31:0]; // 32  32-bit register
	 initial begin
			for(i = 0; i<=31; i = i+1)
				regfile[i] = 0;
	 end
	 
	 assign RD1 = (A1 != 0)? regfile[A1] : 0;
	 assign RD2 = (A2 != 0)? regfile[A2] : 0;
	 
	 always @(posedge clk) begin
		if(reset == 0)begin
		   //$display("debug reset == 0\n");
			if(RegWrite) begin
			    //$display("RegWrite = 1");
				if(A3 != 5'b00000) begin
					regfile[A3] <= WriteData;
					$display("@%h: $%d <= %h", PC, A3, WriteData);//$display("@%h: $%d <= %h", WPC, Waddr,WData);
					end 
				else 
					regfile[A3] <= 5'b00000;  // $0 always be zero 
			end
		end
		
		else if(reset == 1) begin   // reset all the register 
			for(i = 0; i<=31; i = i+1)
				regfile[i] = 0;
		end
		
	 end
	 


endmodule
