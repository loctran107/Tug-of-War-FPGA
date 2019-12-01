//Top level module that connects all FSMs to produce desired behavior

module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);

	input logic CLOCK_50; //50 MHz clock
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	
	output logic [9:0] LEDR;
	
	input logic  [3:0] KEY; //True when not pressed, False when pressed
	input logic [9:0] SW;
	
	//Generate clk off of CLOCK_50, whichClock picks rate
	logic [31:0] clk;
	logic out1, out2, out3, out4; 
	assign HEX5 = 7'b1111111;
	assign HEX4 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	assign HEX2 = 7'b1111111;
	assign HEX1 = 7'b1111111;

	//Hook up FSM inputs and outputs
	
	//User input and Metastability treatment
	dealWithMetastability meta1(.clk(CLOCK_50), .reset(SW[9]), .Din(~KEY[0]), .Qout(out1)); //right
	userInput user1(.clk(CLOCK_50), .reset(SW[9]), .in(out1), .out(out3)); //right
	
	dealWithMetastability meta2(.clk(CLOCK_50), .reset(SW[9]), .Din(~KEY[3]), .Qout(out2)); //left
	userInput user2(.clk(CLOCK_50), .reset(SW[9]), .in(out2), .out(out4)); //left
	
	
	//Lights
	normalLight normal1(.clk(CLOCK_50), .reset(SW[9]), .L(out4), .R(out3), .NL(0), .NR(LEDR[8]), .lightOn(LEDR[9])); //left most light
	normalLight normal2(.clk(CLOCK_50), .reset(SW[9]), .L(out4), .R(out3), .NL(LEDR[9]), .NR(LEDR[7]), .lightOn(LEDR[8]));
	normalLight normal3(.clk(CLOCK_50), .reset(SW[9]), .L(out4), .R(out3), .NL(LEDR[8]), .NR(LEDR[6]), .lightOn(LEDR[7])); 
	normalLight normal4(.clk(CLOCK_50), .reset(SW[9]), .L(out4), .R(out3), .NL(LEDR[7]), .NR(LEDR[5]), .lightOn(LEDR[6])); 
	
	centerLight center(.clk(CLOCK_50), .reset(SW[9]), .L(out4), .R(out3),. NL(LEDR[6]), .NR(LEDR[4]), .lightOn(LEDR[5]));
	
	normalLight normal5(.clk(CLOCK_50), .reset(SW[9]), .L(out4), .R(out3), .NL(LEDR[5]), .NR(LEDR[3]), .lightOn(LEDR[4]));
	normalLight normal6(.clk(CLOCK_50), .reset(SW[9]), .L(out4), .R(out3), .NL(LEDR[4]), .NR(LEDR[2]), .lightOn(LEDR[3]));
	normalLight normal7(.clk(CLOCK_50), .reset(SW[9]), .L(out4), .R(out3), .NL(LEDR[3]), .NR(LEDR[1]), .lightOn(LEDR[2]));
	normalLight normal8(.clk(CLOCK_50), .reset(SW[9]), .L(out4), .R(out3), .NL(LEDR[2]), .NR(0), .lightOn(LEDR[1])); //right most light
	
	//Determining the victor
	victory victor(.clk(CLOCK_50), .reset(SW[9]), .L(out4), .R(out3), .lmost(LEDR[9]), .rmost(LEDR[1]), .display(HEX0)); //Display HEX winner

endmodule

module DE1_SoC_testbench();
	logic CLOCK_50;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;
	
	DE1_SoC dut (.CLOCK_50, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW);

	integer i;
	initial begin
//	SW[9] = 1'b0;
//	SW[8] = 1'b0;
	for (i=0; i < 2**9; i++) begin
		SW[9:0] = i; #10;
	end
end

endmodule



