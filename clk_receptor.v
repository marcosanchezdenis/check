`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:54:44 10/19/2015 
// Design Name: 
// Module Name:    clk_receptor 
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
module clk_receptor( input wire clk, output wire clk_1843200 );

	reg [31:0]contador =0 ;
	reg estado=0;
 
	always@(posedge clk) begin	
		if(contador == 31'd27) begin
			contador = 31'd0;
		end

		contador = contador + 1'd1;
		
		if(contador < 32'd13) begin
			estado <= 1'd0;
		end else begin
			estado <= 1'd1;
		end
	end
	assign clk_1843200 = estado;
endmodule
