`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:22:53 11/19/2018 
// Design Name: 
// Module Name:    ALU 
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
module ALU(
    input [31:0] A,
    input [31:0] B,
    input [3:0] ALUOp,
    output [31:0] Result,
    output Zero
    );
	 
	wire [31:0] HI, OR; //��������������������
	assign HI = {B[15:0], 16'b0}, /*��������λ*/
			 OR = {16'b0, B[15:0]}; /*���������λ����*/
	 
	assign Result = (ALUOp[0] && !ALUOp[1] && !ALUOp[2] && !ALUOp[3]) ? (A + B) : 
	{ 
		(ALUOp[1] && !ALUOp[0] && !ALUOp[2] && !ALUOp[3]) ? (A - B) : 
		{
			(ALUOp[2] && !ALUOp[0] && !ALUOp[1] && !ALUOp[3]) ? A | OR:
			{
				(ALUOp[3] && !ALUOp[0] && !ALUOp[1] && !ALUOp[2]) ? HI : 32'hx
			}
		}
	};
	
	assign Zero = !(A - B)? 'b1 : 'b0;
	
	
endmodule
