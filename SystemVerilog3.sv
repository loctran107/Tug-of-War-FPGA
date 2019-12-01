module centerLight(clk, reset, L, R, NL, NR, lightOn);

	input logic clk, reset, L, R, NL, NR;
	output logic lightOn
	
	enum {A, B, C} ps, ns;
	
	always_comb 
		case(ps)
		
		A: if (L == 0 && R == 0 && NL == 0 && NR == 0) lightOn = 1;
			
			else if (L == 1 && R == 0 && NL == 0 && NR == 1)
				begin
					