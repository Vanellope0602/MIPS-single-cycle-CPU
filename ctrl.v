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
`define R 		(opcode == 6'b000000)  // calculation type instr
`define addu	(`R & (funct == 6'b100001))
`define subu	(`R & (funct == 6'b100011))
`define ori     (opcode == 6'b001101)
`define lw      (opcode == 6'b100011)
`define sw      (opcode == 6'b101011)
`define beq     (opcode == 6'b000100)
`define lui     (opcode == 6'b001111)
`define lh      (opcode == 6'b100001)
`define slt     (`R & (funct == 6'b101010))
`define orr      (`R & (funct == 6'b100101)) //  it is or , but to avoid the hazard with or keyword in verilog 
`define j	    (opcode == 6'b000010)
`define jal     (opcode == 6'b000011)
`define jr      (`R & (funct == 6'b001000))
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
	 
	 assign RegDst = (`addu || `subu || `slt || `orr) ? 1:
			(`jal)? 2: 0 ; //addu, subu, == 1, jal == 2,write $31 register
							
							
	 assign ALUSrc = (`ori|| `lw || `sw || `lui || `lh )? 1:0; //ori,lw,sw, lui
	 assign MemtoReg = (`lw) ? 1:  // lw
			   (`jal )? 2: 
			   (`lh )? 3: 0; // jal ->2, PC+4 into $31
	 
	 assign RegWrite = (`addu || `subu || `ori || `lw || `lui || `jal || `lh || `slt || `orr) ? 1 : 0;//jal is remained to be modified?
	 assign MemWrite = (`sw) ? 1:0;  //sw
	 assign nPC_sel = (`beq) ? 1:0; // beq
	 assign if_jal = (`jal)? 1:0;
	 assign if_jr = (`jr)? 1:0;
	 
	 assign Ext_op = (`lw || `sw || `lh)? 1: // lw, sw
			(`lui)? 2:0;  // lui , 2, to high 
						  
	 assign ALUctr = (`subu || `beq)? 1: // subu, beq
			(`ori || `orr)? 2: // ori ,2
			 (`lui)? 3: // lui, 
			 (`slt)? 4:0 ; // slt, set 1 if A < B 
	 

endmodule
