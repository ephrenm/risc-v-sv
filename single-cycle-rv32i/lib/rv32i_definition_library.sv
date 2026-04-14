// R-Type: 0110011
// I-Type: 0010011
// S-Type: 0100011
// B-Type: 1100011
// U-Type: 0110111
// JAL:	   1101111
// JALR:   1100111
// LUI:	   0110111
// AUIPC:  0010111

package rv32i_definition_library;

	// OP Codes
	typedef enum logic [6:0] {
		OPCODE_R_TYPE 		= 7'b0110011,
		OPCODE_I_TYPE_ALU 	= 7'b0010011,
		OPCODE_I_TYPE_LOAD 	= 7'b0000011,
		OPCODE_S_TYPE		= 7'b0100011,
		OPCODE_B_TYPE		= 7'b1100011,
		OPCODE_JAL			= 7'b1101111,
		OPCODE_JALR			= 7'b1100111,
		OPCODE_LUI			= 7'b0110111,
		OPCODE_AUIPC		= 7'b0010111
	} opcode_typedef;
	
	// funct3 
	typedef enum logic [2:0] {
		// R-Type
		FUNCT3_ADD_SUB		= 3'b000, // ADD & SUB
		FUNCT3_SLLI			= 3'b001,
		FUNCT3_SLT 			= 3'b010,
		FUNCT3_SLTU			= 3'b011,
		FUNCT3_XOR			= 3'b100,
		FUNCT3_SR			= 3'b101, // SRL & SRA
		FUNCT3_OR			= 3'b110,
		FUNCT3_AND			= 3'b111,
		
		// I-Type ALU
		FUNCT3_ADDI 		= 3'b000,
		FUNCT3_SLLI			= 3'b001,
		FUNCT3_SLTI			= 3'b010,
		FUNCT3_SLTIU		= 3'b011,
		FUNCT3_XORI			= 3'b100,
		FUNCT3_SR			= 3'b101, // SRLI & SLAI
		FUNCT3_ORI			= 3'b110,
		FUNCT3_ANDI			= 3'b111,
		
		// I-Type LOAD
		FUNCT3_LB			= 3'b000,
		FUNCT3_LH			= 3'b001,
		FUNCT3_LW			= 3'b010,
		FUNCT3_LBU			= 3'b100,
		FUNCT3_LHU			= 3'b101,
		
		// S-Type
		FUNCT3_SB			= 3'b000,
		FUNCT3_SH			= 3'b001,
		FUNCT3_SW			= 3'b010,
		
		// B_Type
		FUNCT3_BEQ 			= 3'b000,
		FUNCT3_BNE			= 3'b001,
		FUNCT3_BLT			= 3'b100,
		FUNCT3_BGE			= 3'b101,
		FUNCT3_BLTU			= 3'b110,
		FUNCT3_BGEU			= 3'b111,
		
		// JALR	
		FUNCT3_JALR			= 3'b000
	} funct3_typedef;
	
	// funct7 
	typedef enum logic [6:0] {
		// R-Type
		FUNCT7_ADD			= 7'b0000000,
		FUNCT7_SUB			= 7'b0100000,
		FUNCT7_SLL			= 7'b0000000,
		FUNCT7_SLT			= 7'b0000000,
		FUNCT7_SLTU			= 7'b0000000,
		FUNCT7_XOR			= 7'b0000000,
		FUNCT7_SRL			= 7'b0000000,
		FUNCT7_SRA			= 7'b0100000,
		FUNCT7_OR			= 7'b0000000,
		FUNCT7_AND			= 7'b0000000,
		
		// I-Type
		FUNCT7_SLLI			= 7'b0000000,
		FUNCT7_SRLI			= 7'b0000000,
		FUNCT7_SRAI			= 7'b0100000
	} funct7_typedef;
	
	// ALU Control 
	typedef enum logic [3:0] {
		ALU_ADD 			= 4'b0000,
		ALU_SUB 			= 4'b0001,
		ALU_AND 			= 4'b0010,
		ALU_OR 				= 4'b0011,
		ALU_SLL 			= 4'b0100,
		ALU_SLT 			= 4'b0101,
		ALU_SRL 			= 4'b0110,
		ALU_SLTU 			= 4'b0111,
		ALU_XOR 			= 4'b1000,
		ALU_SRA 			= 4'b1001
	} alu_control_typedef;
	
endpackage
		
		
		