`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:00:44 10/19/2015 
// Design Name: 
// Module Name:    clk_transmisor 
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
module clk_transmisor( input wire clk, 
output wire clk_115200 );
	reg [31:0]contador =0 ;

	reg estado=0;


	always@(posedge clk) begin	
		if(contador == 31'd434) begin
			contador = 31'd0;
		end

		contador = contador + 1'd1;
		
		if(contador > 32'd217) begin
			estado <= 1'd0;
		end else begin
			estado <= 1'd1;
		end
			
	end
	
	assign clk_115200 = estado;
endmodule

