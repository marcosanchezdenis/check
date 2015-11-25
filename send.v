`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:44:37 11/14/2015 
// Design Name: 
// Module Name:    send 
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
module send( 
	input wire clk,init,reset,
	output wire lcd_e,
	input wire [7:0]data,
	output wire [7:0]lcd_db,
	output wire done




);
	localparam IDLE = 4'd0;
	localparam MSN_SETUPTIME = 4'd1;
	localparam MSN_HOLDTIME = 4'd2;
	localparam WAIT_50 = 4'd3;
	localparam LSN_SETUPTIME = 4'd4;
	localparam LSN_HOLDTIME = 4'd5;
	localparam WAIT_2000 = 4'd6;
	localparam DONE = 4'd7;
	localparam DONTCARE = 4'd8;


	reg[2:0] current_state = IDLE, next_state;

	always@(posedge clk,posedge reset ) begin 
		if(reset) begin
			current_state <= IDLE;
		end else begin
			current_state <= next_state;
		end
	end

 	wire timer_2_done, timer_12_done, timer_50_done, timer_2000_done, reset_counter;
 	wire [31:0]conteo;
	
	
	contador counter (
		.clk(clk),
		.reset(reset_counter),
		.y(conteo)
	);
	always @ (*) begin
		case (current_state)
			IDLE: begin // esperar la señal de inicio para enviar un comando o un caracter
			if (init) begin
					next_state = MSN_SETUPTIME;
				end else begin
					next_state = IDLE;
				end
			end
			MSN_SETUPTIME: begin // espera 2 ciclos, lcd_db=nibble_mas_significativo
				if (timer_2_done) begin
					next_state = MSN_HOLDTIME;
				end else begin
					next_state = MSN_SETUPTIME;
				end
			end
			MSN_HOLDTIME: begin // espera 12 ciclos, lcd_e=1, lcd_db=nibble_mas_significativo
				if (timer_12_done) begin
					next_state = WAIT_50;
				end else begin
					next_state = MSN_HOLDTIME;
				end
			end
			WAIT_50: begin // espera 50 ciclos
				if (timer_50_done) begin
					next_state = LSN_SETUPTIME;
				end else begin
					next_state = WAIT_50;
				end
			end
			LSN_SETUPTIME: begin // espera 2 ciclos, lcd_db=nibble_menos_significativo
				if (timer_2_done) begin
					next_state = LSN_HOLDTIME;
				end else begin
					next_state = LSN_SETUPTIME;
				end
			end
			LSN_HOLDTIME: begin // espera 12 ciclos, lcd_e=1, lcd_db=nibble_menos_significativo
				if (timer_12_done) begin
					next_state = WAIT_2000;
				end else begin
					next_state = LSN_HOLDTIME;
				end
			end
			WAIT_2000: begin // espera 2000 ciclos
				if (timer_2000_done) begin
					next_state = DONE;
				end else begin
					next_state = WAIT_2000;
				end
			end
			DONE: begin
				next_state = IDLE;
			end
			default: begin
				next_state = DONTCARE;
			end
		endcase
	end


    
	assign timer_2_done = 	 ((current_state == MSN_SETUPTIME  || current_state == LSN_SETUPTIME ) && conteo == 32'd1 )? 1:0; 
	assign timer_12_done =   ((current_state == MSN_HOLDTIME  || current_state == LSN_HOLDTIME ) && conteo == 32'd11 )? 1:0;
	
	
	assign timer_50_done =   ((current_state == WAIT_50 ) && conteo == 32'd49 )? 1:0;
	assign timer_2000_done = ((current_state == WAIT_2000 ) && conteo == 32'd1999 )? 1:0;
	
	assign reset_counter = 	 ( timer_2000_done || timer_50_done || timer_12_done || timer_2_done || current_state == IDLE )? 1:0;
	
	
	assign lcd_e = ( current_state == MSN_HOLDTIME || current_state == LSN_HOLDTIME )? 1:0;
	
	assign lcd_db[7] = (current_state == MSN_SETUPTIME || current_state == MSN_HOLDTIME)? data[7]: ((current_state == LSN_SETUPTIME || current_state == LSN_HOLDTIME)?data[3]:8'd0);
	assign lcd_db[6] = (current_state == MSN_SETUPTIME || current_state == MSN_HOLDTIME)? data[6]: ((current_state == LSN_SETUPTIME || current_state == LSN_HOLDTIME)?data[2]:8'd0);
	assign lcd_db[5] = (current_state == MSN_SETUPTIME || current_state == MSN_HOLDTIME)? data[5]: ((current_state == LSN_SETUPTIME || current_state == LSN_HOLDTIME)?data[1]:8'd0);
	assign lcd_db[4] = (current_state == MSN_SETUPTIME || current_state == MSN_HOLDTIME)? data[4]: ((current_state == LSN_SETUPTIME || current_state == LSN_HOLDTIME)?data[0]:8'd0);
	assign lcd_db[3] = (current_state == MSN_SETUPTIME || current_state == MSN_HOLDTIME || current_state == LSN_SETUPTIME || current_state == LSN_HOLDTIME)?1:0;
	assign lcd_db[2] = (current_state == MSN_SETUPTIME || current_state == MSN_HOLDTIME || current_state == LSN_SETUPTIME || current_state == LSN_HOLDTIME)?1:0;
	assign lcd_db[1] = (current_state == MSN_SETUPTIME || current_state == MSN_HOLDTIME || current_state == LSN_SETUPTIME || current_state == LSN_HOLDTIME)?1:0;
	assign lcd_db[0] = (current_state == MSN_SETUPTIME || current_state == MSN_HOLDTIME || current_state == LSN_SETUPTIME || current_state == LSN_HOLDTIME)?1:0;
	assign done = (current_state == DONE)? 1:0;
	
endmodule

