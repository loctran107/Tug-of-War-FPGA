//Control center light given left, right, neighboring left and right inputs.

module centerLight(clk, reset, L, R, NL, NR, lightOn);

	input logic L, R, NL, NR, clk, reset;
	output logic lightOn;
	
	enum {A, B} ps, ns; //2 states
	
	always_comb begin
		case(ps)
		
			A: if (L==0 && R==0 && NL==0 && NR==0) //Stay initially
			
					begin
						ns = A; //Turn on
					end
				
				//If inputs L and R are true, do nothing
				else if ((L==1 && R==1 && NL==0 && NR==0) || (L==1 && R==1 && NL==1 && NR==0) || (L==1 && R==1 && NL==0 && NR==1) || (L==1 && R==1 && NL==1 && NR==1))
					begin
						ns = A; 
					end
					
				else
					begin
						ns = B; //Otherwise, go to B state
					end
					
			B: if ((L==0 && R==1 && NL==1 && NR==0) || (L==1 && R==0 && NL==0 && NR==1)) //Return on state
					begin
						ns = A; 
					end
				
				else //Otherwise, stay at B
					begin
						ns = B; 
					end

		endcase
	end
	
	assign lightOn = (ps == A); //ouput light accordingly
			
	always_ff @(posedge clk) begin
		if (reset)
			begin
				ps <= A; 
			end
		else
			ps <= ns;
	end
endmodule

module centerLight_testbench();

	logic clk, reset, L, R, NL, NR, lightOn;
	centerLight dut(clk, reset, L, R, NL, NR, lightOn);
 
 // Set up the clock.
 
 parameter CLOCK_PERIOD=100;
 initial begin
 
	clk <= 0;
	forever #(CLOCK_PERIOD/2) clk <= ~clk;
 end
 
 // Set up the inputs to the design. Each line is a clock cycle.
 initial begin
					reset <= 1;														@(posedge clk);
														
					reset <= 0; L <= 0; R <= 0; NL <= 0; NR <= 0; 		@(posedge clk);
					L <= 1; R <= 1; NL <= 0; NR <= 1; 						@(posedge clk);
					L <= 1; R <= 1; NL <= 1; NR <= 1;						@(posedge clk);
					L <= 1; R <= 1; NL <= 0; NR <= 0;						@(posedge clk);
					L <= 0; R <= 1; NL <= 0; NR <= 0;						@(posedge clk);
																						@(posedge clk);
					L <= 1; R <= 0; NL <= 0; NR <= 1;						@(posedge clk);
																						@(posedge clk);
					L <= 1; R <= 0; NL <= 0; NR <= 1;						@(posedge clk);
					L <= 1; R <= 0; NL <= 0; NR <= 1;						@(posedge clk);
					
					L <= 1; R <= 1; NL <= 0; NR <= 0;						@(posedge clk);
																						@(posedge clk);
																						@(posedge clk);
																						@(posedge clk);
																						@(posedge clk);
																						@(posedge clk);
	$stop; // End the simulation.
 end
endmodule

	