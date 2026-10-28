module top(clk, rst, result);
input clk, rst;
output [31:0] result;
assign result = ALU_result_top;

wire [31:0] PC_top, instruction_top, Read_data_1_top, Read_data_2_top;
wire [31:0] ImmExt_top, mux1_top, adder_out_top, NexttoPC_top;
wire [31:0] PC_in_top, ALU_result_top, MemData_out_top, WriteBack_top;
wire Reg_write_top, ALUSrc_top, zero_top, branch_top;
wire and_out_top, MemtoReg_top, MemWrite_top, MemRead_top;
wire [1:0] ALU_op_top;
wire [3:0] control_top;

program_counter PC(.clk(clk),.rst(rst),.pc_in(PC_in_top),.pc_out(PC_top));
PCplus4 PC_Adder(.fromPC(PC_top),.NexttoPC(NexttoPC_top));
Instruction_Mem Inst_Memory(.rst(rst),.read_address(PC_top),.instruction_out(instruction_top));
Reg_file Reg_File(.clk(clk),.rst(rst),.Reg_write(Reg_write_top),.Rs1(instruction_top[19:15]),.Rs2(instruction_top[24:20]),.Rd(instruction_top[11:7]),.Write_data(WriteBack_top),.read_data1(Read_data_1_top),.read_data2(Read_data_2_top));
ImmGen Imm_Gen(.opcode(instruction_top[6:0]),.instruction(instruction_top),.ImmExt(ImmExt_top));
Control_Unit Control_unit(.instruction(instruction_top[6:0]),.Branch(branch_top),.MemRead(MemRead_top),.MemtoReg(MemtoReg_top),.ALUOp(ALU_op_top),.MemWrite(MemWrite_top),.ALUSrc(ALUSrc_top),.RegWrite(Reg_write_top));
ALU_Control ALU_Control(.ALUOp(ALU_op_top),.fun7(instruction_top[30]),.fun3(instruction_top[14:12]),.Control_out(control_top));
ALU ALU(.A(Read_data_1_top),.B(mux1_top),.Control_in(control_top),.ALU_Result(ALU_result_top),.zero(zero_top));
Mux1 ALU_Mux(.sel1(ALUSrc_top),.A1(ImmExt_top),.B1(Read_data_2_top),.Mux1_out(mux1_top));
Adder Adder(.in_1(PC_top),.in_2(ImmExt_top),.adder_out(adder_out_top));
AND_logic AND(.branch(branch_top),.zero(zero_top),.and_out(and_out_top));
Mux2 And_select_mux(.sel2(and_out_top),.A2(adder_out_top),.B2(NexttoPC_top),.Mux2_out(PC_in_top));
Data_Memory Data_memory(.clk(clk),.rst(rst),.MemWrite(MemWrite_top),.MemRead(MemRead_top),.read_address(ALU_result_top),.Write_data(Read_data_2_top),.MemData_out(MemData_out_top));
Mux3 DM_out_mux(.sel3(MemtoReg_top),.A3(MemData_out_top),.B3(ALU_result_top),.Mux3_out(WriteBack_top));
endmodule

module program_counter(clk,rst,pc_in,pc_out);
input clk,rst;
input [31:0] pc_in;
output reg [31:0] pc_out;
always @(posedge clk or posedge rst) begin
    if(rst) pc_out <= 32'd0;
    else    pc_out <= pc_in;
end
endmodule

module PCplus4(fromPC,NexttoPC);
input  [31:0] fromPC;
output [31:0] NexttoPC;
assign NexttoPC = fromPC + 32'd4;
endmodule

module Instruction_Mem(rst,read_address,instruction_out);
input rst;
input [31:0] read_address;
output [31:0] instruction_out;
reg [31:0] I_Mem[0:63];
/* ROM initialised with a small RISC-V program so Yosys has
   real logic to synthesise instead of optimising everything away */
//integer i;
//always @(*) begin
    /* default all slots to NOP (addi x0,x0,0) */
    //for(i=0;i<64;i=i+1) I_Mem[i] = 32'h00000013;
//end
/* The actual program overwrites the first few slots combinationally
   using a priority mux – this IS synthesisable unlike 'initial' */
