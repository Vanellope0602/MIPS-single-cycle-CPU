`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:49:14 11/24/2018 
// Design Name: 
// Module Name:    ext 
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
module ext(
    input [15:0] in,
    input [1:0] Ext_op,
    output reg [31:0] out
    );
	 
	 initial begin
		case(Ext_op)
		2'b00:  // zero ext
			begin
				out = {16'b0000_0000_0000_0000, in};
			end
		2'b01:  // sign_ext
			begin
				if(in[15] == 0) out = {16'b0000_0000_0000_0000, in};
				else if(in[15] == 1) out = {16'b1111_1111_1111_1111, in};
			end
		2'b10:
			begin
				out = {in, 16'b0000_0000_0000_0000 };
			end
		2'b11:
			begin
				out = {32'h00000000}; // no instruction, wait to insert
			end
			
		endcase
	 
	 end
	 
	 
	 always @(*)begin
		case(Ext_op)
		2'b00:  // zero ext
			begin
				out = {16'b0000_0000_0000_0000, in};
			end
		2'b01:  // sign_ext
			begin
				if(in[15] == 0) out = {16'b0000_0000_0000_0000, in};
				else if(in[15] == 1) out = {16'b1111_1111_1111_1111, in};
			end
		2'b10:
			begin
				out = {in, 16'b0000_0000_0000_0000 };
			end
		2'b11:
			begin
				out = {32'h00000000}; // no instruction, wait to insert
			end
			
		endcase
	 
	 end
	 


endmodule
