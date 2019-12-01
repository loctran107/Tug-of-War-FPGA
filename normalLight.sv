//Control the normal light

module normalLight(clk, reset, L, R, NL, NR, lightOn);

	input logic L, R, NL, NR, clk, reset;
	output logic lightOn;
	
	enum {A, B} ps, ns; //2 state
	
	always_comb begin
		case(ps)
		
			A: if (L == 0 && R == 0 && NL == 0 && NR == 0) 
			
					begin 
						ns = A; //Stay off 
					end
				else if ((L==1 && R== 0 && NL==0 && NR== 1) || (L==0 && R==1 && NL==1 && NR==0)) 
					begin
						ns = B; //get to the next state and turn on
					end
					
				else
					begin
						ns = A; //otherwise, stay off
					end
				
				//Return to off state when L or R is pressed, NL and NR do not matter
			B: if ((L==1 && R==0 && NL == 0 && NR == 0)||(L==1 && R==0 && NL==0  && NR==1)||(L==1 && R==0 && NL==1  && NR==0)||(L==1 && R==0 && NL==1  && NR==1)
					|| (L==0 && R==1 && NL == 0 && NR == 0)||(L==0 && R==1 && NL==0  && NR==1)||(L==0 && R==1 && NL==1  && NR==0)||(L==0 && R==1 && NL==1  && NR==1))
					begin
						ns = A; //Return to off state
					end
				
				else
					begin
						ns = B; //stay at on state
					end
		endcase
	end
	
	assign lightOn = (ps != A); //ouput light accordingly
	always_ff @(posedge clk) begin
		if (reset)
			begin
				ps <= A;
			end
		else
			ps <= ns;
	end
endmodule

module normalLight_testbench();

	logic clk, reset, L, R, NL, NR, lightOn;
	normalLight dut(clk, reset, L, R, NL, NR, lightOn);
 
 // Set up the clock.
 
 parameter CLOCK_PERIOD=100;
 initial begin
 
	clk <= 0;
	forever #(CLOCK_PERIOD/2) clk <= ~clk;
 end
 
 // Set up the inputs to the design. Each line is a clock cycle.
 initial begin
																					@(posedge clk);
					reset <= 1;													@(posedge clk);
					reset <= 0; L <= 0; R <= 0; NL <= 0; NR <= 0; 	@(posedge clk);
									L <= 1; R <= 0; NL <= 1; NR <= 0;	@(posedge clk);
																					@(posedge clk);
					L <= 1; R <= 0; NL <= 0; NR <= 1;					@(posedge clk);
																					@(posedge clk);
																					@(posedge clk);
					L <= 0; R <= 1; NL <= 1; NR <= 0;					@(posedge clk);
																					@(posedge clk);
					L <= 0; R <= 1; NL <= 0; NR <= 1;					@(posedge clk);
																					@(posedge clk);
																					@(posedge clk);
	$stop; // End the simulation.
 end
endmodule


	