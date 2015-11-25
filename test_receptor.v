`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:40:42 10/20/2015
// Design Name:   receptor
// Module Name:   /home/ucaguest/SERIAL/test_receptor.v
// Project Name:  SERIAL
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: receptor
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_receptor;

	// Inputs
	reg clk;
	reg reset;
	reg deteccion_flanco_bajada;
	reg x;
	// Instantiate the Unit Under Test (UUT)
	receptor uut (
		.clk(clk), 
		.reset(reset), 
		.deteccion_flanco_bajada(deteccion_flanco_bajada),
		.x(x)
	);

	initial
		begin
		reset <= 1; # 22; reset <= 0;
		deteccion_flanco_bajada <= 1; 
		x<=1; # 9180; x<=0;# 9180; x<=1;# 9180; x<=1;# 9180; x<=0;
		end


		// generate clock to sequence tests CLOCK
		always
		begin
		clk <= 1; # 10; clk <= 0; # 10;
		end
      
endmodule

