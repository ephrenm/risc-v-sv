//ALU

module ALU (

	input logic [31:0] 	A, B,
	input logic	[3:0]	control,
	
	output logic [31:0] result,
	output logic 		zero,
	output logic		negative,
	output logic		overflow,
	output logic		carry	

);

	

	always_comb begin
	
		result = 32'd0;
	
		case (control) begin
		
			ALU_ADD: result = A + B;
			ALU_SUB: result = A - B;
			ALU_AND: result = A & B;
			ALU_OR: result = A | B;
			ALU_XOR: result = A ^ B;
			ALU_SLL: result = A << B[4:0];
			ALU_SRL: result = A >> B[4:0];
			ALU_SRA: result = A >>> B[4:0];
			ALU_SLT: result = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0;
			ALU_SLTU: result = (A < B) ? 32'd1 : 32'd0;
			
	end

endmodule