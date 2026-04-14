// Register File
//
// 

module register_file (

	input logic clk, rst,
	input logic [4:0] A1, A2, A3, 	// Addresses 1, 2 and 3
	input logic [31:0] WD3,			// Write data
	input logic WE3,				// Write enable
	
	output logic [31:0] RD1, RD2	// Read data
	
);

	logic [31:0] register [31:0];

	always_ff @ (posedge clk) begin
		
		register[5'd0] <= 32'b0; 	// Hard wire register[0] to equal zero
		
		if(rst == 1'b1) begin		// On positive reset signal, set all registers to zero
			for (int i = 0; i < 32; i++) begin
				register[i] <= 32'b0;
			end
		end else if (WE3) begin		// Write enable
			register[A3] <= WD3;
		end
	end
	
	always_comb begin
		RD1 = register[A1];
		RD2 = register[A2];
	end

endmodule