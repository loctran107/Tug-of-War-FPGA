
//Deal with the metastability case 
module dealWithMetastability(clk, reset, Din, Qout);
	input logic Din;
	input logic reset, clk;
	output logic Qout;
	logic temp;
	
	
	//Treatment to metastability
	always_ff @(posedge clk)
	
		begin if (reset)
			Qout <= 0;
		else begin
			temp <= Din;
			Qout <= temp;
		end
	end
endmodule

module dealWithMetastability_testbench();

	logic clk, reset, Din, Qout;
	dealWithMetastability dut(clk, reset, Din, Qout);
 
 // Set up the clock.
 
 parameter CLOCK_PERIOD=100;
 initial begin
 
	clk <= 0;
	forever #(CLOCK_PERIOD/2) clk <= ~clk;
 end
 
 // Set up the inputs to the design. Each line is a clock cycle.
 initial begin
					reset <= 1;														@(posedge clk);
														
					reset <= 0; Din <= 0; 								 		@(posedge clk);
																						@(posedge clk);
									Din <= 0;										@(posedge clk);
									Din <= 1;										@(posedge clk);
									Din <= 0;										@(posedge clk);
																						@(posedge clk);
																						
									Din <= 1;										@(posedge clk);
																						@(posedge clk);
																						@(posedge clk);
									
	$stop; // End the simulation.
 end
endmodule