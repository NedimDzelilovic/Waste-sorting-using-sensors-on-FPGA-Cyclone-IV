	module main_module(clk,
								capacitive,
								inductive,
								photo,
								ON_belt,
								OFF_belt,
								in1,
								in2,
								in3,
								in4,
								en_a,
								en_b,
								motor_pregrada
								);
								
	input clk;
	input capacitive;
	input inductive;
	input photo;
	input ON_belt;
	input OFF_belt;
	
	output in1;
	output in2;
	output in3;
	output in4;
	output en_a;
	output en_b;
	output[3:0] motor_pregrada;		
		
	dc_motor start_belt(
		.clk(clk),
		.ON_belt(ON_belt),
		.OFF_belt(OFF_belt),
		.in1(in1),
		.in2(in2),
		.in3(in3),
		.in4(in4),
		.en_a(en_a),
		.en_b(en_b)
		);
	
	stepper start_ramp(
		.clk(clk),
		.capacitive(capacitive),
		.inductive(inductive),
		.photo(photo),
		.motor_pregrada(motor_pregrada)
		);

endmodule 