assign instruction_out = rst ? 32'b0 : (
    (read_address[31:2]==6'd0) ? 32'h00500093 : // addi x1,x0,5
    (read_address[31:2]==6'd1) ? 32'h00300113 : // addi x2,x0,3
    (read_address[31:2]==6'd2) ? 32'h002081B3 : // add  x3,x1,x2
    (read_address[31:2]==6'd3) ? 32'h403101B3 : // sub  x3,x2,x3
    (read_address[31:2]==6'd4) ? 32'h0020F1B3 : // and  x3,x1,x2
    (read_address[31:2]==6'd5) ? 32'h0020E1B3 : // or   x3,x1,x2
    (read_address[31:2]==6'd6) ? 32'h00208463 : // beq  x1,x2,+8
    32'h0000006F                                 // jal  x0,0  (loop)
);
endmodule

module Reg_file(clk,rst,Reg_write,Rs1,Rs2,Rd,Write_data,read_data1,read_data2);
input clk,rst,Reg_write;
input [4:0] Rs1,Rs2,Rd;
input [31:0] Write_data;
output [31:0] read_data1,read_data2;
integer k;
reg [31:0] Registers[0:31];
always @(posedge clk or posedge rst) begin
    if(rst) begin
        for(k=0;k<32;k=k+1) Registers[k] <= 32'd0;
    end else if(Reg_write)
        Registers[Rd] <= Write_data;
end
assign read_data1 = rst ? 32'b0 : Registers[Rs1];
assign read_data2 = rst ? 32'b0 : Registers[Rs2];
endmodule

module ImmGen(opcode,instruction,ImmExt);
input [6:0] opcode;
input [31:0] instruction;
output reg [31:0] ImmExt;
always @(*) begin
    case(opcode)
    7'b0010011: ImmExt = {{20{instruction[31]}},instruction[31:20]};
    7'b0000011: ImmExt = {{20{instruction[31]}},instruction[31:20]};
    7'b0100011: ImmExt = {{20{instruction[31]}},instruction[31:25],instruction[11:7]};
    7'b1100011: ImmExt = {{19{instruction[31]}},instruction[31],instruction[7],instruction[30:25],instruction[11:8],1'b0};
    7'b1101111: ImmExt = {{11{instruction[31]}},instruction[31],instruction[10:1],instruction[11],instruction[19:12],1'b0};
    default:    ImmExt = 32'b0;
    endcase
end
endmodule

module Control_Unit(instruction,Branch,MemRead,MemtoReg,ALUOp,MemWrite,ALUSrc,RegWrite);
input [6:0] instruction;
output reg Branch,MemRead,MemtoReg,MemWrite,ALUSrc,RegWrite;
output reg [1:0] ALUOp;
always @(*) begin
    case(instruction)
    7'b0110011: {ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUOp}=8'b00100010;
    7'b0010011: {ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUOp}=8'b10100010;
    7'b0000011: {ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUOp}=8'b11110000;
    7'b0100011: {ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUOp}=8'b11001000;
    7'b1100011: {ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUOp}=8'b01000101;
    7'b1101111: {ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUOp}=8'b10100100;
    default:    {ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUOp}=8'b0;
    endcase
end
endmodule

module ALU(A,B,Control_in,ALU_Result,zero);
input [31:0] A,B;
input [3:0] Control_in;
output reg zero;
output reg [31:0] ALU_Result;
always @(*) begin
    case(Control_in)
    4'b0000: begin ALU_Result=A&B; zero=1'b0; end
    4'b0001: begin ALU_Result=A|B; zero=1'b0; end
    4'b0010: begin ALU_Result=A+B; zero=1'b0; end
    4'b0110: begin ALU_Result=A-B; zero=(A==B)?1'b1:1'b0; end
    default: begin ALU_Result=32'b0; zero=1'b0; end
    endcase
end
endmodule

module ALU_Control(ALUOp,fun7,fun3,Control_out);
input fun7;
input [2:0] fun3;
input [1:0] ALUOp;
output reg [3:0] Control_out;
always @(*) begin
    case({ALUOp,fun7,fun3})
    6'b00_0_000: Control_out=4'b0010;
    6'b01_0_000: Control_out=4'b0110;
    6'b10_0_000: Control_out=4'b0010;
    6'b10_1_000: Control_out=4'b0110;
    6'b10_0_111: Control_out=4'b0000;
    6'b10_0_110: Control_out=4'b0001;
    default:     Control_out=4'b0000;
    endcase
end
endmodule

module Data_Memory(clk,rst,MemWrite,MemRead,read_address,Write_data,MemData_out);
input clk,rst,MemWrite,MemRead;
input [31:0] read_address,Write_data;
output [31:0] MemData_out;
reg [31:0] D_Memory[0:63];
integer k;
always @(posedge clk or posedge rst) begin
    if(rst) begin
        for(k=0;k<64;k=k+1) D_Memory[k] <= 32'd0;
    end else if(MemWrite)
        D_Memory[read_address[7:2]] <= Write_data;
end
assign MemData_out = MemRead ? D_Memory[read_address[7:2]] : 32'b0;
endmodule

module Mux1(sel1,A1,B1,Mux1_out);
input sel1;
input [31:0] A1,B1;
output [31:0] Mux1_out;
assign Mux1_out = sel1 ? A1 : B1;
endmodule

module Mux2(sel2,A2,B2,Mux2_out);
input sel2;
input [31:0] A2,B2;
output [31:0] Mux2_out;
assign Mux2_out = sel2 ? A2 : B2;
endmodule

module Mux3(sel3,A3,B3,Mux3_out);
input sel3;
input [31:0] A3,B3;
output [31:0] Mux3_out;
assign Mux3_out = sel3 ? A3 : B3;
endmodule

module AND_logic(branch,zero,and_out);
input branch,zero;
output and_out;
assign and_out = branch & zero;
endmodule

module Adder(in_1,in_2,adder_out);
input  [31:0] in_1,in_2;
output [31:0] adder_out;
assign adder_out = in_1 + in_2;
endmodule
