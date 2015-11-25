`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:23:13 10/19/2015
// Design Name:   transmisor
// Module Name:   /home/ucaguest/SERIAL/test_transmisor.v
// Project Name:  SERIAL
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: transmisor
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_transmisor;

	// Inputs
	reg clk;
	reg reset;
	reg iniciar_envio;

	// Instantiate the Unit Under Test (UUT)
	transmisor uut (
		.clk(clk), 
		.reset(reset), 
		.iniciar_envio(iniciar_envio)
	);

initial
begin
reset <= 1; # 22; reset <= 0;
iniciar_envio <= 1;// # 22; iniciar_envio <= 0;
end


// generate clock to sequence tests CLOCK
always
begin
clk <= 1; # 5; clk <= 0; # 5;
end
      
endmodule

