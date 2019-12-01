module victory(L, R, NL, NR, lightOn);

	input logic clk, reset, L, R, NL, NR;
	output logic lightOn;
	
	enum {A, B, C} ps, ns;
	
	always_comb begin
		case(ps)
		
			A: if (!L && !R && !NL && !NR) 
			
					begin
						ns = A; lightOn = 0;
					end
				
				
			
		endcase
	end
			
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
											@(posedge clk);
											@(posedge clk);
					L <= 1; R <= 0; NL <= 0; NR <= 1; 	@(posedge clk);
											@(posedge clk);
											@(posedge clk);
					L <= 1; R <= 0; NL <= 1; NR <= 0;	@(posedge clk);
																	@(posedge clk);
											@(posedge clk);
					L <= 0; R <= 1; NL <= 1; NR <= 0;						@(posedge clk);
											@(posedge clk);
					L <= 0; R <= 1; NL <= 0; NR <= 1;						@(posedge clk);
					
					L <= 1; R <= 1; NL <= 0; NR <= 0;						@(posedge clk);
											@(posedge clk);
											@(posedge clk);
					reset <= 0;						@(posedge clk);
								         @(posedge clk);
											@(posedge clk);
	$stop; // End the simulation.
 end
endmodule