`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:11:02 10/11/2018 
// Design Name: 
// Module Name:    code 
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
module code(
    input Clk,
    input Reset,
    input Slt,
    input En,
    output [63:0] Output0,
    output [63:0] Output1
    );
	//ÿ����������ֵΪ0����λ����Ҳ�Ḵλÿ����������ǰ����Чʱ�����ڡ�
	reg [63:0] Output0, Output1;
	//reg Clk;
	
	initial begin
		Output0 = 0;
		Output1 = 0;
	end
	
	integer i = 0;//���ڼ���ʱ��������
	
	always @(posedge Clk) begin
	//ʱ��������������������������ͬʱ����
		if(Reset) begin
			Output0 <= 0;
			Output1 <= 0;
			i <= 0; 
			//#5;/*Clk = 0;*///��λʱ�����ڣ���ʱ5ns������ʱ��������
		end
		//���ʹ�ܶ���Ч
		if(En) begin
			if(!Slt) begin//ѡ���źŸߵ�ƽ,�������Чʱ���źż��������0��ÿ����1�����ڼ�����0����Чʱ�����ڣ�������0�ۼ�1
				Output0 <= Output0 + 1;
			end
			else begin//ѡ���źŵ͵�ƽ,�������Чʱ���źż��������1��ÿ����4�����ڼ�����1����Чʱ�����ڣ�������1�ۼ�1
				i = i + 1;
				if(i == 4) begin
					i <= 0;
					Output1 <= Output1 + 1;
				end
			end
		end
	end

endmodule
