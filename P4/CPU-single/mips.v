`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:18:43 11/19/2018 
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
	 
	//IFU�ź�
	wire [31:0] Instr,	
		  PC, PC_; //PC��ǰ��PC+4��ֵ
	wire Jump, //J��Jal��תʱ���ź�
		  Jal,
		  J,
		  Jr;
	wire [31:0] ra; //�洢Jal��תʱ31�żĴ���
	wire [25:0] index;
		  
	wire [5:0] Op, Func;
	wire [4:0] Rs, Rt, Rd;
	wire [15:0] imm;
	
	//GRF�ź�
	wire r_WE; /*�Ĵ���д��ʹ���ź�*/
	wire [4:0]A1, A2, r_WA; /*������ַ*/
	wire [31:0] r_WD, /*д������*/
	     RD1, RD2;
	
	//ALU�ź�
	wire [31:0] B; /*B��Դ��RD2��ext,A��Դ��RD1*/
	wire [3:0] ALUOp;
   wire [31:0] Result;
   wire Zero;
	
	//���ݴ洢��
	wire [9:0] d_WA; /*�洢��ַ*/
	wire [31:0] d_WD, /*�洢����*/
		  d_RD; /*��ȡ����*/
	wire SD, LD; /*������ȡ���ź�*/
	
	//��չ���ź�
	wire EXTOp;
	wire [31:0] ext;
	
	//ѡ�����ź�
	wire RegDst, 
		  Branch, 
		  MtoR,
		  Alusel;
		  
	assign Jump  = (Jal || J),
			 Rs    = Instr[25:21],
			 Rt    = Instr[20:16],
			 Rd    = Instr[15:11],
			 imm   = Instr[15:0],
			 Func  = Instr[5:0],
			 Op    = Instr[31:26],
			 index = Instr[25:0],
			 r_WA  = !Jal ? (!RegDst ? Rt : Rd) : 5'h1f, //�Ĵ������ַѡַ
			 B     = !Alusel ? RD2 : ext, //ALU����˿�Bѡ��
			 r_WD  = !Jal ? (!MtoR ? d_RD : Result) : PC_, //�Ĵ���д������WDѡ��
			 d_WA  = Result[11:2],
			 d_WD  = RD2;

IFU IFU(
    .CLK(clk), 
    .RESET(reset), 
    .Zero(Zero && Branch), 
    .beq(ext), 
    .jump(Jump), 
    .jr(Jr), 
    .ra(RD1), 
    .index(index), 
    .Instr(Instr), 
	 .PC(PC),
    .PC_(PC_)
    );

GRF GRF(
    .CLK(clk), 
    .RESET(reset), 
    .WE(r_WE), 
    .A1(Rs), 
    .A2(Rt), 
    .WA(r_WA), 
    .WD(r_WD), 
	 .PC(PC),
    .RD1(RD1), 
    .RD2(RD2)
    );

ALU ALU(
    .A(RD1), 
    .B(B), 
    .ALUOp(ALUOp), 
    .Result(Result), 
    .Zero(Zero)
    );
	 
DM DM(
	 .clk(clk), 
    .clr(reset), 
    .A(d_WA), 
    .WD(d_WD), 
	 .SD(SD),
	 .LD(LD),
    .PC(PC), 
    .RD(d_RD)
    );
	 
EXT EXT(	
	 .imm(imm), 
    .EXTOp(EXTOp), 
	 .ext(ext)
    );
	 
ctrl CTRL(
	 .Func(Func), 
    .Op(Op), 
    .RegDst(RegDst), 
    .Branch(Branch), 
    .MtoR(MtoR), 
    .MW(SD), 
    .MR(LD), 
    .ALUOp(ALUOp), 
    .Alusel(Alusel), 
    .EXTOp(EXTOp), 
    .RW(r_WE), 
    .J(J), 
    .Jal(Jal), 
    .Jr(Jr)
    );
	 

endmodule
