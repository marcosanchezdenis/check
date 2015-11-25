`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:56:01 10/19/2015 
// Design Name: 
// Module Name:    shiftreg_serialin 
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
module shiftreg_serialin #(parameter N = 8)(
	input wire clk,reset,
	input wire d,
	output wire [N-1:0] sout);
		reg [N-1:0] q;
	always @(posedge clk, posedge reset) begin
		if (reset) begin
			q <= 0;
		end else begin 			
				q <= {q[N-2:0], d};			
		end
	end
	assign sout = q;
endmodule
