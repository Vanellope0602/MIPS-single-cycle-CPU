`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:08:44 11/27/2018 
// Design Name: 
// Module Name:    datapath 
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

module datapath(  // inputs are control signals , datapath and contorller module put into mips
	input [1:0] RegDst, 
	input ALUSrc, 
	input [1:0] MemtoReg, 
	input RegWrite, 
	input MemWrite, 
	input nPC_sel,   // if beq 
	input [1:0] Ext_op, 
	input [2:0] ALUop,  // ALUctr 3 bit
	input if_jal, 
	input if_jr,
	input clk,
	input reset,
	
	output [5:0] funct,
	output [5:0] opcode
	
    );
	 
	 // instruction's wire
		wire [31:0] instr;
		
		wire [4:0] shamt;
		wire [4:0] rd;
		wire [4:0] rt;
		wire [4:0] rs;
		wire [31:0] pc_plus4;  // connect to out port of IFU is ok 
		wire [31:0] PC;

		//ext
		wire [15:0]ext_in;
		wire [31:0]ext_out;   // connect to ALUSrc'1 select 
		
		assign ext_in = instr[15:0];
		assign funct = instr[5:0];
		assign shamt = instr[10:6];
		assign rd = instr[15:11];
		assign rt = instr[20:16];
		assign rs = instr[25:21];
		assign opcode = instr[31:26];
		
		// GRF IO
		wire [4:0] mux_regdst_out;
		wire [31:0] RD1_out;        // GPRrs to IFU, the content of rs register 
		wire [31:0] RD2_out;
		
		wire [31:0] alu_src_out;
		
		wire zero;//out from ALU 
		wire [31:0] alu_result;
		
		wire [31:0] mem_out;
		wire [31:0] mem_to_reg_out;// connect directly to the input port of WriteData of GPR

		wire [31:0] load_half_word;
		assign load_half_word = (alu_result[1] == 0)? {16'h0000, mem_out[15:0]} : {16'h0000, mem_out[31:16]};

	IFU Instr_fetch (
		 .if_beq(nPC_sel), //nPC_sel
		 .zero(zero), 
		 .if_jr(if_jr), 
		 .if_jal(if_jal), 
		 .GPRrs(RD1_out), 
		 .reset(reset), 
		 .clk(clk), 
		 .instr_out(instr), 
		 .pc_plus4(pc_plus4),
		 .PC(PC)
		 ); // complete

	GRF registers (
		 .PC(PC),
		 .A1(rs), 
		 .A2(rt), 
		 .A3(mux_regdst_out), 
		 .WriteData(mem_to_reg_out),  // debug
		 .RegWrite(RegWrite), 
		 .clk(clk), 
		 .reset(reset), 
		 .RD1(RD1_out), 
		 .RD2(RD2_out)
		 );// complete
		 
	ALU ALU (
		 .A(RD1_out), 
		 .B(alu_src_out), 
		 .ALUop(ALUop), 
		 .result(alu_result), // 32bit 
		 .zero(zero)     //output 
		 );//complete
		 
	DM data_memory (
		 .PC(PC),
		 .address(alu_result), 
		 .MemData(RD2_out), 
		 .MemWrite(MemWrite), 
		 .clk(clk), 
		 .reset(reset), 
		 .data_output(mem_out)
		 );//complete

	ext extender (
		 .in(ext_in), 
		 .Ext_op(Ext_op), 
		 .out(ext_out)
		 );//complete

	mux_memtoreg mux_mem2reg (
		 .in0(alu_result), 
		 .in1(mem_out), 
		 .in2(PC+4), 
		 .in3(load_half_word),
		 .MemtoReg(MemtoReg), 
		 .mux_memtoreg_out(mem_to_reg_out) // ( ) contains wire's name , 32 bit 
		 );//complete
		 
	mux_alusrc mux_alu (
		 .in0(RD2_out), 
		 .in1(ext_out), 
		 .ALUSrc(ALUSrc), 
		 .mux_alusrc_out(alu_src_out) // 32bit
		 );//complete
		 
	mux_regdst mux_regdst(
		 .in0(rt), 
		 .in1(rd), 
		 .in2(), 
		 .RegDst(RegDst), 
		 .mux_regdst_out(mux_regdst_out) // 5bit
		 );//complete


endmodule

