`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:10:36 12/16/2015 
// Design Name: 
// Module Name:    keyboard 
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
module keyboard(
	input wire clk,// Clock pin form keyboard
	input wire data, //Data pin form keyboard
	output reg [7:0] k_scancode,  //Printing input data to k_scancode
	output reg [4:0] nible, 		// para scancodes del 0...9A...F teclado principal
											// {valid,[3.0]} msb =1 valid nible
	output reg valid_out
	);
	reg [7:0] data_curr;
	reg [7:0] data_pre;
	reg [3:0] b;
	reg flag;

	initial begin
		b<=4'h1;
		flag<=1'b0;
		//data_curr<=8'hf0;
		//data_pre<=8'hf0;
		//k_scancode<=8'hf0;
		valid_out<=0;
	end 
	always @(negedge clk) begin //Activating at negative edge of clock from keyboard
		case(b)
			1:; 		//first bit
			2:data_curr[0]<=data;
			3:data_curr[1]<=data;
			4:data_curr[2]<=data;
			5:data_curr[3]<=data;
			6:data_curr[4]<=data;
			7:data_curr[5]<=data;
			8:data_curr[6]<=data;
			9:data_curr[7]<=data;
			10:flag<=1'b1;  //Parity bit
			11:flag<=1'b0;  //stop bit
		endcase
		if(b<=10)
			b<=b+1;
		else if(b==11)
			b<=1;
	end 
	always@(posedge flag) begin // Printing data obtained to k_scancode
		if(data_curr==8'hf0)	begin // break code
			k_scancode<=data_pre;		// será leido nuevamente pero es el mismo :)
			valid_out<=1;
			end
		else begin
			data_pre<=data_curr;
			valid_out<=0;	// va a cero cuando se recibir make del sig caracter desde teclado
			end
	end

	always @(posedge valid_out) begin
		nible[4]<=1'b0;
		case(k_scancode)
			8'h45:	nible[3:0]<=4'h0;
			8'h1b:	nible[3:0]<=4'h1;
			8'h1E:	nible[3:0]<=4'h2;
			8'h2b:	nible[3:0]<=4'h3;
			8'h25:	nible[3:0]<=4'h4;
			8'h2E:	nible[3:0]<=4'h5;
			8'h3b:	nible[3:0]<=4'h6;
			8'h3d:	nible[3:0]<=4'h7;
			8'h3E:	nible[3:0]<=4'h8;
			8'h4b:	nible[3:0]<=4'h9;
			8'h1C:	nible[3:0]<=4'hA;
			8'h32:	nible[3:0]<=4'hB;
			8'h21:	nible[3:0]<=4'hC;
			8'h22:	nible[3:0]<=4'hD;
			8'h24:	nible[3:0]<=4'hE;
			8'h26:	nible[3:0]<=4'hF;
			default: nible[4]<=1'b1;
		endcase
	end

endmodule
