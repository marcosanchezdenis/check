`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:39:06 11/24/2015 
// Design Name: 
// Module Name:    detect 
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
	module detect (
		input wire clk,enable,reset,d,
		output reg init
	);
	always@(negedge clk or posedge reset) begin 
			if(reset) begin 
				init <= 0;
			end else begin 
				if(enable) begin
					init <= d;
				end
			end
	end
	endmodule
