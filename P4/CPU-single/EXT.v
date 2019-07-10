`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:23:19 11/19/2018 
// Design Name: 
// Module Name:    EXT 
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
module EXT(
    input [15:0] imm, //16λ������
	 input EXTOp, //��չ����,0ΪRָ��,1Ϊbeqָ��
	 output [31:0] ext //��չ���32λ
    );

    assign ext = !EXTOp ? {{16{imm[15]}}, imm} : {{14{imm[15]}}, imm, 2'b0};
	 
endmodule
