module stepper(clk, capacitive, inductive, photo, motor_pregrada);

	input clk;
	input capacitive, inductive, photo;
  
	output[3:0] motor_pregrada; 
     
	reg[3:0] motor_pregrada;
	reg[1:0] step1; 
	reg[31:0] StepCounter = 32'b0;
	reg temp = 0;
	reg temp1 = 0;
	reg temp2 = 0;
	
	reg capacitive_detect = 0;
	reg inductive_detect = 0;
	reg photo_detect = 0;
	
	parameter	[31:0] step_delay = 32'd150000;	//brzina posude
	parameter	[31:0] vrijeme_cekanja = 32'd100_000_000; //pauza za posudu
	parameter	input_angle = 300; //zeljezo, plastika
	parameter	input_angle1 = 1000; //staklo
	
	integer angle;
 
	initial	  
		begin 
			step1 <= 3'b0;
			StepCounter <= 32'b0;
			angle = 0;
			motor_pregrada <= 4'b0000;
		end
			  
    always @(posedge clk) 
    begin
		  
		  if(capacitive == 1'b0)
		  begin
		  capacitive_detect = 1;
		  end
		  
		  if(inductive == 1'b1)
		  begin
		  inductive_detect = 1;
		  end
		  
		  if(photo == 1'b1)
		  begin
		  photo_detect = 1;
		  end
		  
		  //---------------------SLUCAJ ZA METAL-------------------------------
		if(capacitive_detect == 1 && inductive_detect == 1 && photo_detect == 1)
		begin
			temp = 1'd1;
		end
		 
            
				if(temp == 1'd1)
				begin
				
            if (angle < (2*input_angle))
            begin
                StepCounter <= StepCounter + 31'b1; 
                        
                if (StepCounter >= step_delay)
                begin
                    StepCounter <= 32'b0;
                    
                    //--------POMIJERANJE POSUDE U JEDNOM SMIJERU--------
                    if (angle < input_angle) 
                    begin
                        step1 <= step1 + 1;
                        angle <= angle + 1;
                        
                        //---------motor---------
                        case (step1) 
                        0: motor_pregrada <= 4'b1100;
                        1: motor_pregrada <= 4'b0110;
                        2: motor_pregrada <= 4'b0011;
                        3: motor_pregrada <= 4'b1001;                        
                        endcase
                    end
                    
                    else if (angle == input_angle)
                    begin
								motor_pregrada <= 4'b0000;
								StepCounter <= StepCounter + 1'b1;
								
								//--------PAUZA DOK MATERIJAL SPADA U POSUDU--------
								if(StepCounter == vrijeme_cekanja)
								begin
								angle <= angle + 1;
								StepCounter <= 32'b0;
								end
                    end
						  
						  
                    //--------POMIJERANJE POSUDE U DRUGOM SMIJERU--------
                    else if ((angle > input_angle) && (angle < (2 * input_angle)))
                    begin
                        step1 <= step1 - 1;
                        angle <= angle + 1;
                        
                        //---------motor1---------
                        case (step1) 
                        0: motor_pregrada <= 4'b1100;
                        1: motor_pregrada <= 4'b0110;
                        2: motor_pregrada <= 4'b0011;
                        3: motor_pregrada <= 4'b1001;        
                        endcase 
                    end
                end
            end
            else if (angle >= (2*input_angle))
            begin
                motor_pregrada <= 4'b0000;
                angle <= 0;
                StepCounter <= 32'b0;
                temp = 1'd0;
					 capacitive_detect = 0;
					 inductive_detect = 0;
					 photo_detect = 0;
            end   	
			
			end
	
			  
      //---------------------SLUCAJ ZA PLASTIKU-------------------------------			  
	   if(capacitive_detect == 1 && inductive_detect == 0 && photo_detect == 1)
		begin
			temp1 = 1'd1;
		end
				if(temp1 == 1'd1)
				begin
				
            if (angle < (2*input_angle))
            begin
                StepCounter <= StepCounter + 31'b1; 
                        
                if (StepCounter >= step_delay)
                begin
                    StepCounter <= 32'b0;
                    
                    //--------POMIJERANJE POSUDE U JEDNOM SMIJERU--------
                    if (angle < input_angle) 
                    begin
                        step1 <= step1 - 1;
                        angle <= angle + 1;
                        
                        //---------motor---------
                        case (step1) 
                        0: motor_pregrada <= 4'b1100;
                        1: motor_pregrada <= 4'b0110;
                        2: motor_pregrada <= 4'b0011;
                        3: motor_pregrada <= 4'b1001;                        
                        endcase
                    end
                    
                    else if (angle == input_angle)
                    begin
								motor_pregrada <= 4'b0000;
								StepCounter <= StepCounter + 1'b1;
								
								//--------PAUZA DOK MATERIJAL SPADA U POSUDU--------
								if(StepCounter == vrijeme_cekanja)
								begin
								angle <= angle + 1;
								StepCounter <= 32'b0;
								end
                    end
						  
						  
                    //--------POMIJERANJE POSUDE U JEDNOM SMIJERU--------
                    else if ((angle > input_angle) && (angle < (2 * input_angle)))
                    begin
                        step1 <= step1 + 1;
                        angle <= angle + 1;
                        
                        //---------motor---------
                        case (step1) 
                        0: motor_pregrada <= 4'b1100;
                        1: motor_pregrada <= 4'b0110;
                        2: motor_pregrada <= 4'b0011;
                        3: motor_pregrada <= 4'b1001;        
                        endcase 
                    end
                end
            end
            else if (angle >= (2*input_angle))
            begin
                motor_pregrada <= 4'b0000;
                angle <= 0;
                StepCounter <= 32'b0;
                temp1 = 1'd0;
					 capacitive_detect = 0;
					 inductive_detect = 0;
					 photo_detect = 0;
            end   	
			
			end
	 
		//---------------------SLUCAJ ZA STAKLO-------------------------------
	   if(capacitive_detect == 1 && inductive_detect == 0 && photo_detect == 0)
		begin
			temp2 = 1'd1;
		end
				if(temp2 == 1'd1)
				begin
				
            if (angle < (2*input_angle1))
            begin
                StepCounter <= StepCounter + 31'b1; 
                        
                if (StepCounter >= step_delay)
                begin
                    StepCounter <= 32'b0;
                    
                    //--------POMIJERANJE POSUDE U JEDNOM SMIJERU--------
                    if (angle < input_angle1) 
                    begin
                        step1 <= step1 + 1;
                        angle <= angle + 1;
                        
                        //---------motor---------
                        case (step1) 
                        0: motor_pregrada <= 4'b1100;
                        1: motor_pregrada <= 4'b0110;
                        2: motor_pregrada <= 4'b0011;
                        3: motor_pregrada <= 4'b1001;                        
                        endcase
                    end
                    
                    else if (angle == input_angle1)
                    begin
								motor_pregrada <= 4'b0000;
								StepCounter <= StepCounter + 1'b1;
								
								//--------PAUZA DOK MATERIJAL SPADA U POSUDU--------
								if(StepCounter == vrijeme_cekanja)
								begin
								angle <= angle + 1;
								StepCounter <= 32'b0;
								end
                    end
						  
						  
                    //--------POMIJERANJE POSUDE U DRUGOM SMIJERU--------
                    else if ((angle > input_angle1) && (angle < (2 * input_angle1)))
                    begin
                        step1 <= step1 - 1;
                        angle <= angle + 1;
                        
                        //---------motor---------
                        case (step1) 
                        0: motor_pregrada <= 4'b1100;
                        1: motor_pregrada <= 4'b0110;
                        2: motor_pregrada <= 4'b0011;
                        3: motor_pregrada <= 4'b1001;        
                        endcase 
                    end
                end
            end
            else if (angle >= (2*input_angle1))
            begin
                motor_pregrada <= 4'b0000;
                angle <= 0;
                StepCounter <= 32'b0;
                temp2 = 1'd0;
					 capacitive_detect = 0;
					 inductive_detect = 0;
					 photo_detect = 0;
            end   	
			
			end
	 
	 end
endmodule
