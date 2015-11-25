`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:07:40 10/19/2015 
// Design Name: 
// Module Name:    contador 
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
	module contador(
	input wire clk,
	input wire reset,
	output wire [31:0]y
    );
	reg[31:0]q;
	always@(posedge clk) begin
		if( reset )  begin 
			q= 32'd0;
		end else begin
			q= q + 32'd1; 
		end
	end 
	assign y= q;
endmodule
