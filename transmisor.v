module transmisor(
	input wire clk,
	input wire reset,
	input wire iniciar_envio,
	input wire [7:0]data,
	output wire y
	
);
	localparam IDLE =4'd0;
	localparam START_BIT =4'd1;
	localparam B0 =4'd2;
	localparam B1 =4'd3;
	localparam B2 =4'd4;
	localparam B3 =4'd5;
	localparam B4 =4'd6;
	localparam B5 =4'd7;
	localparam B6 =4'd8;
	localparam B7 =4'd9;
	localparam STOP_BIT = 4'd10;

	
	
	reg[3:0] estado_actual=IDLE, estado_siguiente;
	wire time_over,clk2 ;
	
	wire iniciar_envio2;
	wire [7:0]data2;
	
	registro proccess_init (
    .clk(clk), 
    .reset(estado_actual == STOP_BIT), 
    .enable(iniciar_envio), 
    .d(iniciar_envio), 
	 .q(iniciar_envio2),
	 .d2(data),   	 
    .q2(data2)
    );



	//instanciacion de modulos
	clk_transmisor pulso_lento(
		.clk(clk),
		.clk_115200(clk2));



	
	
	shiftreg_parallelin buffer_salida (
    .clk(clk2), 
    .reset(reset), 
    .load(estado_actual == IDLE), 
    .sin(1'd1), 
    .d(data2),   
    .sout(sout)
    );

	always@(posedge clk2,posedge reset) begin
		if(reset) begin 
			estado_actual <= IDLE;
		end else begin
			estado_actual <= estado_siguiente;
		end
	end


	always@(*) begin
		case(estado_actual)
			IDLE: begin
				if(iniciar_envio2) begin
					estado_siguiente <= START_BIT;
				end else begin
					estado_siguiente <= IDLE;
				end
			end
			START_BIT: begin
				if(time_over) begin
					estado_siguiente <= B0;
				end else begin
					estado_siguiente <= START_BIT;
				end
			end
			B0: begin
				if(time_over) begin
					estado_siguiente <= B1;
				end else begin
					estado_siguiente <= B0;
				end
			end
			B1: begin
				if(time_over) begin
					estado_siguiente <= B2;
				end else begin
					estado_siguiente <= B1;
				end
			end
			B2: begin
				if(time_over) begin
					estado_siguiente <= B3;
				end else begin
					estado_siguiente <= B2;
				end
			end
			B3: begin
				if(time_over) begin
					estado_siguiente <= B4;
				end else begin
					estado_siguiente <= B3;
				end
			end
			B4: begin
				if(time_over) begin
					estado_siguiente <= B5;
				end else begin
					estado_siguiente <= B4;
				end
			end
			B5: begin
				if(time_over) begin
					estado_siguiente <=B6;
				end else begin
					estado_siguiente <=B5;
				end
			end
			B6: begin 
				if(time_over) begin
					estado_siguiente <=B7;
				end else begin
					estado_siguiente <= B6;
				end
			end
			B7: begin
				if(time_over) begin
					estado_siguiente <= STOP_BIT;
				end else begin
					estado_siguiente <= B7;
				end
			end
			STOP_BIT: begin
				if(time_over) begin
					estado_siguiente <=IDLE;
				end else begin
					estado_siguiente <= STOP_BIT;
				end
			end
			default : begin

			end

	endcase
	end 
		
	 assign time_over =1;


		assign y = (			estado_actual == START_BIT ||
									estado_actual == B0 ||
									estado_actual == B1 ||
									estado_actual == B2 ||
									estado_actual == B3 ||
									estado_actual == B4 ||
									estado_actual == B5 ||
									estado_actual == B6 ||
									estado_actual == B7 ||
									estado_actual == STOP_BIT)  ? sout:1;
									
endmodule