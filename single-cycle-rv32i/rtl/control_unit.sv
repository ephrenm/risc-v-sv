//Control 

import rv32i_definition_library::*;

module control_unit (

	input logic [6:0] 	opcode, 
	input logic [6:0] 	funct7,
	input logic [2:0] 	funct3,
	input logic			alu_zero,
	input logic			alu_negative,
	input logic			alu_carry,
	input logic			alu_overflow,
	
	output logic 		pc_source, 			// source select for program counter, 0:pc+4, 1:pc_target
	output logic		mem_write,			// data memory write enable
	output logic		alu_source,			// source select for alu, 0:RD2, 1:imm_ext
	output logic		reg_write,			// register file write enable
	output logic [2:0]  write_data_source,	// source select for register file write data, 000: alu_result, 001: read_data, 010:pc+4, 011:imm_ext, 100:pc_target
	output logic [2:0]  imm_source,			// source select for zero extender, 000:I-Type, 001:S-Type, 010:U-Type, 011:B-Type, 100:J-Type
	output logic [3:0]  alu_control			// alu control signal

);

	logic [1:0] alu_op;
	logic branch, jump, branch_good;

	assign pc_source = jump | branch_good;

	//branch condition check
	always_comb begin
	
		branch_good = 1'b0;
	
		if (branch) begin
		
			case (funct3)
			
				FUNCT3_BEQ: branch_good = (alu_zero) ? 1'b1 : 1'b0;
				FUNCT3_BNE: branch_good = (~alu_zero) ? 1'b1 : 1'b0;
				FUNCT3_BLT: branch_good = (alu_negative != alu_overflow) ? 1'b1 : 1'b0;
				FUNCT3_BGE: branch_good = (alu_negative == alu_overflow) ? 1'b1 : 1'b0;
				FUNCT3_BLTU: branch_good = (~alu_carry) ? 1'b1 : 1'b0;
				FUNCT3_BGEU: branch_good = (alu_carry) ? 1'b1 : 1'b0;
			
			endcase
			
		end
	
	end

	// main decoder
	always_comb begin
		mem_write = 1'b0;		
		alu_source = 1'b0;		
		reg_write = 1'b0;
		write_data_source = 3'b000;
		imm_source = 3'b000;
		alu_op = 2'b00;
		branch 	= 1'b0;
		jump = 1'b0;		
	
		case (opcode) 
		
			OPCODE_R_TYPE: 	begin
				
				branch = 1'b0;
				mem_write = 1'b0;		
				alu_source = 1'b0;		
				reg_write = 1'b1;
				write_data_source = 3'b000;
				alu_op = 2'b10;
				
			end
			
			OPCODE_I_TYPE_ALU: begin
			
				branch = 1'b0;
				mem_write = 1'b0;		
				alu_source = 1'b1;		
				reg_write = 1'b1;
				write_data_source = 3'b000;
				imm_source = 3'b000;
				alu_op = 2'b10;
				
			end
			
			OPCODE_I_TYPE_LOAD: begin
			
				branch = 1'b0;
				mem_write = 1'b0;		
				alu_source = 1'b1;		
				reg_write = 1'b1;
				write_data_source = 3'b001;
				imm_source = 3'b000;
				alu_op = 2'b00;
				
			end
			
			OPCODE_S_TYPE: begin
			
				branch = 1'b0;
				mem_write = 1'b1;		
				alu_source = 1'b1;		
				reg_write = 1'b0;
				write_data_source = 3'b000;
				imm_source = 3'b001;
				alu_op = 2'b00;
				
			end
			
			OPCODE_B_TYPE: begin
			
				branch = 1'b1;
				mem_write = 1'b0;		
				alu_source = 1'b0;		
				reg_write = 1'b0;
				write_data_source = 3'b000;
				imm_source = 3'b011;
				alu_op = 2'b01;
				
			end
			
			OPCODE_JAL: begin
			
				jump = 1'b1;
				mem_write = 1'b0;		
				alu_source = 1'b0;		
				reg_write = 1'b1;
				write_data_source = 3'b010;
				imm_source = 3'b100;
				
			end
			
			OPCODE_JALR: begin
			
				jump = 1'b1;
				mem_write = 1'b0;		
				alu_source = 1'b1;		
				reg_write = 1'b1;
				write_data_source = 3'b010;
				imm_source = 3'b000;
				alu_op = 2'b00;
				
			end
			
			OPCODE_LUI: begin
			
				branch = 1'b0;
				mem_write = 1'b0;		
				alu_source = 1'b0;		
				reg_write = 1'b1;
				write_data_source = 3'b011;
				imm_source = 3'b010;
				
			end
			
			OPCODE_AUIPC: begin
			
				branch = 1'b0;
				mem_write = 1'b0;		
				alu_source = 1'b0;		
				reg_write = 1'b1;
				write_data_source = 3'b100;
				imm_source = 3'b010;
				
			end
			
			default: begin
				mem_write = 1'b0;
				reg_write = 1'b0;
				jump = 1'b0;
				branch = 1'b0;
			end
		
		endcase
	
	end

	// alu decoder
	always_comb begin
	
		alu_control = 4'b0000; 
		
		case (alu_op)
	
			2'b00: begin
				alu_control = ALU_ADD;
			end
			
			2'b01: begin
				alu_control = ALU_SUB;
			end
			
			2'b10: begin
				
				case (funct3)
				
					FUNCT3_ADD_SUB: begin
						if (opcode[5]) begin
							if (funct7[5]) begin
								alu_control = ALU_SUB;
							end else begin
								alu_control = ALU_ADD;
							end
						end else begin
							alu_control = ALU_ADD;
						end
					end
					
					FUNCT3_AND: begin
						alu_control = ALU_AND;
					end
					
					FUNCT3_OR: begin
						alu_control = ALU_OR;
					end
					
					FUNCT3_XOR: begin
						alu_control = ALU_XOR;
					end
					
					FUNCT3_SLL: begin
						alu_control = ALU_SLL;
					end
					
					FUNCT3_SLT: begin
						alu_control = ALU_SLT;
					end
					
					FUNCT3_SLTU: begin
						alu_control = ALU_SLTU;
					end
					
					FUNCT3_SR: begin
						if (funct7[5]) begin
							alu_control = ALU_SRA;
						end else begin
							alu_control = ALU_SRL;
						end
					end
			
				endcase
				
			end
		
		endcase
		
	end
	
endmodule