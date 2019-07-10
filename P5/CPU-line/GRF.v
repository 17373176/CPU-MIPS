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
	 output PCsrc_D, /*PC��ת��ѡ����ѡ���ź�*/
	 
	 //��һ����ˮ���Ĵ�������ź�
	 input [31:0] PC_D, Instr_D,
	 
	 //����ˮ���Ĵ���
	 output reg [31:0] Instr_E,
	 output reg [31:0] PC_E,
	 output reg [31:0] RD1_E, RD2_E,
	 output reg [4:0] Rs_E, Rt_E, Rd_E,
	 output reg [31:0] EXT_E,

	 //��ǰ������ź�
	 output [31:0] NPC,
	
	 //��ͣorת���ź�
	 input [2:0] f_Rs_D, f_Rt_D, f_jr_D,
	 input [1:0] f_RD1_D ,f_RD2_D,
	 input reset_E, //beqת�������EX�Ĵ���
	 
	 //D����M��ת���õ�������
	 input [31:0] ALUOut_M, PC_M,
	 
	 //WB����MEM���õ�������
	 input [31:0] RD_W, ALUOut_W, PC_W, RF_WD, Instr_W,
	 input [4:0] WReg_W
	 
    );
	 
//�����������ź�
	 wire [3:0] ALUOp_D;
	 wire Branch_D, MtoR_D, MW_D, MR_D, Alusel_D, RW_D, J, Jal, Jr, LB_D, blez_D, rotrv_D, bltzal_D;
	 wire RW_W, LB_W, Jal_W, bltzal_W;
	 
ctrl D_CTRL(
	 .Func(Instr_D[5:0]), .Op(Instr_D[31:26]), .Branch(Branch_D), .MtoR(MtoR_D), 
    .MW(MW_D), .MR(MR_D), .RW(RW_D),
    .J(J), .Jal(Jal), .Jr(Jr), .LB(LB_D), .blez(blez_D), .rotrv(rotrv_D), .bltzal(bltzal_D)
    );

ctrl WB_CTRL(
	 .Func(Instr_W[5:0]), .Op(Instr_W[31:26]), 
    .RW(RW_W), .Jal(Jal_W), .LB(LB_W), .bltzal(bltzal_W)
    );
	 
	initial begin
		Instr_E <= 32'b0;PC_E <= 32'b0;RD1_E <= 32'b0;RD2_E <= 32'b0;
		Rs_E <= 5'b0; Rt_E <= 5'b0; Rd_E <= 5'b0;EXT_E <= 32'b0;
	end
	
//��ˮ���Ĵ�����ֵ
	always @(posedge CLK) begin /*�����ͣ��Ч����£���ͣ��Ч������*/
		if(reset_E) begin
			Instr_E <= 32'b0; PC_E <= 32'b0; RD1_E <= 32'b0; RD2_E <= 32'b0;
			Rs_E <= 5'b0; Rt_E <= 5'b0; Rd_E <= 5'b0; EXT_E <= 32'b0;
		end
		else begin
			Instr_E <= Instr_D;
			PC_E <= PC_D;
			RD1_E <= RegRD1;
			RD2_E <= RegRD2;
			Rs_E <= Instr_D[25:21]; 
			Rt_E <= Instr_D[20:16]; 
			Rd_E <= Instr_D[15:11];
			EXT_E <= {{16{imm[15]}}, imm};
		end
	end
	
	
