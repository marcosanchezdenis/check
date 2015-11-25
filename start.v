`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:40:50 11/19/2015 
// Design Name: 
// Module Name:    start 
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
module start(
		input wire clk,reset,start_send,
		output wire start
	);
	localparam IDLE = 2'd0;
	localparam CICLO1 = 2'd1;
	localparam CICLOI = 2'd2;
	
	reg [1:0]actual=IDLE,siguiente;
	
	
	always@(posedge clk) begin 
		if(reset) begin 
			actual <= IDLE;
		end else begin 
			actual <= siguiente;
		end
	end
	
	always@(*) begin
		case(actual)
			IDLE:	begin
				if(start_send) begin 
					siguiente <= CICLO1;
				end else begin
					siguiente <= IDLE;
				end 
			end
			CICLO1:	begin 
				siguiente <= CICLOI;
			end
			CICLOI: begin 
				if(!start_send) begin 
					siguiente <= IDLE;
				end else begin 
					siguiente <=CICLOI;
				end
			end
		endcase
	end
	assign start = (actual == CICLO1)? 1:0;
endmodule
