module PS2_Interface(inclock, resetn, ps2_clock, ps2_data, ps2_key_data, ps2_key_pressed, last_data_received,scan_out,ps2_out);

	input 			inclock, resetn;
	inout 			ps2_clock, ps2_data;
	output 			ps2_key_pressed;
	output 	[7:0] 	ps2_key_data;
	output 	[7:0] 	last_data_received;
	output  [7:0] 	scan_out;
	output  reg [7:0] 	ps2_out;

	// Internal Registers
	reg			[7:0]	last_data_received;	
	assign scan_out = last_data_received;
	always @(posedge inclock)
	begin
		if (resetn == 1'b0)
			last_data_received <= 8'h00;
		else if (ps2_key_pressed == 1'b1)
			last_data_received <= ps2_key_data;
	end
	always @(*)
	begin
		case(scan_out)
			8'hXX:
				ps2_out = 8'h11;
			8'hYY:
				ps2_out = 8'h22;
			8'hZZ:
				ps2_out = 8'h33;
			8'hAA:
				ps2_out = 8'h44;	
			default:
				ps2_out = 8'h00;//input need to be defined with actual received data 
		endcase
	end
	

	PS2_Controller PS2 (.CLOCK_50 			(inclock),
						.reset 				(~resetn),
						.PS2_CLK			(ps2_clock),
						.PS2_DAT			(ps2_data),		
						.received_data		(ps2_key_data),
						.received_data_en	(ps2_key_pressed)
						);

endmodule