//�Ĵ����ļ�
	wire WE; //д���ź�
	wire [31:0] WD;
	wire [4:0] WA; //д���ַ
	wire [4:0] Rs = Instr_D[25:21], Rt = Instr_D[20:16], Rd = Instr_D[15:11];
	wire [4:0] A1 = Rs, A2 = Rt;
	wire [25:0] index = Instr_D[25:0];
	wire [31:0] index_s;
	wire [31:0] WPC;
	
	//����˿ڶ�Ӧ��ַ�ļĴ�����ֵ
	wire [31:0] RegRD1 = f_RD1_D == 2'b01 ? RF_WD : f_RD1_D == 2'b10 ? (PC_W + 32'h8) : grf[A1]; //���мĴ����ڲ���ת��
	wire [31:0] RegRD2 = f_RD2_D == 2'b01 ? RF_WD : f_RD2_D == 2'b10 ? (PC_W + 32'h8) : grf[A2];
	
	//��չ���ź�,������չ
	wire [31:0] ext = {{14{imm[15]}}, imm, 2'b0};
	wire [15:0] imm = Instr_D[15:0];

	reg [31:0] grf[0:31]; //32���Ĵ���
	
	integer i;
	initial /*��ʼ���Ĵ���*/
		for(i = 0; i <= 31; i = i + 1) grf[i] <= 32'h0;
	
	always @(posedge CLK) begin/*ʱ�������ز�д�����ݣ�ͬ����λ*/
		if(RESET) /*��λ�ź���Ч*/
			for(i = 0; i <= 31; i = i + 1) grf[i] <= 32'h0;	
		else if(WE) begin/*д��ʹ���ź���Ч*/
			if(WA != 32'h0) begin 
				grf[WA] <= WD; /*��֤0�żĴ���Ϊ0*/
				$display("%d@%h: $%d <= %h", $time, WPC, WA, WD); 
			end
		end
	end
	
	
//beq����bne, j, jal, jr��ת�ж�������ǰ
	wire [31:0] RD1, RD2;
   reg [2:0] PCsel;
	
	assign RD1 = f_Rs_D == 3'b001 ? ALUOut_M : 
					 f_Rs_D == 3'b010 ? ALUOut_W : 
					 f_Rs_D == 3'b011 ? RD_W :
					 f_Rs_D == 3'b100 ? (PC_E + 32'h8) :
					 f_Rs_D == 3'b101 ? (PC_M + 32'h8) :
					 f_Rs_D == 3'b110 ? (PC_W + 32'h8) : RegRD1, //beqת��
			 RD2 = f_Rt_D == 3'b001 ? ALUOut_M : 
					 f_Rt_D == 3'b010 ? ALUOut_W : 
					 f_Rt_D == 3'b011 ? RD_W : 
					 f_Rt_D == 3'b100 ? (PC_E + 32'h8) :
					 f_Rt_D == 3'b101 ? (PC_M + 32'h8) :
					 f_Rt_D == 3'b110 ? (PC_W + 32'h8) : RegRD2; //beqת��
	
	always @(*) begin
		if($signed(RD1) < 0 && bltzal_D) PCsel <= 3'b000; //bltzal, bltzalr��bltzal��ת����һ��
		else if($signed(RD1) == $signed(RD2) && Branch_D) PCsel <= 3'b000; //beq
		else if($signed(RD1) <= 0 && blez_D) PCsel <= 3'b000; //blez, bgez, bltz, bgtz������  
		else if(J) PCsel <= 3'b010;
		else if(Jal) PCsel <= 3'b011;
		else if(Jr) PCsel <= 3'b100;
		else PCsel <= 3'b111; 
	end
	
	assign NPC = PCsel == 3'b000 ? (ext + PC_D + 32'h4) :  // ��ת��ǩ��չ��ĵ�ַ
					 PCsel == 3'b010 ? index_s : // ��ת��Jָ��ƴ�ӵ�ַ
					 PCsel == 3'b011 ? index_s : 
					 PCsel == 3'b100 ? ra : 0, //��תra�Ĵ���ָ���PC
			 PCsrc_D = !(PCsel == 3'b111);
					 
	wire [31:0] ra = f_jr_D == 3'b001 ? ALUOut_M : // ����ת����д������
						  f_jr_D == 3'b010 ? ALUOut_W :
						  f_jr_D == 3'b011 ? RD_W : 
						  f_jr_D == 3'b100 ? (PC_E + 32'h8) :
						  f_jr_D == 3'b101 ? (PC_M + 32'h8) : 
						  f_jr_D == 3'b110 ? (PC_W + 32'h8) : RegRD1; //д�����ݺ�jr��ת����
	
	 assign index_s = {PC_D[31:28], index, 2'b0}, //J��Jalָ����ת��ƴ�ӵ�ַ
			  WE = RW_W,
			  WA = (Jal_W || bltzal_W) ? 5'h1f : WReg_W, //��ת������д��31�żĴ���ֵ jalr��Ҫ�����ź��Լ�rd�ĵ�ַ
			  WD = (Jal_W || bltzal_W)? (PC_W + 32'h8) : RF_WD, //��ת����д��$31ֵΪPC+8
			  WPC = PC_W; //�Ĵ����ļ��洢ʱָ���ַPC
			  
	
endmodule
