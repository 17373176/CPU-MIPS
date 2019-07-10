`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:22:42 11/19/2018 
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
    input CLK,
	 input RESET,
	 input Zero,
	 input [31:0] beq, //ָ����������imm��λ�ҷ�����չ���ֵ
	 input jump,
	 input jr,
	 inout [31:0] ra, //32λ$ra��ֵ($31=PC+4)
	 input [25:0] index, //instr_index(ָ�����26λ)
	 output [31:0] Instr,
	 output [31:0] PC, PC_ //PC��ǰ��PC+4��ֵ
	 );
	
	reg [31:0] rgt = 32'h00003000; //ָ��Ĵ���
	wire [31:0] PC_s; //PC�Ĵ�̬
	wire [31:0] index_s; //index��J��Jalָ������չ��ֵ
	wire [1:0] sel; //����2bit-PC_s���ѡ���ź�
	
	always @(posedge CLK) begin /*ʱ��������,ͬ����λ*/
		if(RESET) rgt <= 32'h00003000; //��ʼ��ַ0x00003000
		else rgt <= PC_s;
	end
	
	assign PC = rgt;
	
	//����ROMָ��洢��
	ROM IM(
    .A(PC[11:2]), 
    .D(Instr)
    );
	
	assign PC_ = !Zero ? (PC + 32'h4) : (beq + PC + 32'h4); /*beq��תָ���PCֵ*/
	assign index_s = {PC[31:28], index, 2'b0};
	
	assign sel = {jr, jump};
	//ѡ�����PC_s
	assign PC_s = (!sel[0] && !sel[1]) ? PC_ : /*sel=00���ΪPC_*/
	{
		(sel[0] && !sel[1]) ? index_s : /*sel=01���Ϊindex_*/
		{
			(!sel[0] && sel[1]) ? ra : 32'hx /*sel=10���Ϊra,�������0*/
		}
	};


endmodule
