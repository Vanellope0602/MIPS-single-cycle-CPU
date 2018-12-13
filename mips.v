`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:21:05 11/24/2018 
// Design Name: 
// Module Name:    mips 
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
module mips(
    input clk,
    input reset
    );
	 wire [5:0] opcode;
	 wire [5:0] funct;
	 
		wire [1:0] RegDst;
		wire ALUSrc;
		wire [1:0] MemtoReg;
		wire RegWrite;
		wire MemWrite;
		wire nPC_sel;
		wire [1:0] Ext_op;
		wire [2:0] ALUop;
		wire if_jal;
		wire if_jr;
		
	 ctrl controller(
    .opcode(opcode), 
    .funct(funct), 
    .RegDst(RegDst), 
    .ALUSrc(ALUSrc), 
    .MemtoReg(MemtoReg), 
    .RegWrite(RegWrite), 
    .MemWrite(MemWrite), 
    .nPC_sel(nPC_sel), 
    .Ext_op(Ext_op), 
    .ALUctr(ALUop), // ctr is port , 3bit, ALUop is wire , 3bit 
    .if_jal(if_jal), 
    .if_jr(if_jr)
    );

	 
	datapath datapath (
    .RegDst(RegDst), 
    .ALUSrc(ALUSrc), 
    .MemtoReg(MemtoReg), 
    .RegWrite(RegWrite), 
    .MemWrite(MemWrite), 
    .nPC_sel(nPC_sel), 
    .Ext_op(Ext_op), 
    .ALUop(ALUop), 
    .if_jal(if_jal), 
    .if_jr(if_jr), 
    .clk(clk), 
    .reset(reset), 
    .funct(funct), 
    .opcode(opcode)
    );


endmodule


