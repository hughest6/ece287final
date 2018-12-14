module testing(clk, rst, outDispToggle, viewa, viewb, a0, b0, c0, d0, e0, f0, g0, a1, b1, c1, d1, e1, f1, g1, a2, b2, c2, d2, e2, f2, g2,
					     a3, b3, c3, d3, e3, f3, g3, a4, b4, c4, d4, e4, f4, g4, a5, b5, c5, d5, e5, f5, g5,
						  a6, b6, c6, d6, e6, f6, g6, a7, b7, c7, d7, e7, f7, g7);
input clk, rst, outDispToggle, viewa, viewb;
output a0, b0, c0, d0, e0, f0, g0, a1, b1, c1, d1, e1, f1, g1, a2, b2, c2, d2, e2, f2, g2,
		 a3, b3, c3, d3, e3, f3, g3, a4, b4, c4, d4, e4, f4, g4, a5, b5, c5, d5, e5, f5, g5,
		 a6, b6, c6, d6, e6, f6, g6, a7, b7, c7, d7, e7, f7, g7;

wire[63:0] finalEncryption;
reg[2:0] S, NS;

reg[63:0] inKeyIn;
wire[63:0] inKeyOut;
ram64 inKey(clk, rst, inKeyIn, 1'b1, inKeyOut);
reg[63:0] inValIn;
wire[63:0] inValOut;
ram64 inVal(clk, rst, inValIn, 1'b1, inValOut);
wire[63:0] mixValIn;
wire[63:0] mixValOut;
ram64 mixVal(clk, rst, mixValIn, 1'b1, mixValOut);
reg[3:0]encryptStartIn;
wire[3:0]encryptStartOut;
ram4 encryptStart(clk, rst, encryptStartIn, 1'b1, encryptStartOut);


parameter start = 4'd0;
parameter step1 = 4'd1;
parameter step2 = 4'd2;	
parameter finish = 4'd3;	
	
wire encryptDone;

wire[8:0] loopcounter;
encryptionExecute encrypt(clk, rst, encryptStartOut, encryptDone, mixValOut[31:0], mixValOut[63:32], inKeyOut, finalEncryption, loopcounter);
	
reg[3:0] num0, num1, num2, num3, num4, num5, num6, num7;
display disp0(num0, a0, b0, c0, d0, e0, f0, g0);
display disp1(num1, a1, b1, c1, d1, e1, f1, g1);
display disp2(num2, a2, b2, c2, d2, e2, f2, g2);
display disp3(num3, a3, b3, c3, d3, e3, f3, g3);
display disp4(num4, a4, b4, c4, d4, e4, f4, g4);
display disp5(num5, a5, b5, c5, d5, e5, f5, g5);
display disp6(num6, a6, b6, c6, d6, e6, f6, g6);
display disp7(num7, a7, b7, c7, d7, e7, f7, g7);

assign mixValIn = {inValOut[57], inValOut[49], inValOut[41], inValOut[33], inValOut[25], inValOut[17], inValOut[9], inValOut[1],
						inValOut[59], inValOut[51], inValOut[43], inValOut[35], inValOut[27], inValOut[19], inValOut[11], inValOut[3],
						inValOut[61], inValOut[53], inValOut[45], inValOut[37], inValOut[29], inValOut[21], inValOut[13], inValOut[5],
						inValOut[63], inValOut[55], inValOut[47], inValOut[39], inValOut[31], inValOut[23], inValOut[15], inValOut[7],
						inValOut[56], inValOut[48], inValOut[40], inValOut[32], inValOut[24], inValOut[16], inValOut[8], inValOut[0],
						inValOut[58], inValOut[50], inValOut[42], inValOut[34], inValOut[26], inValOut[18], inValOut[10], inValOut[2],
						inValOut[60], inValOut[52], inValOut[44], inValOut[36], inValOut[28], inValOut[20], inValOut[12], inValOut[4],
						inValOut[62], inValOut[54], inValOut[46], inValOut[38], inValOut[30], inValOut[22], inValOut[14], inValOut[6]};
	
always @ (posedge clk or negedge rst)
	begin
		if(rst == 1'b0)
		begin
			S <= start;
		end
		else 
		begin
			S <= NS;
		end
	end

// handle assigning key and value
always @ (posedge clk or negedge rst)
begin
	case (S)
		default : begin
		
		inKeyIn = 64'b0001001100110100010101110111100110011011101111001101111111110001;
		inValIn = 64'b0000000100100011010001010110011110001001101010111100110111101111;
		
		end
	endcase
end

// handle assigning encrypt start
always @ (posedge clk or negedge rst)
begin
	case (S)
		step2 : encryptStartIn = 1'b1;
		default : encryptStartIn = 1'b0;
	endcase
end

	
always @ (*)
begin
	case(S)
		start : begin
			NS = step1;
		end
		
		step1 : begin						 
			NS = step2;
		end
		
		step2 : begin
			if(encryptDone != 1'b1)
			begin
				NS = step2;
			end
			else
			begin
				NS = finish;
			end
		end
		
		finish : begin
			NS = finish;
		end
		
		default : NS = finish;
	
	endcase
end

reg[2:0] view;
always @ (*)
begin
	view = {viewb, viewa};
	case(view)
		// Display value to be encrypted
		2'd0 : begin
			if(outDispToggle == 1'b1)
			begin
				num0 = inValOut[3:0];
				num1 = inValOut[7:4];
				num2 = inValOut[11:8];
				num3 = inValOut[15:12];
				num4 = inValOut[19:16];
				num5 = inValOut[23:20];
				num6 = inValOut[27:24];
				num7 = inValOut[31:28];
			end
		   else
		   begin
				num0 = inValOut[35:32];
				num1 = inValOut[39:36];
				num2 = inValOut[43:40];
				num3 = inValOut[47:44];
				num4 = inValOut[51:48];
				num5 = inValOut[55:52];
				num6 = inValOut[59:56];
				num7 = inValOut[63:60];
			end
		end
		
		// Display key to use for encryption
		2'd1 : begin
			if(outDispToggle == 1'b1)
			begin
				num0 = inKeyOut[3:0];
				num1 = inKeyOut[7:4];
				num2 = inKeyOut[11:8];
				num3 = inKeyOut[15:12];
				num4 = inKeyOut[19:16];
				num5 = inKeyOut[23:20];
				num6 = inKeyOut[27:24];
				num7 = inKeyOut[31:28];
			end
		   else
		   begin
				num0 = inKeyOut[35:32];
				num1 = inKeyOut[39:36];
				num2 = inKeyOut[43:40];
				num3 = inKeyOut[47:44];
				num4 = inKeyOut[51:48];
				num5 = inKeyOut[55:52];
				num6 = inKeyOut[59:56];
				num7 = inKeyOut[63:60];
			end
		end
		
		// Display encrypted value
		2'd2 : begin
			if(outDispToggle == 1'b1)
			begin
				num0 = finalEncryption[3:0];
				num1 = finalEncryption[7:4];
				num2 = finalEncryption[11:8];
				num3 = finalEncryption[15:12];
				num4 = finalEncryption[19:16];
				num5 = finalEncryption[23:20];
				num6 = finalEncryption[27:24];
				num7 = finalEncryption[31:28];
			end
			else
			begin
				num0 = finalEncryption[35:32];
				num1 = finalEncryption[39:36];
				num2 = finalEncryption[43:40];
				num3 = finalEncryption[47:44];
				num4 = finalEncryption[51:48];
				num5 = finalEncryption[55:52];
				num6 = finalEncryption[59:56];
				num7 = finalEncryption[63:60];
			end
		end
		
		default : begin
			num0 = loopcounter[0];
			num1 = loopcounter[1];
			num2 = loopcounter[2];
			num3 = loopcounter[3];
			num4 = loopcounter[4];
			num5 = loopcounter[5];
			num6 = loopcounter[6];
			num7 = loopcounter[7];
		end
	
	endcase
	
end

endmodule

//--------------------------------------------------------------------
// Generate 16 keys based on input key 
//--------------------------------------------------------------------
module keyGen(keyTimingStart, keyTimingDone, clk, rst, keyInput, K1, K2, K3, K4, K5, K6, K7, K8, K9, K10, K11, K12, K13, K14, K15, K16);
// IO ----------------------------------------------------------------
input clk, rst, keyTimingStart;
input[63:0] keyInput;
output keyTimingDone;
reg keyTimingDone;
output[63:0] K1, K2, K3, K4, K5, K6, K7, K8, K9, K10, K11, K12, K13, K14, K15, K16;
assign K1 = outK1;
assign K2 = outK2;
assign K3 = outK3;
assign K4 = outK4;
assign K5 = outK5;
assign K6 = outK6;
assign K7 = outK7;
assign K8 = outK8;
assign K9 = outK9;
assign K10 = outK10;
assign K11 = outK11;
assign K12 = outK12;
assign K13 = outK13;
assign K14 = outK14;
assign K15 = outK15;
assign K16 = outK16;

// Registers to tie outputs of bit swapping
reg[55:0] keyhold1;
reg[55:0] keyhold2;
reg[55:0] keyhold3;
reg[55:0] keyhold4;
reg[55:0] keyhold5;
reg[55:0] keyhold6;
reg[55:0] keyhold7;
reg[55:0] keyhold8;
reg[55:0] keyhold9;
reg[55:0] keyhold10;
reg[55:0] keyhold11;
reg[55:0] keyhold12;
reg[55:0] keyhold13;
reg[55:0] keyhold14;
reg[55:0] keyhold15;
reg[55:0] keyhold16;

// Local ram 
reg[63:0] inK0;
wire[63:0] outK0;
ram64 K0ram(clk, rst, {8'h00, inK0}, 1'b1, outK0);
reg[63:0] inK1;
wire[63:0] outK1;
ram64 K1ram(clk, rst, {16'h00, inK1}, 1'b1, outK1);
reg[63:0] inK2;
wire[63:0] outK2;
ram64 K2ram(clk, rst, {16'h00, inK2}, 1'b1, outK2);
reg[63:0] inK3;
wire[63:0] outK3;
ram64 K3ram(clk, rst, {16'h00, inK3}, 1'b1, outK3);
reg[63:0] inK4;
wire[63:0] outK4;
ram64 K4ram(clk, rst, {16'h00, inK4}, 1'b1, outK4);
reg[63:0] inK5;
wire[63:0] outK5;
ram64 K5ram(clk, rst, {16'h00, inK5}, 1'b1, outK5);
reg[63:0] inK6;
wire[63:0] outK6;
ram64 K6ram(clk, rst, {16'h00, inK6}, 1'b1, outK6);
reg[63:0] inK7;
wire[63:0] outK7;
ram64 K7ram(clk, rst, {16'h00, inK7}, 1'b1, outK7);
reg[63:0] inK8;
wire[63:0] outK8;
ram64 K8ram(clk, rst, {16'h00, inK8}, 1'b1, outK8);
reg[63:0] inK9;
wire[63:0] outK9;
ram64 K9ram(clk, rst, {16'h00, inK9}, 1'b1, outK9);
reg[63:0] inK10;
wire[63:0] outK10;
ram64 K10ram(clk, rst, {16'h00, inK10}, 1'b1, outK10);
reg[63:0] inK11;
wire[63:0] outK11;
ram64 K11ram(clk, rst, {16'h00, inK11}, 1'b1, outK11);
reg[63:0] inK12;
wire[63:0] outK12;
ram64 K12ram(clk, rst, {16'h00, inK12}, 1'b1, outK12);
reg[63:0] inK13;
wire[63:0] outK13;
ram64 K13ram(clk, rst, {16'h00, inK13}, 1'b1, outK13);
reg[63:0] inK14;
wire[63:0] outK14;
ram64 K14ram(clk, rst, {16'h00, inK14}, 1'b1, outK14);
reg[63:0] inK15;
wire[63:0] outK15;
ram64 K15ram(clk, rst, {16'h00, inK15}, 1'b1, outK15);
reg[63:0] inK16;
wire[63:0] outK16;
ram64 K16ram(clk, rst, {16'h00, inK16}, 1'b1, outK16);


reg[3:0] S, NS;
parameter start = 3'd0;
parameter firstperm = 3'd1;
parameter subkeyshift = 3'd2;
parameter secondperm =3'd3;
parameter done =3'd4;

// Sequential control section
always @ (posedge clk or negedge rst)
begin
	if(rst == 1'b0)
	begin
		S <= start;
	end
	else 
	begin
		S <= NS;
	end
end

always @ (*)
begin
	case(S)
		start : begin
			if(keyTimingStart == 1'b1)
			begin
				NS = firstperm;
			end
			else
			begin
				NS = start;
			end
		end
		firstperm : NS = subkeyshift;
		
		subkeyshift : NS = secondperm;
		
		secondperm : NS = done;
		
		done : NS = done;
		
		default : NS = start;
	endcase

end

// handle keytimingdone
always @ (posedge clk or negedge rst)
begin
	case(S)
		start : keyTimingDone = 1'b0;
		done : keyTimingDone = 1'b1;
		default : keyTimingDone = 1'b0;
	
	endcase
end

// handle assigning inputs
always @ (posedge clk or negedge rst)
begin
	case(S)
		start : inK0 = 56'd0;
		firstperm : inK0 = {keyInput[56], keyInput[48], keyInput[40], keyInput[32], keyInput[24], keyInput[16], keyInput[8],
									keyInput[0], keyInput[57], keyInput[49], keyInput[41], keyInput[33], keyInput[25], keyInput[17],
									keyInput[9], keyInput[1], keyInput[58], keyInput[50], keyInput[42], keyInput[34], keyInput[26],
									keyInput[18], keyInput[10], keyInput[2], keyInput[59], keyInput[51], keyInput[43], keyInput[35],
									keyInput[62], keyInput[54], keyInput[46], keyInput[38], keyInput[30], keyInput[22], keyInput[14],
									keyInput[6], keyInput[61], keyInput[53], keyInput[45], keyInput[37], keyInput[29], keyInput[21],
									keyInput[13], keyInput[5], keyInput[60], keyInput[52], keyInput[44], keyInput[36], keyInput[28],
									keyInput[20], keyInput[12], keyInput[4], keyInput[27], keyInput[19], keyInput[11], keyInput[3]};
	
	default : inK0 = outK0;
	endcase
end

// handle assigning subkeys
always @ (posedge clk or negedge rst)
begin
	case(S)
		
		subkeyshift : begin
			keyhold1 = {outK0[54:28], outK0[55],outK0[26:0], outK0[27]};
			keyhold2 = {outK0[53:28], outK0[55:54],outK0[25:0], outK0[27:26]};
			keyhold3 = {outK0[51:28], outK0[55:52],outK0[23:0], outK0[27:24]};
			keyhold4 = {outK0[49:28], outK0[55:50],outK0[21:0], outK0[27:22]};
			keyhold5 = {outK0[47:28], outK0[55:48],outK0[19:0], outK0[27:20]};
			keyhold6 = {outK0[45:28], outK0[55:46],outK0[17:0], outK0[27:18]};
			keyhold7 = {outK0[43:28], outK0[55:44],outK0[15:0], outK0[27:16]};
			keyhold8 = {outK0[41:28], outK0[55:42],outK0[13:0], outK0[27:14]};
			keyhold9 = {outK0[40:28], outK0[55:41],outK0[12:0], outK0[27:13]};
			keyhold10 = {outK0[38:28], outK0[55:39],outK0[10:0], outK0[27:11]};
			keyhold11 = {outK0[36:28], outK0[55:37],outK0[8:0], outK0[27:9]};
			keyhold12 = {outK0[34:28], outK0[55:35],outK0[6:0], outK0[27:7]};
			keyhold13 = {outK0[32:28], outK0[55:33],outK0[4:0], outK0[27:5]};
			keyhold14 = {outK0[30:28], outK0[55:31],outK0[2:0], outK0[27:3]};
			keyhold15 = {outK0[28], outK0[55:29],outK0[0], outK0[27:1]};
			keyhold16 = outK0[55:0];
		end
		
		secondperm : begin
			keyhold1 = {outK0[54:28], outK0[55],outK0[26:0], outK0[27]};
			keyhold2 = {outK0[53:28], outK0[55:54],outK0[25:0], outK0[27:26]};
			keyhold3 = {outK0[51:28], outK0[55:52],outK0[23:0], outK0[27:24]};
			keyhold4 = {outK0[49:28], outK0[55:50],outK0[21:0], outK0[27:22]};
			keyhold5 = {outK0[47:28], outK0[55:48],outK0[19:0], outK0[27:20]};
			keyhold6 = {outK0[45:28], outK0[55:46],outK0[17:0], outK0[27:18]};
			keyhold7 = {outK0[43:28], outK0[55:44],outK0[15:0], outK0[27:16]};
			keyhold8 = {outK0[41:28], outK0[55:42],outK0[13:0], outK0[27:14]};
			keyhold9 = {outK0[40:28], outK0[55:41],outK0[12:0], outK0[27:13]};
			keyhold10 = {outK0[38:28], outK0[55:39],outK0[10:0], outK0[27:11]};
			keyhold11 = {outK0[36:28], outK0[55:37],outK0[8:0], outK0[27:9]};
			keyhold12 = {outK0[34:28], outK0[55:35],outK0[6:0], outK0[27:7]};
			keyhold13 = {outK0[32:28], outK0[55:33],outK0[4:0], outK0[27:5]};
			keyhold14 = {outK0[30:28], outK0[55:31],outK0[2:0], outK0[27:3]};
			keyhold15 = {outK0[28], outK0[55:29],outK0[0], outK0[27:1]};
			keyhold16 = outK0[55:0];
		end

	default : begin
			keyhold1 = 56'd0;
			keyhold2 = 56'd0;
			keyhold3 = 56'd0;
			keyhold4 = 56'd0;
			keyhold5 = 56'd0;
			keyhold6 = 56'd0;
			keyhold7 = 56'd0;
			keyhold8 = 56'd0;
			keyhold9 = 56'd0;
			keyhold10 = 56'd0;
			keyhold11 = 56'd0;
			keyhold12 = 56'd0;
			keyhold13 = 56'd0;
			keyhold14 = 56'd0;
			keyhold15 = 56'd0;
			keyhold16 = 56'd0;
		end
	endcase
end

// handle assigning outputkeys 
always @ (posedge clk or negedge rst)
begin
	case(S)

		start : begin
			inK1 = 48'd0;
			inK2 = 48'd0;
			inK3 = 48'd0;
			inK4 = 48'd0;
			inK5 = 48'd0;
			inK6 = 48'd0;
			inK7 = 48'd0;
			inK8 = 48'd0;
			inK9 = 48'd0;
			inK10 = 48'd0;
			inK11 = 48'd0;
			inK12 = 48'd0;
			inK13 = 48'd0;
			inK14 = 48'd0;
			inK15 = 48'd0;
			inK16 = 48'd0;
			
		end
		
		secondperm : begin
			inK1 = {keyhold1[13], keyhold1[16], keyhold1[10], keyhold1[23], keyhold1[0], keyhold1[4],
					  keyhold1[2], keyhold1[27], keyhold1[14], keyhold1[5], keyhold1[20], keyhold1[9],
					  keyhold1[22], keyhold1[18], keyhold1[11], keyhold1[3], keyhold1[25], keyhold1[7],
					  keyhold1[15], keyhold1[6], keyhold1[26], keyhold1[19], keyhold1[12], keyhold1[1],
					  keyhold1[40], keyhold1[51], keyhold1[30], keyhold1[36], keyhold1[46], keyhold1[54],
					  keyhold1[29], keyhold1[39], keyhold1[50], keyhold1[44], keyhold1[32], keyhold1[47],
					  keyhold1[43], keyhold1[48], keyhold1[38], keyhold1[55], keyhold1[33], keyhold1[52],
					  keyhold1[45], keyhold1[41], keyhold1[49], keyhold1[35], keyhold1[28], keyhold1[31]};
					  
			inK2 = {keyhold2[13], keyhold2[16], keyhold2[10], keyhold2[23], keyhold2[0], keyhold2[4],
					  keyhold2[2], keyhold2[27], keyhold2[14], keyhold2[5], keyhold2[20], keyhold2[9],
					  keyhold2[22], keyhold2[18], keyhold2[11], keyhold2[3], keyhold2[25], keyhold2[7],
					  keyhold2[15], keyhold2[6], keyhold2[26], keyhold2[19], keyhold2[12], keyhold2[1],
					  keyhold2[40], keyhold2[51], keyhold2[30], keyhold2[36], keyhold2[46], keyhold2[54],
					  keyhold2[29], keyhold2[39], keyhold2[50], keyhold2[44], keyhold2[32], keyhold2[47],
					  keyhold2[43], keyhold2[48], keyhold2[38], keyhold2[55], keyhold2[33], keyhold2[52],
					  keyhold2[45], keyhold2[41], keyhold2[49], keyhold2[35], keyhold2[28], keyhold2[31]};
					  
			inK3 = {keyhold3[13], keyhold3[16], keyhold3[10], keyhold3[23], keyhold3[0], keyhold3[4],
					  keyhold3[2], keyhold3[27], keyhold3[14], keyhold3[5], keyhold3[20], keyhold3[9],
					  keyhold3[22], keyhold3[18], keyhold3[11], keyhold3[3], keyhold3[25], keyhold3[7],
					  keyhold3[15], keyhold3[6], keyhold3[26], keyhold3[19], keyhold3[12], keyhold3[1],
					  keyhold3[40], keyhold3[51], keyhold3[30], keyhold3[36], keyhold3[46], keyhold3[54],
					  keyhold3[29], keyhold3[39], keyhold3[50], keyhold3[44], keyhold3[32], keyhold3[47],
					  keyhold3[43], keyhold3[48], keyhold3[38], keyhold3[55], keyhold3[33], keyhold3[52],
					  keyhold3[45], keyhold3[41], keyhold3[49], keyhold3[35], keyhold3[28], keyhold3[31]};
					  
			inK4 = {keyhold4[13], keyhold4[16], keyhold4[10], keyhold4[23], keyhold4[0], keyhold4[4],
					  keyhold4[2], keyhold4[27], keyhold4[14], keyhold4[5], keyhold4[20], keyhold4[9],
					  keyhold4[22], keyhold4[18], keyhold4[11], keyhold4[3], keyhold4[25], keyhold4[7],
					  keyhold4[15], keyhold4[6], keyhold4[26], keyhold4[19], keyhold4[12], keyhold4[1],
					  keyhold4[40], keyhold4[51], keyhold4[30], keyhold4[36], keyhold4[46], keyhold4[54],
					  keyhold4[29], keyhold4[39], keyhold4[50], keyhold4[44], keyhold4[32], keyhold4[47],
					  keyhold4[43], keyhold4[48], keyhold4[38], keyhold4[55], keyhold4[33], keyhold4[52],
					  keyhold4[45], keyhold4[41], keyhold4[49], keyhold4[35], keyhold4[28], keyhold4[31]};
					  
			inK5 = {keyhold5[13], keyhold5[16], keyhold5[10], keyhold5[23], keyhold5[0], keyhold5[4],
					  keyhold5[2], keyhold5[27], keyhold5[14], keyhold5[5], keyhold5[20], keyhold5[9],
					  keyhold5[22], keyhold5[18], keyhold5[11], keyhold5[3], keyhold5[25], keyhold5[7],
					  keyhold5[15], keyhold5[6], keyhold5[26], keyhold5[19], keyhold5[12], keyhold5[1],
					  keyhold5[40], keyhold5[51], keyhold5[30], keyhold5[36], keyhold5[46], keyhold5[54],
					  keyhold5[29], keyhold5[39], keyhold5[50], keyhold5[44], keyhold5[32], keyhold5[47],
					  keyhold5[43], keyhold5[48], keyhold5[38], keyhold5[55], keyhold5[33], keyhold5[52],
					  keyhold5[45], keyhold5[41], keyhold5[49], keyhold5[35], keyhold5[28], keyhold5[31]};
					  
			inK6 = {keyhold6[13], keyhold6[16], keyhold6[10], keyhold6[23], keyhold6[0], keyhold6[4],
					  keyhold6[2], keyhold6[27], keyhold6[14], keyhold6[5], keyhold6[20], keyhold6[9],
					  keyhold6[22], keyhold6[18], keyhold6[11], keyhold6[3], keyhold6[25], keyhold6[7],
					  keyhold6[15], keyhold6[6], keyhold6[26], keyhold6[19], keyhold6[12], keyhold6[1],
					  keyhold6[40], keyhold6[51], keyhold6[30], keyhold6[36], keyhold6[46], keyhold6[54],
					  keyhold6[29], keyhold6[39], keyhold6[50], keyhold6[44], keyhold6[32], keyhold6[47],
					  keyhold6[43], keyhold6[48], keyhold6[38], keyhold6[55], keyhold6[33], keyhold6[52],
					  keyhold6[45], keyhold6[41], keyhold6[49], keyhold6[35], keyhold6[28], keyhold6[31]};
					  
			inK7 = {keyhold7[13], keyhold7[16], keyhold7[10], keyhold7[23], keyhold7[0], keyhold7[4],
					  keyhold7[2], keyhold7[27], keyhold7[14], keyhold7[5], keyhold7[20], keyhold7[9],
					  keyhold7[22], keyhold7[18], keyhold7[11], keyhold7[3], keyhold7[25], keyhold7[7],
					  keyhold7[15], keyhold7[6], keyhold7[26], keyhold7[19], keyhold7[12], keyhold7[1],
					  keyhold7[40], keyhold7[51], keyhold7[30], keyhold7[36], keyhold7[46], keyhold7[54],
					  keyhold7[29], keyhold7[39], keyhold7[50], keyhold7[44], keyhold7[32], keyhold7[47],
					  keyhold7[43], keyhold7[48], keyhold7[38], keyhold7[55], keyhold7[33], keyhold7[52],
					  keyhold7[45], keyhold7[41], keyhold7[49], keyhold7[35], keyhold7[28], keyhold7[31]};
					  
			inK8 = {keyhold8[13], keyhold8[16], keyhold8[10], keyhold8[23], keyhold8[0], keyhold8[4],
					  keyhold8[2], keyhold8[27], keyhold8[14], keyhold8[5], keyhold8[20], keyhold8[9],
					  keyhold8[22], keyhold8[18], keyhold8[11], keyhold8[3], keyhold8[25], keyhold8[7],
					  keyhold8[15], keyhold8[6], keyhold8[26], keyhold8[19], keyhold8[12], keyhold8[1],
					  keyhold8[40], keyhold8[51], keyhold8[30], keyhold8[36], keyhold8[46], keyhold8[54],
					  keyhold8[29], keyhold8[39], keyhold8[50], keyhold8[44], keyhold8[32], keyhold8[47],
					  keyhold8[43], keyhold8[48], keyhold8[38], keyhold8[55], keyhold8[33], keyhold8[52],
					  keyhold8[45], keyhold8[41], keyhold8[49], keyhold8[35], keyhold8[28], keyhold8[31]};
					  
			inK9 = {keyhold9[13], keyhold9[16], keyhold9[10], keyhold9[23], keyhold9[0], keyhold9[4],
					  keyhold9[2], keyhold9[27], keyhold9[14], keyhold9[5], keyhold9[20], keyhold9[9],
					  keyhold9[22], keyhold9[18], keyhold9[11], keyhold9[3], keyhold9[25], keyhold9[7],
					  keyhold9[15], keyhold9[6], keyhold9[26], keyhold9[19], keyhold9[12], keyhold9[1],
					  keyhold9[40], keyhold9[51], keyhold9[30], keyhold9[36], keyhold9[46], keyhold9[54],
					  keyhold9[29], keyhold9[39], keyhold9[50], keyhold9[44], keyhold9[32], keyhold9[47],
					  keyhold9[43], keyhold9[48], keyhold9[38], keyhold9[55], keyhold9[33], keyhold9[52],
					  keyhold9[45], keyhold9[41], keyhold9[49], keyhold9[35], keyhold9[28], keyhold9[31]};
					  
			inK10 = {keyhold10[13], keyhold10[16], keyhold10[10], keyhold10[23], keyhold10[0], keyhold10[4],
					  keyhold10[2], keyhold10[27], keyhold10[14], keyhold10[5], keyhold10[20], keyhold10[9],
					  keyhold10[22], keyhold10[18], keyhold10[11], keyhold10[3], keyhold10[25], keyhold10[7],
					  keyhold10[15], keyhold10[6], keyhold10[26], keyhold10[19], keyhold10[12], keyhold10[1],
					  keyhold10[40], keyhold10[51], keyhold10[30], keyhold10[36], keyhold10[46], keyhold10[54],
					  keyhold10[29], keyhold10[39], keyhold10[50], keyhold10[44], keyhold10[32], keyhold10[47],
					  keyhold10[43], keyhold10[48], keyhold10[38], keyhold10[55], keyhold10[33], keyhold10[52],
					  keyhold10[45], keyhold10[41], keyhold10[49], keyhold10[35], keyhold10[28], keyhold10[31]};
					  
			inK11 = {keyhold11[13], keyhold11[16], keyhold11[10], keyhold11[23], keyhold11[0], keyhold11[4],
					  keyhold11[2], keyhold11[27], keyhold11[14], keyhold11[5], keyhold11[20], keyhold11[9],
					  keyhold11[22], keyhold11[18], keyhold11[11], keyhold11[3], keyhold11[25], keyhold11[7],
					  keyhold11[15], keyhold11[6], keyhold11[26], keyhold11[19], keyhold11[12], keyhold11[1],
					  keyhold11[40], keyhold11[51], keyhold11[30], keyhold11[36], keyhold11[46], keyhold11[54],
					  keyhold11[29], keyhold11[39], keyhold11[50], keyhold11[44], keyhold11[32], keyhold11[47],
					  keyhold11[43], keyhold11[48], keyhold11[38], keyhold11[55], keyhold11[33], keyhold11[52],
					  keyhold11[45], keyhold11[41], keyhold11[49], keyhold11[35], keyhold11[28], keyhold11[31]};
					  
			inK12 = {keyhold12[13], keyhold12[16], keyhold12[10], keyhold12[23], keyhold12[0], keyhold12[4],
					  keyhold12[2], keyhold12[27], keyhold12[14], keyhold12[5], keyhold12[20], keyhold12[9],
					  keyhold12[22], keyhold12[18], keyhold12[11], keyhold12[3], keyhold12[25], keyhold12[7],
					  keyhold12[15], keyhold12[6], keyhold12[26], keyhold12[19], keyhold12[12], keyhold12[1],
					  keyhold12[40], keyhold12[51], keyhold12[30], keyhold12[36], keyhold12[46], keyhold12[54],
					  keyhold12[29], keyhold12[39], keyhold12[50], keyhold12[44], keyhold12[32], keyhold12[47],
					  keyhold12[43], keyhold12[48], keyhold12[38], keyhold12[55], keyhold12[33], keyhold12[52],
					  keyhold12[45], keyhold12[41], keyhold12[49], keyhold12[35], keyhold12[28], keyhold12[31]};
					  
			inK13 = {keyhold13[13], keyhold13[16], keyhold13[10], keyhold13[23], keyhold13[0], keyhold13[4],
					  keyhold13[2], keyhold13[27], keyhold13[14], keyhold13[5], keyhold13[20], keyhold13[9],
					  keyhold13[22], keyhold13[18], keyhold13[11], keyhold13[3], keyhold13[25], keyhold13[7],
					  keyhold13[15], keyhold13[6], keyhold13[26], keyhold13[19], keyhold13[12], keyhold13[1],
					  keyhold13[40], keyhold13[51], keyhold13[30], keyhold13[36], keyhold13[46], keyhold13[54],
					  keyhold13[29], keyhold13[39], keyhold13[50], keyhold13[44], keyhold13[32], keyhold13[47],
					  keyhold13[43], keyhold13[48], keyhold13[38], keyhold13[55], keyhold13[33], keyhold13[52],
					  keyhold13[45], keyhold13[41], keyhold13[49], keyhold13[35], keyhold13[28], keyhold13[31]};
					  
			inK14 = {keyhold14[13], keyhold14[16], keyhold14[10], keyhold14[23], keyhold14[0], keyhold14[4],
					  keyhold14[2], keyhold14[27], keyhold14[14], keyhold14[5], keyhold14[20], keyhold14[9],
					  keyhold14[22], keyhold14[18], keyhold14[11], keyhold14[3], keyhold14[25], keyhold14[7],
					  keyhold14[15], keyhold14[6], keyhold14[26], keyhold14[19], keyhold14[12], keyhold14[1],
					  keyhold14[40], keyhold14[51], keyhold14[30], keyhold14[36], keyhold14[46], keyhold14[54],
					  keyhold14[29], keyhold14[39], keyhold14[50], keyhold14[44], keyhold14[32], keyhold14[47],
					  keyhold14[43], keyhold14[48], keyhold14[38], keyhold14[55], keyhold14[33], keyhold14[52],
					  keyhold14[45], keyhold14[41], keyhold14[49], keyhold14[35], keyhold14[28], keyhold14[31]};
					  
			inK15 = {keyhold15[13], keyhold15[16], keyhold15[10], keyhold15[23], keyhold15[0], keyhold15[4],
					  keyhold15[2], keyhold15[27], keyhold15[14], keyhold15[5], keyhold15[20], keyhold15[9],
					  keyhold15[22], keyhold15[18], keyhold15[11], keyhold15[3], keyhold15[25], keyhold15[7],
					  keyhold15[15], keyhold15[6], keyhold15[26], keyhold15[19], keyhold15[12], keyhold15[1],
					  keyhold15[40], keyhold15[51], keyhold15[30], keyhold15[36], keyhold15[46], keyhold15[54],
					  keyhold15[29], keyhold15[39], keyhold15[50], keyhold15[44], keyhold15[32], keyhold15[47],
					  keyhold15[43], keyhold15[48], keyhold15[38], keyhold15[55], keyhold15[33], keyhold15[52],
					  keyhold15[45], keyhold15[41], keyhold15[49], keyhold15[35], keyhold15[28], keyhold15[31]};
					  
			inK16 = {keyhold16[13], keyhold16[16], keyhold16[10], keyhold16[23], keyhold16[0], keyhold16[4],
					  keyhold16[2], keyhold16[27], keyhold16[14], keyhold16[5], keyhold16[20], keyhold16[9],
					  keyhold16[22], keyhold16[18], keyhold16[11], keyhold16[3], keyhold16[25], keyhold16[7],
					  keyhold16[15], keyhold16[6], keyhold16[26], keyhold16[19], keyhold16[12], keyhold16[1],
					  keyhold16[40], keyhold16[51], keyhold16[30], keyhold16[36], keyhold16[46], keyhold16[54],
					  keyhold16[29], keyhold16[39], keyhold16[50], keyhold16[44], keyhold16[32], keyhold16[47],
					  keyhold16[43], keyhold16[48], keyhold16[38], keyhold16[55], keyhold16[33], keyhold16[52],
					  keyhold16[45], keyhold16[41], keyhold16[49], keyhold16[35], keyhold16[28], keyhold16[31]};
		end
	
	default : begin
	
		inK1 = outK1;
		inK2 = outK2;
		inK3 = outK3;
		inK4 = outK4;
		inK5 = outK5;
		inK6 = outK6;
		inK7 = outK7;
		inK8 = outK8;
		inK9 = outK9;
		inK10 = outK10;
		inK11 = outK11;
		inK12 = outK12;
		inK13 = outK13;
		inK14 = outK14;
		inK15 = outK15;
		inK16 = outK16;
	end
	
	endcase
end

endmodule


module encryptionExecute(clk, rst, timingEncryptStart, timingEncryptDone, R0, L0, initKey, encryptedOutput, loopcounter);
// IO -------------------------------------------------------
input clk, rst, timingEncryptStart;
input[31:0] R0, L0;
input[63:0] initKey;
output[63:0] encryptedOutput;
output timingEncryptDone;
reg timingEncryptDone;

output[8:0] loopcounter;
assign loopcounter = loopcounterout; 

// Local use ------------------------------------------------
reg[5:0] S, NS;
reg[47:0] Rold48;
reg[47:0] Rold48Knew;

reg[8:0] loopcounterin;
wire[8:0] loopcounterout;
ram64 loopcount(clk, rst, {56'd0, loopcounterin}, 1'b1, loopcounterout);

assign encryptedOutput = finalpermout;

reg[63:0] finalpermin;
wire[63:0] finalpermout;
ram64 finalperm(clk, rst, finalpermin, 1'b1, finalpermout);

reg[63:0] lrflipin;
wire[63:0] lrflipout;
ram64 lrflip(clk, rst, lrflipin, 1'b1, lrflipout);

reg[31:0] roldin;
wire[31:0] roldout;
ram64 Rold(clk, rst, {32'd0, roldin}, 1'b1, roldout);
reg[31:0] loldin;
wire[31:0] loldout;
ram64 Lold(clk, rst, {32'd0, loldin}, 1'b1, loldout);
reg[31:0] rnewin;
wire[31:0] rnewout;
ram64 Rnew(clk, rst, {32'd0, rnewin}, 1'b1, rnewout);
reg[31:0] lnewin;
wire[31:0] lnewout;
ram64 Lnew(clk, rst, {32'd0, lnewin}, 1'b1, lnewout);

reg[47:0] rold48in;
wire[47:0] rold48out;
ram64 rold48(clk, rst, {16'd0, rold48out}, 1'b1, rold48out);

reg[47:0] rold48knewin;
wire[47:0] rold48knewout;
ram64 rold48knew(clk, rst, {16'd0, rold48knewin}, 1'b1, rold48knewout);

reg[31:0] sboxlookin;
wire[31:0] sboxlookout;
ram64 sboxlook(clk, rst, {32'd0, sboxlookin}, 1'b1, sboxlookout);

reg[31:0] permpin;
wire[31:0] permpout;
ram64 permpram(clk, rst, {32'd0, permpin}, 1'b1, permpout);

// sbox access ----------------------------------------------
wire[5:0] s1in, s2in, s3in, s4in, s5in, s6in, s7in, s8in;
wire[3:0] s1out, s2out, s3out, s4out, s5out, s6out, s7out, s8out;

sBox1 box1(s1in, s1out);
sBox2 box2(s2in, s2out);
sBox3 box3(s3in, s3out);
sBox4 box4(s4in, s4out);
sBox5 box5(s5in, s5out);
sBox6 box6(s6in, s6out);
sBox7 box7(s7in, s7out);
sBox8 box8(s8in, s8out);



// key registers and module ----------------------------------
reg keyTimingStart;
wire keyTimingDone;
wire[47:0] K1, K2, K3, K4, K5, K6, K7, K8, K9, K10, K11, K12, K13, K14, K15, K16;
keyGen key(keyTimingStart, keyTimingDone, clk, rst, initKey, K1, K2, K3, K4, K5, K6, K7, K8, K9, K10, K11, K12, K13, K14, K15, K16);

parameter start = 4'd0;
parameter genkeys = 4'd1;
parameter setLnew = 4'd2;
parameter expandR0 = 4'd3;
parameter exclusiveor = 4'd4;
parameter sboxlookup = 4'd5;
parameter permp = 4'd6;
parameter L0exclusive = 4'd7;
parameter checkloopcounter = 4'd8;
parameter finish = 4'd9;
parameter keyupdate = 4'd10;
parameter flipLR = 4'd11;


assign s8in = rold48knewout[5:0];
assign s7in = rold48knewout[11:6];
assign s6in = rold48knewout[17:12];
assign s5in = rold48knewout[23:18];
assign s4in = rold48knewout[29:24];
assign s3in = rold48knewout[35:30];
assign s2in = rold48knewout[41:36];
assign s1in = rold48knewout[47:42];

always @ (posedge clk or negedge rst)
begin
	if(rst == 1'b0)
	begin
		S <= start;
	end
	else 
	begin
		S <= NS;
	end
end

always @ (posedge clk or negedge rst)
begin
	case(S)
	
	start : begin
		if(timingEncryptStart == 1'b1)
		begin
			NS = genkeys;
		end
		else
		begin
			NS = start;
		end
	end
	
	genkeys : begin
		if(keyTimingDone == 1'b1)
		begin
			NS = setLnew;
		end
		else
		begin
			NS = genkeys;
		end
	end
	
	setLnew : NS = expandR0;
	
	expandR0 : NS = exclusiveor;
	
	exclusiveor : NS = sboxlookup;
	
	sboxlookup : NS = permp;
	
	permp : NS = L0exclusive;
	
	L0exclusive : NS = checkloopcounter;
	
	checkloopcounter : begin
		if(loopcounterout > 64'd16)
		begin
			NS = flipLR;
		end
		else
		begin
			NS = keyupdate;
		end
	end
	
	keyupdate : NS = expandR0;
	
	flipLR: NS = finish;
	
	finish : NS = finish;

	endcase
end

// handle key timing start
always @ (posedge clk or negedge rst)
begin
	case(S)
		genkeys : keyTimingStart <= 1'b1;
		default : keyTimingStart <=1'b0;
	endcase
end


// handle counter
always @ (posedge clk or negedge rst)
begin
	case(S)
		start : loopcounterin <= 8'd1;
		
		keyupdate : loopcounterin <= loopcounterout[7:0] + 8'd1;
		
		default : loopcounterin <= loopcounterout;
	
	endcase
end

// handle setting timing output
always @ (posedge clk or negedge rst)
begin
	case(S)
		finish : timingEncryptDone = 1'b1;
		default : timingEncryptDone = 1'b0;
	endcase
end

// always to handle loldin
always @ (posedge clk or negedge rst)
begin
	case(S)
		start : loldin <= L0;
		keyupdate : loldin <= lnewout;
		default : loldin <= loldout;
	endcase
end

// always to handle roldin
always @ (posedge clk or negedge rst)
begin
	case(S)
		start : roldin <= R0;
		keyupdate : roldin <= roldout;
		default : roldin <= roldout;
	endcase
end

// always to handle lnewin
always @ (posedge clk or negedge rst)
begin
	case(S)
		start : lnewin <= 32'd0;
		
		setLnew : lnewin <= roldout;
		
		default : lnewin <= lnewout;
	endcase
end

// always to handle renewin

always @ (posedge clk or negedge rst)
begin
	case(S)
		start : rnewin <= 32'd0;
		
		L0exclusive : rnewin <= loldout[31:0] ^ permpout;
	
		default : rnewin <= rnewout[31:0];


	endcase
end

// always to handle expanded rold

always @ (posedge clk or negedge rst)
begin
	case(S)
		start : rold48in = 48'd0;
		
		expandR0 : rold48in <= {roldout[31], roldout[0],  roldout[1],  roldout[2],  roldout[3],  roldout[4],
									roldout[3],  roldout[4],  roldout[5],  roldout[6],  roldout[7],  roldout[8],
									roldout[7],  roldout[8],  roldout[9], roldout[10], roldout[11], roldout[12],
									roldout[11], roldout[12], roldout[13], roldout[14], roldout[15], roldout[16],
									roldout[15], roldout[16], roldout[17], roldout[18], roldout[19], roldout[20],
									roldout[19], roldout[20], roldout[21], roldout[22], roldout[23], roldout[24],
									roldout[23], roldout[24], roldout[25], roldout[26], roldout[27], roldout[28],
									roldout[27], roldout[28], roldout[29], roldout[30], roldout[31], roldout[0]};
		
		default : rold48in <= rold48out;

	endcase
end

// handle first xor operation
always @ (posedge clk or negedge rst)
begin
	case(S)
		
		start : rold48knewin <= 48'd0;
		
		L0exclusive : begin
			case(loopcounterout[7:0])
				32'd1 : rold48knewin <= rold48out ^ K1;
				32'd2 : rold48knewin <= rold48out ^ K2;
				32'd3 : rold48knewin <= rold48out ^ K3;
				32'd4 : rold48knewin <= rold48out ^ K4;
				32'd5 : rold48knewin <= rold48out ^ K5;
				32'd6 : rold48knewin <= rold48out ^ K6;
				32'd7 : rold48knewin <= rold48out ^ K7;
				32'd8 : rold48knewin <= rold48out ^ K8;
				32'd9 : rold48knewin <= rold48out ^ K9;
				32'd10 : rold48knewin <= rold48out ^ K10;
				32'd11 : rold48knewin <= rold48out ^ K11;
				32'd12 : rold48knewin <= rold48out ^ K12;
				32'd13 : rold48knewin <= rold48out ^ K13;
				32'd14 : rold48knewin <= rold48out ^ K14;
				32'd15 : rold48knewin <= rold48out ^ K15;
				32'd16 : rold48knewin <= rold48out ^ K16;
				
				default : rold48knewin <= rold48out ^ 48'd0;
			endcase
		end
	
	default : rold48knewin <= rold48knewout;
	
	endcase
end


// handle sbox use
always @ (posedge clk or negedge rst)
begin
	case(S)
		start : sboxlookin <= 32'd0;
		sboxlookup : sboxlookin <= {s1out, s2out, s3out, s4out, s5out, s6out, s7out, s8out};
		default : sboxlookin <= sboxlookout;
		
	endcase
end

// handle second permutation
always @ (posedge clk or negedge rst)
begin
	case(S)
		start : permpin <= 32'd0;
		
		permp : permpin <= {sboxlookout[15], sboxlookout[6], sboxlookout[19], sboxlookout[20], 
									sboxlookout[28], sboxlookout[11], sboxlookout[27], sboxlookout[16],
									sboxlookout[0], sboxlookout[14], sboxlookout[22], sboxlookout[25],
									sboxlookout[4], sboxlookout[17], sboxlookout[30], sboxlookout[9],
									sboxlookout[1], sboxlookout[7], sboxlookout[23], sboxlookout[13],
									sboxlookout[31], sboxlookout[26], sboxlookout[2], sboxlookout[8],
									sboxlookout[18], sboxlookout[12], sboxlookout[29], sboxlookout[5],
									sboxlookout[21], sboxlookout[10], sboxlookout[3], sboxlookout[24]};
		default : permpin <= permpout;
		
	endcase
end

// always to handle LR flip
always @ (posedge clk or negedge rst)
begin
	case(S)
		start : lrflipin <= 64'd0;
		
		flipLR : lrflipin <= {rnewout, lnewout};
		
		default : lrflipin <= lrflipout;
	
	endcase
end

// always to handle final permutation
always @ (posedge clk or negedge rst)
begin
	case(S)
		start : finalpermin <= 64'hacacacacacacacac;
																	
		finish : finalpermin <= {lrflipout[39], lrflipout[7], lrflipout[47], lrflipout[15], lrflipout[55], lrflipout[23], lrflipout[63], lrflipout[31], 
									lrflipout[38], lrflipout[6], lrflipout[46], lrflipout[14], lrflipout[54], lrflipout[22], lrflipout[62], lrflipout[30], 
									lrflipout[37], lrflipout[5], lrflipout[45], lrflipout[13], lrflipout[53], lrflipout[21], lrflipout[61], lrflipout[29], 
									lrflipout[36], lrflipout[4], lrflipout[44], lrflipout[12], lrflipout[52], lrflipout[20], lrflipout[60], lrflipout[28], 
									lrflipout[35], lrflipout[3], lrflipout[43], lrflipout[11], lrflipout[51], lrflipout[19], lrflipout[59], lrflipout[27], 
									lrflipout[34], lrflipout[2], lrflipout[42], lrflipout[10], lrflipout[50], lrflipout[18], lrflipout[58], lrflipout[26], 
									lrflipout[33], lrflipout[1], lrflipout[41], lrflipout[9], lrflipout[49], lrflipout[17], lrflipout[57], lrflipout[25], 
									lrflipout[32], lrflipout[0], lrflipout[40], lrflipout[8], lrflipout[48], lrflipout[16], lrflipout[56], lrflipout[24]};
		
		default : finalpermin <= finalpermout;
	
	endcase
end


endmodule

//----------------------------------------------------
// RAM module

module ram64(clk, rst, in, wen, o);
input clk, rst, wen;
input[63:0] in;
output[63:0] o;

reg[63:0] ff;

assign o = ff;

always@(posedge clk or negedge rst)
begin
	if(rst == 1'b0)
	begin
		ff <= 64'd0;
	end
	else if(wen == 1'b1)
		begin
				ff <= in;
		end
end

endmodule

module ram4(clk, rst, in, wen, o);
input clk, rst, wen;
input[3:0] in;
output[3:0] o;

reg[3:0] ff;

assign o = ff;

always@(posedge clk or negedge rst)
begin
	if(rst == 1'b0)
	begin
		ff <= 4'd0;
	end
	else if(wen == 1'b1)
		begin
				ff <= in;
		end
end

endmodule

//--------------------------------------------------------------------
// Module to return necessary display values for given input
//--------------------------------------------------------------------
module display(number, a, b, c, d, e, f, g);
input [3:0] number;
output a, b, c, d, e, f, g;
reg a, b, c, d, e, f, g;

always @ (*)
begin

	case(number)
		4'b0000 : begin
				a = 1'b0;
				b = 1'b0;
				c = 1'b0;
				d = 1'b0;
				e = 1'b0;
				f = 1'b0;
				g = 1'b1;
			end
		4'b0001 : begin
				a = 1'b1;
				b = 1'b0;
				c = 1'b0;
				d = 1'b1;
				e = 1'b1;
				f = 1'b1;
				g = 1'b1;
			end
		4'b0010 : begin
				a = 1'b0;
				b = 1'b0;
				c = 1'b1;
				d = 1'b0;
				e = 1'b0;
				f = 1'b1;
				g = 1'b0;
			end
		4'b0011 : begin
				a = 1'b0;
				b = 1'b0;
				c = 1'b0;
				d = 1'b0;
				e = 1'b1;
				f = 1'b1;
				g = 1'b0;
			end
		4'b0100 : begin
				a = 1'b1;
				b = 1'b0;
				c = 1'b0;
				d = 1'b1;
				e = 1'b1;
				f = 1'b0;
				g = 1'b0;
			end
		4'b0101 : begin
				a = 1'b0;
				b = 1'b1;
				c = 1'b0;
				d = 1'b0;
				e = 1'b1;
				f = 1'b0;
				g = 1'b0;
			end
		4'b0110 : begin
				a = 1'b0;
				b = 1'b1;
				c = 1'b0;
				d = 1'b0;
				e = 1'b0;
				f = 1'b0;
				g = 1'b0;
			end
		4'b0111 : begin
				a = 1'b0;
				b = 1'b0;
				c = 1'b0;
				d = 1'b1;
				e = 1'b1;
				f = 1'b1;
				g = 1'b1;
			end
		4'b1000 : begin
				a = 1'b0;
				b = 1'b0;
				c = 1'b0;
				d = 1'b0;
				e = 1'b0;
				f = 1'b0;
				g = 1'b0;
			end
		4'b1001 : begin
				a = 1'b0;
				b = 1'b0;
				c = 1'b0;
				d = 1'b0;
				e = 1'b1;
				f = 1'b0;
				g = 1'b0;
			end
		4'b1010 : begin
				a = 1'b0;
				b = 1'b0;
				c = 1'b0;
				d = 1'b1;
				e = 1'b0;
				f = 1'b0;
				g = 1'b0;
			end
		4'b1011 : begin
				a = 1'b1;
				b = 1'b1;
				c = 1'b0;
				d = 1'b0;
				e = 1'b0;
				f = 1'b0;
				g = 1'b0;
			end
		4'b1100 : begin
				a = 1'b1;
				b = 1'b1;
				c = 1'b1;
				d = 1'b0;
				e = 1'b0;
				f = 1'b1;
				g = 1'b0;
			end
		4'b1101 : begin
				a = 1'b1;
				b = 1'b0;
				c = 1'b0;
				d = 1'b0;
				e = 1'b0;
				f = 1'b1;
				g = 1'b0;
			end
		4'b1110 : begin
				a = 1'b0;
				b = 1'b1;
				c = 1'b1;
				d = 1'b0;
				e = 1'b0;
				f = 1'b0;
				g = 1'b0;
			end
		4'b1111 : begin
				a = 1'b0;
				b = 1'b1;
				c = 1'b1;
				d = 1'b1;
				e = 1'b0;
				f = 1'b0;
				g = 1'b0;
			end
		endcase
	end
endmodule

//--------------------------------------------------------------------
// The following 8 modules serve as repositories for the s-box lookups
//--------------------------------------------------------------------
module sBox1(inval, outval);
input[5:0] inval;
output[3:0] outval;
reg[3:0] outval;

reg[3:0] xComp;
reg[1:0] yComp;

always @ (*)
begin
	xComp = inval[4:1];
	yComp = {inval[5],inval[0]};
	
	case(yComp)
		2'b00 : begin
			// sbox1 top line: 14  4  13  1   2 15  11  8   3 10   6 12   5  9   0  7
			case(xComp)
				4'b0000 : outval = 4'd14;
				4'b0001 : outval = 4'd4;
				4'b0010 : outval = 4'd13;
				4'b0011 : outval = 4'd1;
				4'b0100 : outval = 4'd2;
				4'b0101 : outval = 4'd15;
				4'b0110 : outval = 4'd11;
				4'b0111 : outval = 4'd8;
				4'b1000 : outval = 4'd3;
				4'b1001 : outval = 4'd10;
				4'b1010 : outval = 4'd6;
				4'b1011 : outval = 4'd12;
				4'b1100 : outval = 4'd5;
				4'b1101 : outval = 4'd9;
				4'b1110 : outval = 4'd0;
				4'b1111 : outval = 4'd7;
			endcase
		end
		2'b01 : begin
			// sbox1 top line: 0 15   7  4  14  2  13  1  10  6  12 11   9  5   3  8
			case(xComp)
				4'b0000 : outval = 4'd0;
				4'b0001 : outval = 4'd15;
				4'b0010 : outval = 4'd7;
				4'b0011 : outval = 4'd4;
				4'b0100 : outval = 4'd14;
				4'b0101 : outval = 4'd2;
				4'b0110 : outval = 4'd13;
				4'b0111 : outval = 4'd1;
				4'b1000 : outval = 4'd10;
				4'b1001 : outval = 4'd6;
				4'b1010 : outval = 4'd12;
				4'b1011 : outval = 4'd11;
				4'b1100 : outval = 4'd9;
				4'b1101 : outval = 4'd5;
				4'b1110 : outval = 4'd3;
				4'b1111 : outval = 4'd8;
			endcase
		end

		2'b10 : begin
			// sbox1 top line: 4  1  14  8  13  6   2 11  15 12   9  7   3 10   5  0
			case(xComp)
				4'b0000 : outval = 4'd4;
				4'b0001 : outval = 4'd1;
				4'b0010 : outval = 4'd14;
				4'b0011 : outval = 4'd8;
				4'b0100 : outval = 4'd13;
				4'b0101 : outval = 4'd6;
				4'b0110 : outval = 4'd2;
				4'b0111 : outval = 4'd11;
				4'b1000 : outval = 4'd15;
				4'b1001 : outval = 4'd12;
				4'b1010 : outval = 4'd9;
				4'b1011 : outval = 4'd7;
				4'b1100 : outval = 4'd3;
				4'b1101 : outval = 4'd10;
				4'b1110 : outval = 4'd5;
				4'b1111 : outval = 4'd0;
			endcase
		end
	   2'b11 : begin
			// sbox1 top line: 15 12   8  2   4  9   1  7   5 11   3 14  10  0   6 13
			case(xComp)
				4'b0000 : outval = 4'd15;
				4'b0001 : outval = 4'd12;
				4'b0010 : outval = 4'd8;
				4'b0011 : outval = 4'd2;
				4'b0100 : outval = 4'd4;
				4'b0101 : outval = 4'd9;
				4'b0110 : outval = 4'd1;
				4'b0111 : outval = 4'd7;
				4'b1000 : outval = 4'd5;
				4'b1001 : outval = 4'd11;
				4'b1010 : outval = 4'd3;
				4'b1011 : outval = 4'd14;
				4'b1100 : outval = 4'd10;
				4'b1101 : outval = 4'd0;
				4'b1110 : outval = 4'd6;
				4'b1111 : outval = 4'd13;
			endcase
		end
		
	endcase
end 

endmodule

module sBox2(inval, outval);
input[5:0] inval;
output[3:0] outval;
reg[3:0] outval;

reg[3:0] xComp;
reg[1:0] yComp;

always @ (*)
begin
	xComp = inval[4:1];
	yComp = {inval[5],inval[0]};
	
	case(yComp)
		2'b00 : begin
			// sbox2 top line: 15  1   8 14   6 11   3  4   9  7   2 13  12  0   5 10
			case(xComp)
				4'b0000 : outval = 4'd15;
				4'b0001 : outval = 4'd1;
				4'b0010 : outval = 4'd8;
				4'b0011 : outval = 4'd14;
				4'b0100 : outval = 4'd6;
				4'b0101 : outval = 4'd11;
				4'b0110 : outval = 4'd3;
				4'b0111 : outval = 4'd4;
				4'b1000 : outval = 4'd9;
				4'b1001 : outval = 4'd7;
				4'b1010 : outval = 4'd2;
				4'b1011 : outval = 4'd13;
				4'b1100 : outval = 4'd12;
				4'b1101 : outval = 4'd0;
				4'b1110 : outval = 4'd5;
				4'b1111 : outval = 4'd10;
			endcase
		end
		2'b01 : begin
			// sbox2 2 line: 3 13   4  7  15  2   8 14  12  0   1 10   6  9  11  5
			case(xComp)
				4'b0000 : outval = 4'd3;
				4'b0001 : outval = 4'd13;
				4'b0010 : outval = 4'd4;
				4'b0011 : outval = 4'd7;
				4'b0100 : outval = 4'd15;
				4'b0101 : outval = 4'd2;
				4'b0110 : outval = 4'd8;
				4'b0111 : outval = 4'd14;
				4'b1000 : outval = 4'd12;
				4'b1001 : outval = 4'd0;
				4'b1010 : outval = 4'd1;
				4'b1011 : outval = 4'd10;
				4'b1100 : outval = 4'd6;
				4'b1101 : outval = 4'd9;
				4'b1110 : outval = 4'd11;
				4'b1111 : outval = 4'd5;
			endcase
		end
		2'b10 : begin
			// sbox2 3 line: 0 14   7 11  10  4  13  1   5  8  12  6   9  3   2 15
			case(xComp)
				4'b0000 : outval = 4'd0;
				4'b0001 : outval = 4'd14;
				4'b0010 : outval = 4'd7;
				4'b0011 : outval = 4'd11;
				4'b0100 : outval = 4'd10;
				4'b0101 : outval = 4'd4;
				4'b0110 : outval = 4'd13;
				4'b0111 : outval = 4'd1;
				4'b1000 : outval = 4'd5;
				4'b1001 : outval = 4'd8;
				4'b1010 : outval = 4'd12;
				4'b1011 : outval = 4'd6;
				4'b1100 : outval = 4'd9;
				4'b1101 : outval = 4'd3;
				4'b1110 : outval = 4'd2;
				4'b1111 : outval = 4'd15;
			endcase
		end
	   2'b11 : begin
			// sbox2 4 line:  13  8  10  1   3 15   4  2  11  6   7 12   0  5  14  9

			case(xComp)
				4'b0000 : outval = 4'd13;
				4'b0001 : outval = 4'd8;
				4'b0010 : outval = 4'd10;
				4'b0011 : outval = 4'd1;
				4'b0100 : outval = 4'd3;
				4'b0101 : outval = 4'd15;
				4'b0110 : outval = 4'd4;
				4'b0111 : outval = 4'd2;
				4'b1000 : outval = 4'd11;
				4'b1001 : outval = 4'd6;
				4'b1010 : outval = 4'd7;
				4'b1011 : outval = 4'd12;
				4'b1100 : outval = 4'd0;
				4'b1101 : outval = 4'd5;
				4'b1110 : outval = 4'd14;
				4'b1111 : outval = 4'd9;
			endcase
		end
		
	endcase
end 

endmodule


module sBox3(inval, outval);
input[5:0] inval;
output[3:0] outval;
reg[3:0] outval;

reg[3:0] xComp;
reg[1:0] yComp;

always @ (*)
begin
	xComp = inval[4:1];
	yComp = {inval[5],inval[0]};
	
	case(yComp)
		2'b00 : begin
			// sbox3 top line: 10  0   9 14   6  3  15  5   1 13  12  7  11  4   2  8
			case(xComp)
				4'b0000 : outval = 4'd10;
				4'b0001 : outval = 4'd0;
				4'b0010 : outval = 4'd9;
				4'b0011 : outval = 4'd14;
				4'b0100 : outval = 4'd6;
				4'b0101 : outval = 4'd3;
				4'b0110 : outval = 4'd15;
				4'b0111 : outval = 4'd5;
				4'b1000 : outval = 4'd1;
				4'b1001 : outval = 4'd13;
				4'b1010 : outval = 4'd12;
				4'b1011 : outval = 4'd7;
				4'b1100 : outval = 4'd11;
				4'b1101 : outval = 4'd4;
				4'b1110 : outval = 4'd2;
				4'b1111 : outval = 4'd8;
			endcase
		end
		2'b01 : begin
			// sbox3 2 line: 13  7   0  9   3  4   6 10   2  8   5 14  12 11  15  1
			case(xComp)
				4'b0000 : outval = 4'd13;
				4'b0001 : outval = 4'd7;
				4'b0010 : outval = 4'd0;
				4'b0011 : outval = 4'd9;
				4'b0100 : outval = 4'd3;
				4'b0101 : outval = 4'd4;
				4'b0110 : outval = 4'd6;
				4'b0111 : outval = 4'd10;
				4'b1000 : outval = 4'd2;
				4'b1001 : outval = 4'd8;
				4'b1010 : outval = 4'd5;
				4'b1011 : outval = 4'd14;
				4'b1100 : outval = 4'd12;
				4'b1101 : outval = 4'd11;
				4'b1110 : outval = 4'd15;
				4'b1111 : outval = 4'd1;
			endcase
		end
		2'b10 : begin
			// sbox3 3 line:  13  6   4  9   8 15   3  0  11  1   2 12   5 10  14  7
			case(xComp)
				4'b0000 : outval = 4'd13;
				4'b0001 : outval = 4'd6;
				4'b0010 : outval = 4'd4;
				4'b0011 : outval = 4'd9;
				4'b0100 : outval = 4'd8;
				4'b0101 : outval = 4'd15;
				4'b0110 : outval = 4'd3;
				4'b0111 : outval = 4'd0;
				4'b1000 : outval = 4'd11;
				4'b1001 : outval = 4'd1;
				4'b1010 : outval = 4'd2;
				4'b1011 : outval = 4'd12;
				4'b1100 : outval = 4'd5;
				4'b1101 : outval = 4'd10;
				4'b1110 : outval = 4'd14;
				4'b1111 : outval = 4'd7;
			endcase
		end
	   2'b11 : begin
			// sbox3 4 line:   1 10  13  0   6  9   8  7   4 15  14  3  11  5   2 12
			case(xComp)
				4'b0000 : outval = 4'd1;
				4'b0001 : outval = 4'd10;
				4'b0010 : outval = 4'd13;
				4'b0011 : outval = 4'd0;
				4'b0100 : outval = 4'd6;
				4'b0101 : outval = 4'd9;
				4'b0110 : outval = 4'd8;
				4'b0111 : outval = 4'd7;
				4'b1000 : outval = 4'd4;
				4'b1001 : outval = 4'd15;
				4'b1010 : outval = 4'd14;
				4'b1011 : outval = 4'd3;
				4'b1100 : outval = 4'd11;
				4'b1101 : outval = 4'd5;
				4'b1110 : outval = 4'd2;
				4'b1111 : outval = 4'd12;
			endcase
		end
		
	endcase
end 

endmodule


module sBox4(inval, outval);
input[5:0] inval;
output[3:0] outval;
reg[3:0] outval;

reg[3:0] xComp;
reg[1:0] yComp;

always @ (*)
begin
	xComp = inval[4:1];
	yComp = {inval[5],inval[0]};
	
	case(yComp)
		2'b00 : begin
			// sbox4 top line:  7 13  14  3   0  6   9 10   1  2   8  5  11 12   4 15
			case(xComp)
				4'b0000 : outval = 4'd7;
				4'b0001 : outval = 4'd13;
				4'b0010 : outval = 4'd14;
				4'b0011 : outval = 4'd3;
				4'b0100 : outval = 4'd0;
				4'b0101 : outval = 4'd6;
				4'b0110 : outval = 4'd9;
				4'b0111 : outval = 4'd10;
				4'b1000 : outval = 4'd1;
				4'b1001 : outval = 4'd2;
				4'b1010 : outval = 4'd8;
				4'b1011 : outval = 4'd5;
				4'b1100 : outval = 4'd11;
				4'b1101 : outval = 4'd12;
				4'b1110 : outval = 4'd4;
				4'b1111 : outval = 4'd15;
			endcase
		end
		2'b01 : begin
			// sbox4 2 line: 13  8  11  5   6 15   0  3   4  7   2 12   1 10  14  9
			case(xComp)
				4'b0000 : outval = 4'd13;
				4'b0001 : outval = 4'd8;
				4'b0010 : outval = 4'd11;
				4'b0011 : outval = 4'd5;
				4'b0100 : outval = 4'd6;
				4'b0101 : outval = 4'd15;
				4'b0110 : outval = 4'd0;
				4'b0111 : outval = 4'd3;
				4'b1000 : outval = 4'd4;
				4'b1001 : outval = 4'd7;
				4'b1010 : outval = 4'd2;
				4'b1011 : outval = 4'd12;
				4'b1100 : outval = 4'd1;
				4'b1101 : outval = 4'd10;
				4'b1110 : outval = 4'd14;
				4'b1111 : outval = 4'd9;
			endcase
		end
		2'b10 : begin
			// sbox4 3 line: 10  6   9  0  12 11   7 13  15  1   3 14   5  2   8  4
			case(xComp)
				4'b0000 : outval = 4'd10;
				4'b0001 : outval = 4'd6;
				4'b0010 : outval = 4'd9;
				4'b0011 : outval = 4'd0;
				4'b0100 : outval = 4'd12;
				4'b0101 : outval = 4'd11;
				4'b0110 : outval = 4'd7;
				4'b0111 : outval = 4'd13;
				4'b1000 : outval = 4'd15;
				4'b1001 : outval = 4'd1;
				4'b1010 : outval = 4'd3;
				4'b1011 : outval = 4'd14;
				4'b1100 : outval = 4'd5;
				4'b1101 : outval = 4'd2;
				4'b1110 : outval = 4'd8;
				4'b1111 : outval = 4'd4;
			endcase
		end
	   2'b11 : begin
			// sbox4 4 line:  3 15   0  6  10  1  13  8   9  4   5 11  12  7   2 14
			case(xComp)
				4'b0000 : outval = 4'd3;
				4'b0001 : outval = 4'd15;
				4'b0010 : outval = 4'd0;
				4'b0011 : outval = 4'd6;
				4'b0100 : outval = 4'd10;
				4'b0101 : outval = 4'd1;
				4'b0110 : outval = 4'd13;
				4'b0111 : outval = 4'd8;
				4'b1000 : outval = 4'd9;
				4'b1001 : outval = 4'd4;
				4'b1010 : outval = 4'd5;
				4'b1011 : outval = 4'd11;
				4'b1100 : outval = 4'd12;
				4'b1101 : outval = 4'd7;
				4'b1110 : outval = 4'd2;
				4'b1111 : outval = 4'd14;
			endcase
		end
		
	endcase
end 

endmodule


module sBox5(inval, outval);
input[5:0] inval;
output[3:0] outval;
reg[3:0] outval;

reg[3:0] xComp;
reg[1:0] yComp;

always @ (*)
begin
	xComp = inval[4:1];
	yComp = {inval[5],inval[0]};
	
	case(yComp)
		2'b00 : begin
			// sbox5 top line:  2 12   4  1   7 10  11  6   8  5   3 15  13  0  14  9
			case(xComp)
				4'b0000 : outval = 4'd2;
				4'b0001 : outval = 4'd12;
				4'b0010 : outval = 4'd4;
				4'b0011 : outval = 4'd1;
				4'b0100 : outval = 4'd7;
				4'b0101 : outval = 4'd10;
				4'b0110 : outval = 4'd11;
				4'b0111 : outval = 4'd6;
				4'b1000 : outval = 4'd8;
				4'b1001 : outval = 4'd5;
				4'b1010 : outval = 4'd3;
				4'b1011 : outval = 4'd15;
				4'b1100 : outval = 4'd13;
				4'b1101 : outval = 4'd0;
				4'b1110 : outval = 4'd14;
				4'b1111 : outval = 4'd9;
			endcase
		end
		2'b01 : begin
			// sbox5 2 line: 14 11   2 12   4  7  13  1   5  0  15 10   3  9   8  6
			case(xComp)
				4'b0000 : outval = 4'd14;
				4'b0001 : outval = 4'd11;
				4'b0010 : outval = 4'd2;
				4'b0011 : outval = 4'd12;
				4'b0100 : outval = 4'd4;
				4'b0101 : outval = 4'd7;
				4'b0110 : outval = 4'd13;
				4'b0111 : outval = 4'd1;
				4'b1000 : outval = 4'd5;
				4'b1001 : outval = 4'd0;
				4'b1010 : outval = 4'd15;
				4'b1011 : outval = 4'd10;
				4'b1100 : outval = 4'd3;
				4'b1101 : outval = 4'd9;
				4'b1110 : outval = 4'd8;
				4'b1111 : outval = 4'd6;
			endcase
		end
		2'b10 : begin
			// sbox5 3 line:   4  2   1 11  10 13   7  8  15  9  12  5   6  3   0 14
			case(xComp)
				4'b0000 : outval = 4'd4;
				4'b0001 : outval = 4'd2;
				4'b0010 : outval = 4'd1;
				4'b0011 : outval = 4'd11;
				4'b0100 : outval = 4'd10;
				4'b0101 : outval = 4'd13;
				4'b0110 : outval = 4'd7;
				4'b0111 : outval = 4'd8;
				4'b1000 : outval = 4'd15;
				4'b1001 : outval = 4'd9;
				4'b1010 : outval = 4'd12;
				4'b1011 : outval = 4'd5;
				4'b1100 : outval = 4'd6;
				4'b1101 : outval = 4'd3;
				4'b1110 : outval = 4'd0;
				4'b1111 : outval = 4'd14;
			endcase
		end
	   2'b11 : begin
			// sbox5 4 line:  11  8  12  7   1 14   2 13   6 15   0  9  10  4   5  3
			case(xComp)
				4'b0000 : outval = 4'd11;
				4'b0001 : outval = 4'd8;
				4'b0010 : outval = 4'd12;
				4'b0011 : outval = 4'd7;
				4'b0100 : outval = 4'd1;
				4'b0101 : outval = 4'd14;
				4'b0110 : outval = 4'd2;
				4'b0111 : outval = 4'd13;
				4'b1000 : outval = 4'd6;
				4'b1001 : outval = 4'd15;
				4'b1010 : outval = 4'd0;
				4'b1011 : outval = 4'd9;
				4'b1100 : outval = 4'd10;
				4'b1101 : outval = 4'd4;
				4'b1110 : outval = 4'd5;
				4'b1111 : outval = 4'd3;
			endcase
		end
		
	endcase
end 

endmodule


module sBox6(inval, outval);
input[5:0] inval;
output[3:0] outval;
reg[3:0] outval;

reg[3:0] xComp;
reg[1:0] yComp;

always @ (*)
begin
	xComp = inval[4:1];
	yComp = {inval[5],inval[0]};
	
	case(yComp)
		2'b00 : begin
			// sbox6 top line: 12  1  10 15   9  2   6  8   0 13   3  4  14  7   5 11
			case(xComp)
				4'b0000 : outval = 4'd12;
				4'b0001 : outval = 4'd1;
				4'b0010 : outval = 4'd10;
				4'b0011 : outval = 4'd15;
				4'b0100 : outval = 4'd9;
				4'b0101 : outval = 4'd2;
				4'b0110 : outval = 4'd6;
				4'b0111 : outval = 4'd8;
				4'b1000 : outval = 4'd0;
				4'b1001 : outval = 4'd13;
				4'b1010 : outval = 4'd3;
				4'b1011 : outval = 4'd4;
				4'b1100 : outval = 4'd14;
				4'b1101 : outval = 4'd7;
				4'b1110 : outval = 4'd5;
				4'b1111 : outval = 4'd11;
			endcase
		end
		2'b01 : begin
			// sbox6 2 line:  10 15   4  2   7 12   9  5   6  1  13 14   0 11   3  8
			case(xComp)
				4'b0000 : outval = 4'd10;
				4'b0001 : outval = 4'd15;
				4'b0010 : outval = 4'd4;
				4'b0011 : outval = 4'd2;
				4'b0100 : outval = 4'd7;
				4'b0101 : outval = 4'd12;
				4'b0110 : outval = 4'd9;
				4'b0111 : outval = 4'd5;
				4'b1000 : outval = 4'd6;
				4'b1001 : outval = 4'd1;
				4'b1010 : outval = 4'd13;
				4'b1011 : outval = 4'd14;
				4'b1100 : outval = 4'd0;
				4'b1101 : outval = 4'd11;
				4'b1110 : outval = 4'd3;
				4'b1111 : outval = 4'd8;
			endcase
		end
		2'b10 : begin
			// sbox6 3 line:  9 14  15  5   2  8  12  3   7  0   4 10   1 13  11  6
			case(xComp)
				4'b0000 : outval = 4'd9;
				4'b0001 : outval = 4'd14;
				4'b0010 : outval = 4'd15;
				4'b0011 : outval = 4'd5;
				4'b0100 : outval = 4'd2;
				4'b0101 : outval = 4'd8;
				4'b0110 : outval = 4'd12;
				4'b0111 : outval = 4'd3;
				4'b1000 : outval = 4'd7;
				4'b1001 : outval = 4'd0;
				4'b1010 : outval = 4'd4;
				4'b1011 : outval = 4'd10;
				4'b1100 : outval = 4'd1;
				4'b1101 : outval = 4'd13;
				4'b1110 : outval = 4'd11;
				4'b1111 : outval = 4'd6;
			endcase
		end
	   2'b11 : begin
			// sbox6 4 line:  4  3   2 12   9  5  15 10  11 14   1  7   6  0   8 13
			case(xComp)
				4'b0000 : outval = 4'd4;
				4'b0001 : outval = 4'd3;
				4'b0010 : outval = 4'd2;
				4'b0011 : outval = 4'd12;
				4'b0100 : outval = 4'd9;
				4'b0101 : outval = 4'd5;
				4'b0110 : outval = 4'd15;
				4'b0111 : outval = 4'd10;
				4'b1000 : outval = 4'd11;
				4'b1001 : outval = 4'd14;
				4'b1010 : outval = 4'd1;
				4'b1011 : outval = 4'd7;
				4'b1100 : outval = 4'd6;
				4'b1101 : outval = 4'd0;
				4'b1110 : outval = 4'd8;
				4'b1111 : outval = 4'd13;
			endcase
		end
		
	endcase
end 

endmodule


module sBox7(inval, outval);
input[5:0] inval;
output[3:0] outval;
reg[3:0] outval;

reg[3:0] xComp;
reg[1:0] yComp;

always @ (*)
begin
	xComp = inval[4:1];
	yComp = {inval[5],inval[0]};
	
	case(yComp)
		2'b00 : begin
			// sbox7 top line:  4 11   2 14  15  0   8 13   3 12   9  7   5 10   6  1
			case(xComp)
				4'b0000 : outval = 4'd4;
				4'b0001 : outval = 4'd11;
				4'b0010 : outval = 4'd2;
				4'b0011 : outval = 4'd14;
				4'b0100 : outval = 4'd15;
				4'b0101 : outval = 4'd0;
				4'b0110 : outval = 4'd8;
				4'b0111 : outval = 4'd13;
				4'b1000 : outval = 4'd3;
				4'b1001 : outval = 4'd12;
				4'b1010 : outval = 4'd9;
				4'b1011 : outval = 4'd7;
				4'b1100 : outval = 4'd5;
				4'b1101 : outval = 4'd10;
				4'b1110 : outval = 4'd6;
				4'b1111 : outval = 4'd1;
			endcase
		end
		2'b01 : begin
			// sbox7 2 line:  13  0  11  7   4  9   1 10  14  3   5 12   2 15   8  6
			case(xComp)
				4'b0000 : outval = 4'd13;
				4'b0001 : outval = 4'd0;
				4'b0010 : outval = 4'd11;
				4'b0011 : outval = 4'd7;
				4'b0100 : outval = 4'd4;
				4'b0101 : outval = 4'd9;
				4'b0110 : outval = 4'd1;
				4'b0111 : outval = 4'd10;
				4'b1000 : outval = 4'd14;
				4'b1001 : outval = 4'd3;
				4'b1010 : outval = 4'd5;
				4'b1011 : outval = 4'd12;
				4'b1100 : outval = 4'd2;
				4'b1101 : outval = 4'd15;
				4'b1110 : outval = 4'd8;
				4'b1111 : outval = 4'd6;
			endcase
		end
		2'b10 : begin
			// sbox7 3 line:   1  4  11 13  12  3   7 14  10 15   6  8   0  5   9  2
			case(xComp)
				4'b0000 : outval = 4'd1;
				4'b0001 : outval = 4'd4;
				4'b0010 : outval = 4'd11;
				4'b0011 : outval = 4'd13;
				4'b0100 : outval = 4'd12;
				4'b0101 : outval = 4'd3;
				4'b0110 : outval = 4'd7;
				4'b0111 : outval = 4'd14;
				4'b1000 : outval = 4'd10;
				4'b1001 : outval = 4'd15;
				4'b1010 : outval = 4'd6;
				4'b1011 : outval = 4'd8;
				4'b1100 : outval = 4'd0;
				4'b1101 : outval = 4'd5;
				4'b1110 : outval = 4'd9;
				4'b1111 : outval = 4'd2;
			endcase
		end
	   2'b11 : begin
			// sbox7 4 line:  6 11  13  8   1  4  10  7   9  5   0 15  14  2   3 12
			case(xComp)
				4'b0000 : outval = 4'd6;
				4'b0001 : outval = 4'd11;
				4'b0010 : outval = 4'd13;
				4'b0011 : outval = 4'd8;
				4'b0100 : outval = 4'd1;
				4'b0101 : outval = 4'd4;
				4'b0110 : outval = 4'd10;
				4'b0111 : outval = 4'd7;
				4'b1000 : outval = 4'd9;
				4'b1001 : outval = 4'd5;
				4'b1010 : outval = 4'd0;
				4'b1011 : outval = 4'd15;
				4'b1100 : outval = 4'd14;
				4'b1101 : outval = 4'd2;
				4'b1110 : outval = 4'd3;
				4'b1111 : outval = 4'd12;
			endcase
		end
		
	endcase
end 

endmodule


module sBox8(inval, outval);
input[5:0] inval;
output[3:0] outval;
reg[3:0] outval;

reg[3:0] xComp;
reg[1:0] yComp;

always @ (*)
begin
	xComp = inval[4:1];
	yComp = {inval[5],inval[0]};
	
	case(yComp)
		2'b00 : begin
			// sbox8 top line:  13  2   8  4   6 15  11  1  10  9   3 14   5  0  12  7
			case(xComp)
				4'b0000 : outval = 4'd13;
				4'b0001 : outval = 4'd2;
				4'b0010 : outval = 4'd8;
				4'b0011 : outval = 4'd4;
				4'b0100 : outval = 4'd6;
				4'b0101 : outval = 4'd15;
				4'b0110 : outval = 4'd11;
				4'b0111 : outval = 4'd1;
				4'b1000 : outval = 4'd10;
				4'b1001 : outval = 4'd9;
				4'b1010 : outval = 4'd3;
				4'b1011 : outval = 4'd14;
				4'b1100 : outval = 4'd5;
				4'b1101 : outval = 4'd0;
				4'b1110 : outval = 4'd12;
				4'b1111 : outval = 4'd7;
			endcase
		end
		2'b01 : begin
			// sbox8 2 line:   1 15  13  8  10  3   7  4  12  5   6 11   0 14   9  2
			case(xComp)
				4'b0000 : outval = 4'd1;
				4'b0001 : outval = 4'd15;
				4'b0010 : outval = 4'd13;
				4'b0011 : outval = 4'd8;
				4'b0100 : outval = 4'd10;
				4'b0101 : outval = 4'd3;
				4'b0110 : outval = 4'd7;
				4'b0111 : outval = 4'd4;
				4'b1000 : outval = 4'd12;
				4'b1001 : outval = 4'd5;
				4'b1010 : outval = 4'd6;
				4'b1011 : outval = 4'd11;
				4'b1100 : outval = 4'd0;
				4'b1101 : outval = 4'd14;
				4'b1110 : outval = 4'd9;
				4'b1111 : outval = 4'd2;
			endcase
		end
		2'b10 : begin
			// sbox8 3 line:   7 11   4  1   9 12  14  2   0  6  10 13  15  3   5  8
			case(xComp)
				4'b0000 : outval = 4'd7;
				4'b0001 : outval = 4'd11;
				4'b0010 : outval = 4'd4;
				4'b0011 : outval = 4'd1;
				4'b0100 : outval = 4'd9;
				4'b0101 : outval = 4'd12;
				4'b0110 : outval = 4'd14;
				4'b0111 : outval = 4'd2;
				4'b1000 : outval = 4'd0;
				4'b1001 : outval = 4'd6;
				4'b1010 : outval = 4'd10;
				4'b1011 : outval = 4'd13;
				4'b1100 : outval = 4'd15;
				4'b1101 : outval = 4'd3;
				4'b1110 : outval = 4'd5;
				4'b1111 : outval = 4'd8;
			endcase
		end
	   2'b11 : begin
			// sbox8 4 line:  2  1  14  7   4 10   8 13  15 12   9  0   3  5   6 11
			case(xComp)
				4'b0000 : outval = 4'd2;
				4'b0001 : outval = 4'd1;
				4'b0010 : outval = 4'd14;
				4'b0011 : outval = 4'd7;
				4'b0100 : outval = 4'd4;
				4'b0101 : outval = 4'd10;
				4'b0110 : outval = 4'd8;
				4'b0111 : outval = 4'd13;
				4'b1000 : outval = 4'd15;
				4'b1001 : outval = 4'd12;
				4'b1010 : outval = 4'd9;
				4'b1011 : outval = 4'd0;
				4'b1100 : outval = 4'd3;
				4'b1101 : outval = 4'd5;
				4'b1110 : outval = 4'd6;
				4'b1111 : outval = 4'd11;
			endcase
		end
		
	endcase
end 

endmodule


