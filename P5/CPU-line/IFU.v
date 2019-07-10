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
	 input PCsrc_D, //PCѡ���ź�
	 input [31:0] NPC, //��ת��ַ
	 output [31:0]Instr,
	 output [31:0] PC, PC_, //PC��ǰ��PC��ת��ֵ
	 
	 //��ˮ���Ĵ���
	 output reg [31:0] Instr_D,
	 output reg [31:0] PC_D,
	 
	 //��ͣ�ź�
	 input stall_D, stall_F
	 );
	 
	 initial begin
		Instr_D <= 0; PC_D <= 0;
	 end
	 
//��ˮ���Ĵ�����ֵ
	always @(posedge CLK) begin /*�����ͣ��Ч����£���ͣ��Ч�򶳽�*/
		if(RESET) begin
			Instr_D <= 0; PC_D <= 0;
		end
		else if(!stall_D) begin
			Instr_D <= Instr; PC_D <= PC;
		end
	end
	
	
//ָ��Ĵ�������
	reg [31:0] rgt = 32'h00003000; //ָ��Ĵ���
	
	always @(posedge CLK) begin /*ʱ��������,ͬ����λ*/
		if(RESET) rgt <= 32'h00003000; //��ʼ��ַ0x00003000
		else if(!stall_F) rgt <= PC_; //��ͣ��Ч����£����򶳽�
	end
	
	assign PC = rgt;
	
	//����ROMָ��洢��
	ROM IM(
    .A(PC[11:2]), 
    .D(Instr)
    );
	
	assign PC_ = PCsrc_D ? NPC : (PC + 32'h4); 

endmodule
