`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:50:14 11/16/2015 
// Design Name: 
// Module Name:    registro 
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
module registro (
	input wire clk,reset,enable,
	input wire d,
	output reg q,
	input wire [7:0] d2,
	output reg [7:0] q2);
	 
	
	always @(posedge clk or posedge reset ) begin
			if (reset) 
				q <= 1'd0;			
			else	if(enable) 
				q <= d;						
			
	end	
		
	always @(posedge clk or posedge reset ) begin		
			if (reset) 		
				q2 <= 8'd0;
			else if(enable) 	
				q2 <= d2;			
		 
	
	end
endmodule

