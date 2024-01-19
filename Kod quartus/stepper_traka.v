module stepper_traka(clk, ON_belt, OFF_belt, motor_traka1);
    
	input clk;
	input ON_belt, OFF_belt;
  
	output[3:0] motor_traka1; 
	
	reg[3:0] motor_traka1; 
	reg[1:0] step1;
	reg[31:0] StepCounter = 32'b0;
	
	parameter[31:0] step_delay = 32'd90000;	//250HZ 32'd100000;
	
	reg ON_belt_press = 0;
	
	initial	  
	begin 
		step1 <= 3'b0;
		StepCounter <= 32'b0;
		motor_traka1 <= 4'b0000;
	end
	
	always @(posedge clk) 
	begin
	
		if(ON_belt == 1)
		begin 
			ON_belt_press = 1;
		end
	
	//-------------BESKONACNA VRTNJA TRAKE-------------
		if(ON_belt_press == 1)
			begin
			StepCounter <= StepCounter + 31'b1; 
					
			if (StepCounter >= step_delay)
			begin
				StepCounter <= 31'b0;
				step1 <= step1 - 1;
				
				//---------motor1---------
				case (step1) 
				0: motor_traka1 <= 4'b1100;
				1: motor_traka1 <= 4'b0110;
				2: motor_traka1 <= 4'b0011;
				3: motor_traka1 <= 4'b1001;						
				endcase 
			end	
		end
		
		if(OFF_belt == 1)
		begin
			ON_belt_press = 0;
			step1 <= 3'b0;
			StepCounter <= 32'b0;
			motor_traka1 <= 4'b0000;
			
		end
	
	end
endmodule 