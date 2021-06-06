module projectCPU2021(
  clk,
  rst,
  wrEn,
  data_fromRAM,
  addr_toRAM,
  data_toRAM,
  PC,
  W
);

input clk, rst;

input wire [15:0] data_fromRAM;
output reg [15:0] data_toRAM;
output reg wrEn;

// 12 can be made smaller so that it fits in the FPGA
output reg [12:0] addr_toRAM;
output reg [12:0] PC; // This has been added as an output for TB purposes
output reg [15:0] W; // This has been added as an output for TB purposes

// Your design goes in here
reg [12:0] operand, operandNext;
reg [ 2:0] opcode, opcodeNext;
reg [ 2:0] state, stateNext;
reg [12:0] PCNext;
reg [15:0] WNext;

always @(posedge clk) begin
	state   <= #1 stateNext;
	PC      <= #1 PCNext;
	opcode  <= #1 opcodeNext;
	operand <= #1 operandNext;
	W       <= #1 WNext;
end

always @* begin
	stateNext   = state;
	PCNext      = PC;
	opcodeNext  = opcode;
	operandNext = operand;
	WNext       = 0;
	addr_toRAM  = 0;
	wrEn        = 0;
	data_toRAM  = 0;
	if(rst) begin
		stateNext   = 0;
		PCNext      = 0;
		opcodeNext  = 0;
		operandNext = 0;
		WNext       = 0;
		addr_toRAM  = 0;
		wrEn        = 0;
		data_toRAM  = 0;
	end else begin
		case(state)
			0: begin
				PCNext      = PC;
				opcodeNext  = opcode;
				operandNext = 0;
				addr_toRAM  = PC;
				wrEn        = 0; 
				data_toRAM  = 0;
				WNext       = W;
				stateNext   = 1;
			end
			1: begin
				PCNext      = PC;
				opcodeNext  = data_fromRAM[15:13];
				operandNext = data_fromRAM[12: 0];
				addr_toRAM  = data_fromRAM[12: 0];
				wrEn        = 0;
				data_toRAM  = 0;
				WNext       = W;
				case(opcodeNext)
					3'b000: stateNext = 2; // ADD
					3'b001: stateNext = 2; // NAND
					3'b010: stateNext = 2; // SRRL
					3'b011: stateNext = 2; // GE
					3'b100: stateNext = 2; // SZ
					3'b101: stateNext = 2; // CP2W
					3'b110: stateNext = 2; // CPfW
					3'b111: stateNext = 2; // JMP
				endcase
				if(data_fromRAM[12:0] == 0)
					stateNext = 3;
			end
			2: begin
				PCNext      = PC + 1;
				opcodeNext  = opcode;
				operandNext = operand;
				addr_toRAM  = operand;
				wrEn        = 1;
				WNext       = W;
				if(opcode == 3'b010) begin
					if(data_fromRAM < 16)
						WNext = W >> data_fromRAM;
					else if(data_fromRAM > 16 && data_fromRAM < 31)
						WNext = W << data_fromRAM[3:0];
					else if(data_fromRAM > 32 && data_fromRAM < 47)
						WNext = (W >> data_fromRAM[3:0] | W << (16 - data_fromRAM[3:0]));
					else 
						WNext = (W >> (16-data_fromRAM[3:0]) | W << data_fromRAM[3:0]);
				end
				if(opcode == 3'b100) begin
					if(data_fromRAM == 0) begin
						PCNext = PC + 2;
						wrEn   = 0;
					end
				end
				if(opcode == 3'b110) begin
					data_toRAM = W;
					addr_toRAM = operand;
				end
				if(opcode == 3'b111) begin
					PCNext = data_fromRAM;
					wrEn   = 0;
				end
				case(opcode)
					3'b000: WNext = W + data_fromRAM;
					3'b001: WNext = ~(W & data_fromRAM);
					3'b011: WNext = W >= data_fromRAM;
					3'b101: WNext = data_fromRAM;
				endcase
				stateNext = 0;
			end
			3: begin
				PCNext      = PC;
				opcodeNext  = opcode;
				operandNext = operand;
				addr_toRAM  = 2;
				WNext       = W;
				wrEn        = 0;
				stateNext   = 4;
			end
			4: begin
				PCNext      = PC;
				opcodeNext  = opcode;
				operandNext = data_fromRAM;
				addr_toRAM  = data_fromRAM;
				WNext       = W;
				wrEn        = 0;
				stateNext   = 2;
			end
			default: begin
				PCNext      = 0;
				opcodeNext  = 0;
				operandNext = 0;
				WNext       = 0;
				addr_toRAM  = 0;
				wrEn        = 0;
				data_toRAM  = 0;
				stateNext   = 0;
			end
		endcase
	end	
end

endmodule
