`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:01:56 10/19/2015 
// Design Name: 
// Module Name:    shiftreg_parallelin 
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
module shiftreg_parallelin #(parameter N = 9)(
	input wire clk,reset,load,sin,
	input wire [N-2:0] d,
	output wire sout);
	
	reg [N-1:0] q;
	always @(posedge clk or posedge reset) begin
		if (reset) begin
			q <= 9'd0; 
		 end else begin  
			if (load) begin
				q <= {2'b0,d};
			end else begin	
				q <= {q[N-2:0], sin};
			end
		end
	end
	assign sout = q[N-1];
endmodule
