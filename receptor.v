`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:44:09 10/19/2015 
// Design Name: 
// Module Name:    receptor 
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
module receptor(
	input wire clk,
	input wire reset,
	input wire x,
	output wire finished,
	output wire [7:0]data

);
	wire deteccion_flanco_bajada;
	assign deteccion_flanco_bajada = ~x;
	localparam IDLE  = 5'd0;
	localparam START_BIT = 5'd1;
	localparam B0 = 5'd2;
	localparam B1 = 5'd3;
	localparam B2 = 5'd4;
	localparam B3 = 5'd5;
	localparam B4 = 5'd6;
	localparam B5 = 5'd7;
	localparam B6 = 5'd8;
	localparam B7 = 5'd9;
	localparam B0_C = 5'd10;
	localparam B1_C = 5'd11;
	localparam B2_C = 5'd12;
	localparam B3_C = 5'd13;
	localparam B4_C = 5'd14;
	localparam B5_C = 5'd15;
	localparam B6_C = 5'd16;
	localparam B7_C = 5'd17;
	localparam STOP_BIT =5'd18;
	// Logica de memoria
	
	reg [4:0] estado_actual = IDLE, estado_siguiente;
	wire clk2,time_over8,time_over16, reset_conteo;
	wire [31:0]conteo;
	wire in_data, enabled_buffer;
	wire init;

	//instanciación de módulos
	clk_receptor pulso_rapido(
		.clk(clk),
		.clk_1843200(clk2)
	);
	shiftreg_serialin buffer_entrada (
    .clk(enabled_buffer), 
    .reset(reset),  
    .d(x), 
    .sout(data)
    );

	contador timer(
		.clk(clk2),
		.reset(reset_conteo),
		.y(conteo)
	);

	always@(posedge clk2, posedge reset)	begin 
		if(reset) begin 
			estado_actual <= IDLE;
		end else begin 
			estado_actual <= estado_siguiente;
		end
	end

	detect dt (
    .clk(x), 
	 .d(~x),
    .enable((estado_actual==IDLE)), 
    .reset((estado_actual==START_BIT)), 
    .init(init)
    );
	
	
	// logica de transiciones
	always@(*) begin 
		case (estado_actual) 
		IDLE: begin 
			if( init) begin 
				estado_siguiente <= START_BIT;
			end else begin 
				estado_siguiente <= IDLE;
			end
		end
		START_BIT: begin 
			if(time_over8) begin 
				estado_siguiente <= B0 ;
			end else begin
				estado_siguiente <=  START_BIT; 
			end
		end
		B0: begin
			if(time_over16)  begin
				estado_siguiente <=  B0_C;
			end else begin 
				estado_siguiente <= B0;
			end 
		end
		B0_C: estado_siguiente <= B1;
		B1: begin 
			if (time_over16) begin 
				estado_siguiente <=  B1_C;
			end else begin 
				estado_siguiente <= B1;
			end
		end
		B1_C: estado_siguiente <= B2;
		B2: begin 
			if(time_over16) begin 
				estado_siguiente <= B2_C;
			end else begin 
				estado_siguiente <= B2;
			end
		end
		B2_C: estado_siguiente <= B3;
		B3: begin 
			if(time_over16) begin 	
				estado_siguiente <= B3_C;
			end else begin
				estado_siguiente <= B3;
			end
		end
		B3_C: estado_siguiente <= B4;
		B4: begin 
			if (time_over16) begin 
				estado_siguiente <= B4_C;
			end else begin
				estado_siguiente <= B4;
			end
		end
		B4_C: estado_siguiente <= B5;
		B5: begin 
			if (time_over16) begin 
				estado_siguiente <= B5_C;
			end else begin
				estado_siguiente <= B5;
			end
		end
		B5_C: estado_siguiente <= B6;
		B6: begin 
			if(time_over16) begin 
				estado_siguiente <= B6_C;
			end else begin
				estado_siguiente <= B6;
			end
		end
		B6_C: estado_siguiente <= B7;
		B7: begin 
			if(time_over16) begin 
				estado_siguiente <= B7_C;
			end else begin
				estado_siguiente <= B7;
			end
		end
		B7_C: estado_siguiente <= STOP_BIT;
		STOP_BIT: begin 
			if (time_over16) begin 
				estado_siguiente <= IDLE; 
			end else begin 
				estado_siguiente <= STOP_BIT;
			end
		end
	endcase
	end

assign time_over8 = ( (	estado_actual == START_BIT) && conteo ==32'd7 )? 1:0;
assign time_over16 = ( in_data && conteo ==32'd15 )? 1:0;

assign in_data = ( (	estado_actual == B0 ||
								estado_actual == B1 ||
								estado_actual == B2 ||
								estado_actual == B3 ||
								estado_actual == B4 ||
								estado_actual == B5 ||
								estado_actual == B6 ||
								estado_actual == B7 ||
								estado_actual == 	STOP_BIT
								)
								)? 1:0;
assign enabled_buffer = (estado_actual == B0_C || estado_actual == B1_C || estado_actual == B2_C ||
								estado_actual == B3_C || estado_actual == B4_C || estado_actual == B5_C ||
								estado_actual == B6_C || estado_actual == B7_C 		)?1:0;// ( (in_data && conteo > 32'd7 &&  conteo < 32'd9) 			|| (conteo == 32'd4 && estado_actual == START_BIT))?1:00; 
								
assign reset_conteo =  ( time_over16 || time_over8 ||  estado_actual == IDLE )? 1:0;
 
assign finished = (estado_actual == STOP_BIT)?1:0 ;


endmodule
