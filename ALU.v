`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:45:17 11/24/2018 
// Design Name: 
// Module Name:    ALU 
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
module ALU(
    input [31:0] A,
    input [31:0] B,
    input [2:0] ALUop,
    output reg [31:0] result,
    output reg zero
    );
	 initial begin
		if(A == B) zero = 1;  // A - B  = zero is true 
		else zero = 0;
	 end
	 
	 always @(*) begin
	   if(A == B) zero = 1;  // A - B  = zero is true 
		else zero = 0;
		
		case(ALUop)
		  3'b000:
			begin
				result = A + B;
			end
		  
		  3'b001:
		   begin
				result = A - B;
			end
			
		  3'b010:
		   begin
				result = A | B;
			
			end
			
		  3'b011:
		   begin
				result = B;
			end
		  3'b100:
		  begin
		  		if($signed(A)<$signed(B)) result = 1;
		  		else begin
		  			result = 0;
		  		end
		  end
		  
		  endcase
		  
	 end


endmodule
