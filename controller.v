`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:37:21 10/26/2015 
// Design Name: 
// Module Name:    control_lcd 
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
module controller(
	input wire clk,
	input wire reset,
	input wire init,
	input wire enviar,
	input wire [7:0]info,
	output wire [7:0]lcd_db,
	output wire lcd_e,
	output wire lcd_rs,
	output wire lcd_rw
	
);

assign lcd_rw =0;

localparam IDLE = 4'd0;
localparam INIT = 4'd1;
localparam FUNCTION_SET	= 4'd2;
localparam ENTRY_MODE_SET =  4'd3;
localparam DISPLAY_ON = 4'd4;
localparam CLEAR_DISPLAY = 4'd5;
localparam WAIT_82000 = 4'd6;
localparam SET_ADDRESS = 4'd7;
localparam WRITE_CHAR = 4'd8;
localparam IDLE_CHAR  = 4'd9;
localparam DONE = 4'd10;
localparam DONTCARE = 4'd11;


reg [3:0]current_state,next_state;
wire init_initializer, init_sender;
wire tx_done,init_done;
wire [31:0]conteo;
wire lcd_e_send, lcd_e_init;
wire [7:0]lcd_db_send, lcd_db_init;
wire [7:0]data;
			
contador counter(
	.clk(clk),
	.reset(timer_82000_done || current_state == CLEAR_DISPLAY),
	.y(conteo)
);

init inicio (
    .clk(clk), 
    .reset(reset), 
    .init(init_initializer),  // INICIALIZADOR DEL INITIALIZER ( SOLO SE UTILIZA UNA VEZ POR PROCESO DE LCD)
    .lcd_db(lcd_db_init), 
    .lcd_e(lcd_e_init), 
    .done(init_done)
    );
	   
 
send envio (
	.clk(clk), 
	.init(init_sender), // INICIALIZADOR DEL ENVIO ( SE UTILIZA VARIAS VECES POR PROCESO DE LCD)
	.reset(reset), 
	.lcd_e(lcd_e_send), 
	.data(data), 
	.lcd_db(lcd_db_send),
	.done(tx_done)
 );
 
	
 
always@(posedge clk) begin 
	if(reset)	begin 
		current_state <= IDLE;
	end else begin 
		current_state <= next_state;
	end
end
 

	 
always @ (*) begin
	case (current_state)
	
	// INICIO DEL LCD
	
		IDLE: begin // espera la señal de inicio para inicializar y configurar el LCD
			if (init) begin
				next_state = INIT;
			end else begin
				next_state = IDLE;
			end
		end
		
		// PROCESO DE INICIALIZACION DEL LCD
		
		
		INIT: begin // inicializar el LCD y esperar a que termine la inicialización
			if (init_done) begin
				next_state = FUNCTION_SET;
			end else begin
				next_state = INIT;
			end
		end
		
		
		// PROCESOS DE INICIALIZACION 
		
		
		FUNCTION_SET: begin // configuración, enviar el modo de funcionamiento
			if (tx_done) begin
				next_state = ENTRY_MODE_SET;
			end else begin
				next_state = FUNCTION_SET;
			end
		end
		ENTRY_MODE_SET: begin // configuración, enviar el modo de entrada
			if (tx_done) begin
				next_state = DISPLAY_ON;
			end else begin
				next_state = ENTRY_MODE_SET;
			end
		end
		DISPLAY_ON: begin // configuración, enviar el comando de encendido de display
			if (tx_done) begin
				next_state = CLEAR_DISPLAY;
			end else begin
				next_state = DISPLAY_ON;
			end
		end
		CLEAR_DISPLAY: begin // configuración, enviar el comando de borrar el display
			if (tx_done) begin
				next_state = WAIT_82000;
			end else begin
				next_state = CLEAR_DISPLAY;
			end
		end
		WAIT_82000: begin // esperar 82000 ciclos
			if (timer_82000_done) begin
				next_state = SET_ADDRESS;
			end else begin
				next_state = WAIT_82000;
			end
		end
		SET_ADDRESS: begin // escritura, establece la dirección del display a donde se escribe
			if (tx_done) begin
				next_state = IDLE_CHAR;
			end else begin
				next_state = SET_ADDRESS;
			end
		end
		IDLE_CHAR: begin // escritura, enviar el caracter que se quiere escribir, lcd_rs=1
			if (enviar) begin
				next_state = WRITE_CHAR;
			end else begin
				next_state = IDLE_CHAR;
			end
		end
		WRITE_CHAR: begin // escritura, enviar el caracter que se quiere escribir, lcd_rs=1
			if (tx_done) begin
				next_state = IDLE_CHAR;
			end else begin
				next_state = WRITE_CHAR;
			end
		end
	
	
	endcase
	end
	
	
		 assign lcd_e = (lcd_e_init | lcd_e_send);
			 assign lcd_db = (lcd_db_init | lcd_db_send);
			 assign lcd_rs = (current_state  == WRITE_CHAR);
			 
 			 
			 
			 
	assign timer_82000_done =  ( current_state == WAIT_82000 && conteo == 32'd82000)?1:0;
	
	assign init_initializer = (current_state == INIT)? 1:0;
	assign init_sender = (current_state == FUNCTION_SET ||
	current_state == ENTRY_MODE_SET ||
	current_state == DISPLAY_ON ||
	current_state == CLEAR_DISPLAY ||
	current_state == SET_ADDRESS ||
	current_state == WRITE_CHAR )? 1:0; 
	
	assign data = 
				(current_state == FUNCTION_SET ) 	? 8'h28:
				(current_state == ENTRY_MODE_SET)	? 8'h6:
				(current_state == DISPLAY_ON ) 		? 8'hc:
				(current_state == CLEAR_DISPLAY ) 	? 8'h1:
				(current_state == SET_ADDRESS) 		? 8'h80:
				(current_state == WRITE_CHAR) 		? info[7:0]:				
				8'h0;
				
		
	

endmodule
 
