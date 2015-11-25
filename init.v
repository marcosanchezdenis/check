`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:44:21 11/14/2015 
// Design Name: 
// Module Name:    init 
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


module init( 
	input wire clk,reset,init,
	output wire [7:0]lcd_db,
	output wire lcd_e,
	output wire done
);

localparam IDLE 		 	 =5'd0;
localparam CONTEO_WAIT1  =5'd1;
localparam CONTEO_WRITE1 =5'd2;
localparam CONTEO_WAIT2  =5'd3;
localparam CONTEO_WRITE2 =5'd4;
localparam CONTEO_WAIT3  =5'd5;
localparam CONTEO_WRITE3 =5'd6;
localparam CONTEO_WAIT4  =5'd7;
localparam CONTEO_WRITE4 =5'd8;
localparam CONTEO_WAIT5  =5'd9;
localparam DONE 			 =5'd10;
localparam DONTCARE      =5'd11;

reg [4:0] estado_actual=IDLE, estado_siguiente;
wire [31:0]conteo;
wire terminado,reset_conteo;


contador timer(
	.clk(clk),
	.reset(reset_conteo),	
	.y(conteo)
	
);



always@(posedge clk,posedge reset) begin
	if(reset) begin
		estado_actual <= IDLE;
	end else begin
		estado_actual <= estado_siguiente;	
	end
end


always@(*) begin 
	case (estado_actual)
		IDLE: begin
			if(init) begin
				estado_siguiente <= CONTEO_WAIT1;
			end else begin
				estado_siguiente <= IDLE;
			end
		end
	
		CONTEO_WAIT1: begin
			if(terminado) begin
				estado_siguiente <= CONTEO_WRITE1;
			end else begin
				estado_siguiente <= CONTEO_WAIT1;
			end
		end
	
		CONTEO_WRITE1: begin
			if(terminado) begin
				estado_siguiente <= CONTEO_WAIT2;
			end else begin
				estado_siguiente <= CONTEO_WRITE1;
			end
		end
		
		CONTEO_WAIT2: begin
			if(terminado) begin
				estado_siguiente <= CONTEO_WRITE2;
			end else begin
				estado_siguiente <= CONTEO_WAIT2;
			end
		end
		
		CONTEO_WRITE2: begin
			if(terminado) begin
				estado_siguiente <= CONTEO_WAIT3;
			end else begin
				estado_siguiente <= CONTEO_WRITE2;
			end
		end
		
		CONTEO_WAIT3: begin
			if(terminado) begin
				estado_siguiente <= CONTEO_WRITE3;
			end else begin 
				estado_siguiente <= CONTEO_WAIT3;
			end
		end
		
		CONTEO_WRITE3: begin
			if(terminado) begin
				estado_siguiente <= CONTEO_WAIT4;
			end else begin
				estado_siguiente <= CONTEO_WRITE3;
			end
		 end
		
		CONTEO_WAIT4: begin
			if(terminado) begin
				estado_siguiente <= CONTEO_WRITE4;
			end else begin 
				estado_siguiente <= CONTEO_WAIT4;
			end
		 end
		 
		CONTEO_WRITE4: begin
			if(terminado) begin
				estado_siguiente <= CONTEO_WAIT5;
			end else begin
				estado_siguiente <= CONTEO_WRITE4;
			end
		 end
		 
		CONTEO_WAIT5: begin
			if(terminado) begin
				estado_siguiente <= DONE;
			end else begin 
				estado_siguiente <= CONTEO_WAIT5;
			end
		 end
		DONE: begin
			estado_siguiente <= IDLE;
		end
	
	endcase

end
 
 
assign terminado  = ((estado_actual == CONTEO_WAIT1 && conteo== 32'd750_000) ||
							(estado_actual == CONTEO_WRITE1 && conteo ==  32'd12) ||
							(estado_actual == CONTEO_WAIT2 && conteo ==  32'd205_000)||
							(estado_actual == CONTEO_WRITE2 && conteo ==  32'd12)||
							(estado_actual == CONTEO_WAIT3 && conteo ==  32'd5000)||
							(estado_actual == CONTEO_WRITE3 && conteo ==  32'd12)||
							(estado_actual == CONTEO_WAIT4 && conteo ==  32'd2000)||
							(estado_actual == CONTEO_WRITE4 && conteo ==  32'd12)||
							(estado_actual == CONTEO_WAIT5 && conteo ==  32'd2000))? 1:0;
							
							
assign reset_conteo = (estado_actual == IDLE || terminado )?1:0; 
assign lcd_db[7] = 1'b0;
assign lcd_db[6] = 1'b0;
assign lcd_db[5] = ( estado_actual == CONTEO_WRITE1 || estado_actual == CONTEO_WRITE2 || estado_actual == CONTEO_WRITE3 || estado_actual == CONTEO_WRITE4 )?1:0;
assign lcd_db[4] = (estado_actual == CONTEO_WRITE1 || estado_actual == CONTEO_WRITE2 || estado_actual == CONTEO_WRITE3 )?1:0;
assign lcd_db[3] = (lcd_e )?1'b1:0;
assign lcd_db[2] = (lcd_e )?1'b1:0;
assign lcd_db[1] = (lcd_e )?1'b1:0;
assign lcd_db[0] = (lcd_e )?1'b1:0;


assign lcd_e =  (estado_actual == CONTEO_WRITE1 || 
						estado_actual == CONTEO_WRITE2 || 
						estado_actual == CONTEO_WRITE3 ||
						estado_actual == CONTEO_WRITE4 
						)? 1:0;
						
assign done = (estado_actual  == DONE)?1:0;

							




endmodule

