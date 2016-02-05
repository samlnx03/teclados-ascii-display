`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:05:44 01/15/2016 
// Design Name: 
// Module Name:    keyb_disp 
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
module keyb_disp(
	input wire clk,// Clock pin form keyboard
	input wire data, //Data pin form keyboard
	input ireset,	// pb[0]
	input reloj,	// 50 Mhz basys2

	output [7:0] disp_7seg_a_g_dp,  // display multiplexado
	output [3:0] anodos					// anodos display multiplexado
    );

	wire [7:0] scancode;	// from keyboard
	wire [4:0] nible;		//para teclas del 0..9a..f  MSB indica validez, active low
	wire valid_out;			// from keyboard
	
	wire Mkey;
	wire 

	 wire osreset, reset;
	 one_shot init_reset(reloj, ireset, osreset);
	 assign reset=ireset|osreset;

	keyboard k(clk, data, scancode, nible, valid_out);
	
	always @(posedge valid_out) begin
		if(reset) begin
			state<=INICIAL;
		end else begin
			case (state)
				INICIAL: begin
					if(scancode==8'h3A) begin //M
						state<=MEMEDIT0;
						direccion<=8'b0;
					end
					else if(scancode==8'h00)	// S step
						state<=STEP0
					else
						state<=ERR;	// invalid scancode
				end
				
				MEMEDIT0: begin
					if(nible[4])
						state<=ERR;
					else begin
						state<=MEMEDIT1;
						nible0<=nible[3:0];
					end
				end

				MEMEDIT1: begin
					if(nible[4])
						state<=ERR;
					else begin
						state<=NEXTMEM;
						nible1<=nible[3:0];
					end
				end
						

				default: // default state
			endcase
		end
	end
	
	always @(posedge reloj) begin
		if(reset)
			load<=1'b0;
			display<=0;
		else
			case(state)
				INICIAL: begin
					can_change<=1'b1;					
				end
				MEMEDIT0: begin
					case(display)
						0: begin		// lsn del almacenado en la ram
							load<=1'b1;
							sevenSegAGdp<=8'bff;
							bufdestino<=display[1:0];
							display<=display+1;
						end
						1: begin		// msn del almacenado en la ram
							load<=1'b1;
							bufdestino<=display[1:0];
							display<=display+1;
						end
						2: begin		// lsn de la direccion de mem
							load<=1'b1;
							sevenSegAGdp<=8'bff;
							bufdestino<=display[1:0];
							display<=display+1;
						end
						3: begin		// msn de la direccion de mem
							load<=1'b1;
							hEntrada<=direccion[7:4];
							bufdestino<=display[1:0];
							display<=display+1;
						end
						default: begin
							load<=1'b0;
						end
					endcase
				end
				default:
			endcase
	end

	display4mux display(reset, reloj, load, sevenSegAGdp, bufdestino, disp_7seg_a_g_dp, anodos);

	always @(*) begin
		case(display[1:0])
			3: hEntrada=direccion[7:4];
			2: hEntrada=direccion[3:0];
			1: hEntrada=almacenado[7:4];
			0: hEntrada=almacenado[3:0];
		endcase
	end
	
	conv_hex_7seg h7s(hEntrada, sevenSegAGdp);


endmodule

module one_shot( input clock, ireset, output oreset);
   reg [4:0] m;
   always @ (posedge clock)
      if (ireset)
         m <= 4'b000;
      else
         m <= {m[3:0], 1'b1};
   assign oreset = m[0] & m[1] & m[2] & m[3] &!m[4];
endmodule

