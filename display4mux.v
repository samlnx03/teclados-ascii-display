`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:21:21 01/14/2016 
// Design Name: 
// Module Name:    display4mux 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//		reloj de 50 Mhz de la basys2
//		load señal de cargar datos a unos de los 4 buffers de 8 bits 
//		datai dato de 8 bits a cargar en el buffer 7 seg a-g+dp
//		bufdestino buffer destino para cargar
//	
// 	con load=0 multiplexa
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
/* este  es el bueno
module display4mux(
    input reset,
	 input reloj, load,
	 input [7:0] datai,
	 input [1:0] bufdestino,
	 
    output reg [7:0] disp_7seg_a_g_dp,
	 output reg [3:0] anodos
    );

	reg[20:0] divisor;	// para el div de frec del despliegue multiplexado
	assign anodosctrl={divisor[15],divisor[14]};	 // despliegue
	reg [7:0] buff[3:0]; //reg [3:0] e;	//enable de ff_d's

	always @(posedge reloj) begin
		divisor<=divisor+1;
		case(anodosctrl)
			2'd0: anodos=4'b1110; 
			2'd1: anodos=4'b1101; 
			2'd2: anodos=4'b1011; 
			2'd3: anodos=4'b0111; 
			default: anodos=4'b1111;
		endcase
	end

	always @(posedge reloj) begin
		if(reset)
			//disp_7seg_a_g_dp <= 8'b11111110;
			buff[bufdestino] <= 8'b11111110;
		else if(load) 
			buff[bufdestino] <= datai;
		else 	// display
			disp_7seg_a_g_dp <= buff[anodosctrl];
	end
		 
endmodule
*/


module display4mux(
    input reset,
	 input reloj, load,
	 input [7:0] datai,
	 input [1:0] bufdestino,
	 
    output reg [7:0] disp_7seg_a_g_dp,
	 output reg [3:0] anodos
    );

	reg[20:0] divisor;	// para el div de frec del despliegue multiplexado
	reg [7:0] buff[3:0]; //reg [3:0] e;	//enable de ff_d's
	
	reg [1:0] cero_tres=2'b00;
	/* no necesaria porque se da un reset general con un one-shoot
	reg [2:0] k;
	initial begin
		for(k=0; k<4; k=k+1)
			buff[k]=8'b11111110;
	end
	*/

	always @(posedge reloj) begin
		divisor<=divisor+1;
	end
	assign anodosctrl={divisor[15],divisor[14]};	 // despliegue

	// despliegue
	always @(posedge reloj)
			disp_7seg_a_g_dp <= buff[anodosctrl];

	always @(*)
		case(anodosctrl)
			2'd0: anodos=4'b1110; 
			2'd1: anodos=4'b1101; 
			2'd2: anodos=4'b1011; 
			2'd3: anodos=4'b0111; 
			default: anodos=4'b1111;
		endcase

	always @(posedge reloj) begin
		if(reset | (|cero_tres)) begin
			buff[cero_tres]<=8'b11111110;
			cero_tres<=cero_tres+1;
		end
		else if(load) 
			buff[bufdestino] <= datai;
	end
	
endmodule

