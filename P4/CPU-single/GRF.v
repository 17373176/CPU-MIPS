`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:23:02 11/19/2018 
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
	 input CLK,
	 input RESET,
	 input WE, /*�Ĵ���д��ʹ���ź�*/
	 input [4:0]A1, A2, WA, /*������ַ*/
	 input [31:0] WD, /*д������*/
	 input [31:0] PC, /*ָ��洢�ĵ�ַ������IFU*/
	 output [31:0] RD1, RD2
    );
	
	reg [31:0] grf[0:31]; //32���Ĵ���
	
	integer i;
	initial /*��ʼ���Ĵ���*/
		for(i = 0; i <= 31; i = i + 1) grf[i] <= 32'h0;
	
	always @(posedge CLK) begin /*ʱ�������ز�д�����ݣ�ͬ����λ*/
		if(RESET) /*��λ�ź���Ч*/
			for(i = 0; i <= 31; i = i + 1) grf[i] <= 32'h0;
		else if(WE) begin/*д��ʹ���ź���Ч*/
			if(WA != 32'h0) grf[WA] <= WD; /*��֤0�żĴ���Ϊ0*/
			$display("@%h: $%d <= %h", PC, WA, WD);
		end
	end
	
	//����˿ڶ�Ӧ��ַ�ļĴ�����ֵ
	assign RD1 = grf[A1];
	assign RD2 = grf[A2];
	
endmodule
