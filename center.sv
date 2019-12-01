module center(clk, reset, control, lightOn);

	input logic [3:0] control; //order L R NL NR
	input logic reset, clk;
	output logic lightOn;
	
	enum {A, B, C} ps, ns; //A stay, B left, C right
	
	always_comb begin
		case(ps)
		
			A: if (control == 4'b0000)  //stay 
			
					begin
						ns = A; lightOn = 1;
					end
				
				else if (control == 4'b01xx) //turn left
					begin
						ns = B; lightOn = 0;
					end
				else if (control == 4'b10xx) //turn right
					begin
						ns = C; lightOn = 0;
					end
					
				else
					begin
						ns = A; lightOn = 1;
					end
					
			B: if (control == 4'b0110) //go left
				begin
					ns = A; lightOn = 1;
				end
				
				else
					begin
						ns = B; lightOn = 0;
					end
			C: if (control == 4'b1001) //go right
				begin
					ns = A; lightOn = 1;
				end
				
				else
					begin
						ns = C; lightOn = 0;
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

module center_testbench();

	logic clk, reset, lightOn;
	logic [3:0] control;
	center dut(clk, reset, control, lightOn);
 
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
					control <= 4'b1000; 	@(posedge clk);
											 @(posedge clk);
					control <= 4'b0110; @(posedge clk);
												@(posedge clk);
																	@(posedge clk);
											@(posedge clk);
					control <= 4'b1010;						@(posedge clk);
											@(posedge clk);
					control <= 4'b1001;					@(posedge clk);
					
					reset <= 1;				@(posedge clk);
											@(posedge clk);
											@(posedge clk);
										@(posedge clk);
								         @(posedge clk);
											@(posedge clk);
	$stop; // End the simulation.
 end
endmodule

	