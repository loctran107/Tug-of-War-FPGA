//Ouput the winner as HEX display

module victory(clk, reset, lmost, rmost, L, R, display);

	input logic clk, reset, lmost, rmost, L, R;
	output logic [6:0] display; 
	
	enum {A, B, C} ps, ns; //3 states
	
	always_comb begin
		case(ps)
		
			A: if (L==0 && R==0 && rmost==0 && lmost==0)
					begin
						ns = A;  display = 7'b1111111; //blank by default
					end
			   else if (L==1 && R==0 && lmost==1 && rmost==0)
					begin
						ns = B; display = 7'b0100100; //ouput player 2 wins
					end
				else if (L==0 && R==1 && lmost==0 && rmost==1)
					begin
						ns = C; display = 7'b1111001; //ouput player 1 wins
					end
					
				else begin
					ns = A; display = 7'b1111111; //blank by default (handle case when L and R are true)
					end
			B: begin 
					ns = B; display = 7'b0100100; //output player 2 wins
				end
			C: begin
					ns = C; 	display = 7'b1111001; //output player 1 wins
				end
		endcase
	end
	
	//Sequentail logic
	always_ff @(posedge clk) begin
		if (reset)
			begin
				ps <= A;
			end
		else
			ps <= ns;
	end
endmodule

module victory_testbench();

	logic clk, reset, L, R, lmost, rmost;
	logic [6:0] display;
	victory dut(clk, reset, lmost, rmost, L, R, display);
 
 // Set up the clock.
 
 parameter CLOCK_PERIOD=100;
 initial begin
 
	clk <= 0;
	forever #(CLOCK_PERIOD/2) clk <= ~clk;
 end
 
 // Set up the inputs to the design. Each line is a clock cycle.
 initial begin
																							@(posedge clk);
						reset <= 1;														@(posedge clk);
					 	reset <= 0; L <= 1; R<= 0; lmost <= 1; rmost<= 0; 	@(posedge clk);
																							@(posedge clk);
						R <= 1; L<= 1; lmost <= 0; rmost <= 0;					@(posedge clk);
																							@(posedge clk);
					   R <= 1; rmost <= 1; L <= 0; lmost <= 0; 				@(posedge clk);
																							@(posedge clk);
						L <= 0; lmost <= 0; rmost <= 1; R<= 1;					@(posedge clk);
																							@(posedge clk);
																							@(posedge clk);
				
	$stop; // End the simulation.
 end
endmodule