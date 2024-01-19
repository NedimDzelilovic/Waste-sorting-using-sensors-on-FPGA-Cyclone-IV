module dc_motor (clk, ON_belt, OFF_belt, in1, in2, in3, in4, en_a, en_b);

input clk, ON_belt, OFF_belt;
output reg in1, in2, in3, in4; //pinovi za okretnje smjera
output reg en_a, en_b; // pin za kontrolu brzine

reg [7:0] counter1 = 0;
reg [7:0] counter2 = 0;

reg ON_belt_press = 0;

always@(posedge clk) 
begin

	if(ON_belt == 1)
	begin
		ON_belt_press = 1;
	end

	//---------PALJENJE TRAKE--------------
	if(ON_belt_press == 1 && OFF_belt == 0)
	begin
			if (counter1 < 50000000) 
			begin
				counter1<= counter1+1;
			end
			
			if (counter2 < 50000000) 
			begin
				counter2<= counter2+1;
			end
			
		in1 = 0;
		in2 = 1;
		in3 = 1;
		in4 = 0;
		en_a = (counter1 < 400) ? 1:0; //podesavanje brzine motora
		en_b = (counter2 < 400) ? 1:0;
	end
	
	//------------GASENJE TRAKE---------------
	if(OFF_belt == 1)
	begin
		ON_belt_press = 0;
		counter1 <= 0;
		in1 = 0;
		in2 = 0;
		in3 = 0;
		in4 = 0;
		en_a = 0;
		en_b = 0;
	end
end                   
endmodule
