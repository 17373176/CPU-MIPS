`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:23:10 11/19/2018 
// Design Name: 
// Module Name:    DM 
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
module DM( 
	 input clk,
    input clr,
	 input [9:0] A,
    input [31:0] WD,
    input SD, //�����ź�
    input LD, //ȡ���ź�
	 input [31:0] PC, /*ָ��洢�ĵ�ַ������IFU*/
    output [31:0] RD
    );

	reg [31:0] ram[0:1023]; //32x1024RAM
	
	reg [31:0] data = 32'h00000000; //�м��������ȡ����
	
	wire [31:0] addr = {19'b0, A, 2'b0}; //�����ַ��4
	
	integer i;
	initial /*��ʼ�����ݴ洢��*/
		for(i = 0; i <= 1023; i = i + 1) ram[i] <= 32'h0;  
	
	always @(posedge clk) begin /*ʱ�������ؽ�����д��Ĵ���,ͬ����λ*/
		if(clr) /*��λ�ź���Ч*/
			for(i = 0; i <= 1023; i = i + 1) ram[i] <= 32'h0;  
		else if(SD) begin/*�����ź���Ч*/
			ram[A] <= WD;
			$display("@%h: *%h <= %h", PC, addr, WD);
		end
	end
	
	always @(*) begin /*ȡ���������޹�*/
		if(LD && !(clr && clk)) data <= ram[A];
	end
	
	//��������
	assign RD = data;
	
endmodule
