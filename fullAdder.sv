module fullAdder(A, B, Cin, sum, Cout);

	input logic A, B, Cin;
	output logic sum, Cout;
	
	assign sum = A ^ B ^ Cin;
	assign Cout = A&B | Cin & (A^B);

endmodule

module fullAdder_testbench();

	logic A, B, Cin, sum, Cout;
	
	fullAdder dut (A, B, Cin, sum, Cout);
	
	integer i;
	initial begin
	
		for (i= 0; i < 2**3; i++) begin
		 {A, B, Cin} = i; #10;
		end //for loop
	end //initial

endmodule
	