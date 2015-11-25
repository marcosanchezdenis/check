`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:08:38 10/23/2015
// Design Name:   serialDevice
// Module Name:   /home/ucaguest/SERIAL/test_device.v
// Project Name:  SERIAL
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: serialDevice
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_device;
 
	// Inputs
	reg clk;
	reg reset;
	reg init;
	reg rx;
	reg [7:0] in_data;
	reg start_send;

	// Outputs
	wire tx;
	wire [7:0] out_data;
	 
    wire [7:0]lcd_db;
    wire lcd_e;
    wire lcd_rs; 
    wire lcd_rw;
 
	// Instantiate the Unit Under Test (UUT)
serialDevice instance_name (
    .clk(clk), 
    .init(init), 
    .reset(reset), 
    .rx(rx), 
    .tx(tx), 
    .start_send(start_send), 
    .in_data(in_data),  
    .lcd_db(lcd_db), 
    .lcd_e(lcd_e), 
    .lcd_rs(lcd_rs), 
    .lcd_rw(lcd_rw)
    );
	
 
	initial begin
	reset <= 1; # 22; reset <= 0;	
	init <= 1; # 22; init <= 0;	
	rx <= 1;
	//dos procesos
		//1) envio de datos
			//se necesita activa el start_Send  y proveer los datos
			
			
					
		//2) recepcion de datos
			//se necesita sentir un comportamiento en la señal de entrada
			# 25_234_134
			rx <= 0; # 8680;// estado normal
			
			rx<=0; # 8680;  // inicio del envio			
			rx<=1; # 8680; 
			rx<=0; # 8680; 
			rx<=1; # 8680; 
			rx<=1; # 8680; 
			rx<=0; # 8680;
			rx<=1; # 8680;
			rx<=1; # 8680;
			
			rx<=0; # 8680;
			// el numero enviado es 10_11_01_10
			rx<=1; # 8680; //terminacion de envio
			
			
			rx<=1; # 8680;
			rx<=0; # 8680; 
			rx<=1; # 8680; 
			rx<=1; # 8680; 
			rx<=0; # 8680;
			rx<=1; # 8680;
			rx<=1; # 8680;
			rx<=0; # 8680;
			rx<=1; # 8680;
			
			


    

	end
	always
		begin
		clk <= 1; # 10; clk <= 0; # 10;
		end
      
endmodule

