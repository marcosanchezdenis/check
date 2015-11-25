`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:44:36 10/19/2015 
// Design Name: 
// Module Name:    serialDevice 
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
module serialDevice(
	input wire clk,
	input wire init,
	input wire reset,
	input wire rx,
	output wire tx,
	input wire start_send,
	input wire [7:0]in_data,
	output wire [7:0]out_data,
	output wire [7:0]lcd_db,
	output wire lcd_e,
	output wire lcd_rs,
	output wire lcd_rw
	
	
	);
	
wire finished;
	
	receptor r1(
		.clk(clk),
		.reset(reset),
		.x(rx),
		.data(out_data),
		.finished(finished)
	);
	
	
	
	controller lcd (
    .clk(clk), 
    .reset(reset), 
    .init(init), //-- 
    .enviar(finished),//-- 
    .info(out_data), 
    .lcd_db(lcd_db), 
    .lcd_e(lcd_e), 
    .lcd_rs(lcd_rs), 
    .lcd_rw(lcd_rw)
    );
	reg [31:0]ff_lcd_db;
	always@(posedge clk or posedge lcd_e) begin 
		if(lcd_e) begin 
			ff_lcd_db<= lcd_db;
		end
	
	end
	
	transmisor  t1(
		.clk(clk),
		.reset(reset),
		.iniciar_envio(start),
		.data(in_data),
		.y(tx)
	);
	
	start signal (
    .clk(clk), 
    .reset(reset), 
    .start_send(start_send), 
    .start(start)
    );
	

endmodule
