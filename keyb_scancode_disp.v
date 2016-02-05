`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:31:07 01/26/2016 
// Design Name: 
// Module Name:    keyb_scancode_disp 
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
module keyb_scancode_disp(
	input reset,	// pb[0]
	input reloj,	// 50 Mhz basys2
	input [7:0] scancode, valid_scan_code,

	output [7:0] disp_7seg_a_g_dp,  // display multiplexado
	output [3:0] anodos					// anodos display multiplexado
    );
	 
	 reg load=1'b0; 			// controla la carga del buffer del display multiplexad0
	 reg state=2'b00;			// buffer en el display multiplexado
	 reg [3:0] nible;			// digito hexadecimal a mostrar en un buffer del display
	 reg [1:0] bufdestino =2'b00; // buffer destino para el nible anterior
	 
	 wire [7:0] sevenSegAGdp;
	 
	 always@(posedge reloj) begin
		if(reset) begin
			state<=2'b00;
			load<=1'b0;
		end
		else if(valid_scan_code) begin
			case (state)
			2'b00: begin
				nible<=scancode[3:0];
				bufdestino<=2'b00;
				load<=1'b1;
				state<=2'b01;
				end
			2'b01: begin
				nible<=scancode[7:4];
				bufdestino<=2'b01;
				load<=1;
				state<=2'b10;
				end
			default: begin
					load<=1'b0;
			end
			endcase
		end
		else begin
			state<=2'b00;
			load<=1'b0;
		end
	 end
	 
	 conv_hex_7seg h7s(nible, sevenSegAGdp);
	 
	 display4mux display(reset, reloj, load, sevenSegAGdp, bufdestino, disp_7seg_a_g_dp, anodos);

endmodule

