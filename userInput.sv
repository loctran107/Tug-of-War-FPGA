module userInput(clk, reset, in, out);
	input logic clk, reset, in;
	output logic out;
	
	enum {A, B} ps, ns;
	
	always_comb begin 
		case(ps)
			A : if (in)
				begin
					ns = B; out = 0;
				end
				
				else
				
					begin
						ns = A; out = 0;
					end
		
			B : if (in)
				begin
					ns = B; out = 0;
				end
				
				else
					begin 
						ns = A; out = 1;
					end
				
		endcase
	end
	
	//DFF
	
	always_ff @(posedge clk) begin
		if (reset)
			ps <= A;
		else
			ps <= ns;
	end
	
endmodule

module userInput_testbench();

	logic clk, reset, in;
	logic out;
	
	
	userInput dut (clk, reset, in, out);
 
 
 // Set up the clock.
 
 parameter CLOCK_PERIOD= 100;
 initial begin
 
	clk <= 0;
	forever #(CLOCK_PERIOD/2) clk <= ~clk;
 end
 
 // Set up the inputs to the design. Each line is a clock cycle.
 initial begin
											@(posedge clk);
	reset <= 1; 						@(posedge clk);
	reset <= 0; in <= 1; 			@(posedge clk);
											@(posedge clk);
					in <= 0; 			@(posedge clk);
											@(posedge clk);
					in <= 1; 			@(posedge clk);
											@(posedge clk);
											@(posedge clk);
					in <= 0;				@(posedge clk);
											@(posedge clk);
					in <= 1;				@(posedge clk);
											@(posedge clk);
											@(posedge clk);
											@(posedge clk);
					in <= 0;			   @(posedge clk);
	$stop; // End the simulation.
	end
endmodule