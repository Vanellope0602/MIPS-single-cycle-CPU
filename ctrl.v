`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:29:00 11/24/2018 
// Design Name: 
// Module Name:    ctrl 
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
module ctrl(
    input [5:0] opcode,
    input [5:0] funct,
    output [1:0] RegDst,
    output ALUSrc,
    output [1:0] MemtoReg,
    output RegWrite,
    output MemWrite,
    output nPC_sel,
    output [1:0] Ext_op,
    output [2:0] ALUctr,
	 output if_jal,
	 output if_jr
    );
	 
	 assign RegDst = (opcode ==6'b000000 && (funct == 6'b100001 || funct == 6'b100011 || funct == 6'b001000 || funct == 6'b101010) ) ? 1:
							(opcode == 6'b000011)? 2: 0 ; //addu, subu,jr, slt == 1;jal == 2,write $31 register
							
							
	 assign ALUSrc = (opcode == 6'b001101 || opcode ==6'b100011 || opcode ==6'b101011 || opcode ==6'b001111 || opcode == 6'b100001)? 1:0; //ori,lw,sw,lui,lh
	 
	 assign MemtoReg = (opcode == 6'b100011) ? 1:  // lw
							 (opcode == 6'b000011 )? 2: // jal ->2, PC+4 into $31
							 (opcode == 6'b100001)? 3 : 0;  // load half word 
	 
	 assign RegWrite = ( (opcode ==6'b000000 && (funct == 6'b100001 || funct == 6'b100011 || funct == 6'b101010)) || opcode == 6'b001101
								|| opcode == 6'b100011 || opcode == 6'b001111  //lui
								|| opcode == 6'b000011 || opcode == 6'b100001) ? 1:0;  //addu,subu,ori, slt,lw,lui, jal, jal is remained to be modified
	 
	 assign MemWrite = (opcode == 6'b101011) ? 1:0;  //sw
	 assign nPC_sel = (opcode == 6'b000100) ? 1:0; // beq
	 assign if_jal = (opcode == 6'b000011)? 1:0;
	 assign if_jr = (opcode == 6'b000000 && funct == 6'b001000)? 1:0;
	 
	 assign Ext_op = (opcode == 6'b100011 || opcode == 6'b101011 || opcode == 6'b100001)? 1: // lw, sw, lh
						  (opcode == 6'b001111)? 2:0;  // lui , 2, to high 
						  
	 assign ALUctr = ((opcode == 6'b000000 && funct == 6'b100011) || opcode == 6'b000100)? 1: // subu, beq
						  (opcode == 6'b001101)? 2: // ori ,2
						  (opcode == 6'b001111)? 3: // lui
						  (opcode == 6'b000000 && funct == 6'b101010 )? 4:0 ; // slt, set 1 if A < B 
	 

endmodule
