module decoder(
    input [31:0] instruction,
    output  [4:0] ra,
    output  [4:0] rb,
    output  [4:0] rd,

    output  [4:0] alu_opcode,
    output  [4:0] shiftamt,
    output  [31:0] immediate,
    output alu,
    output regwrite,
    output memwrite,
    output memtoreg,
    output [1:0] overflow);
    wire [4:0] opcode;
    wire is_r, is_addi, is_sw, is_lw;
    wire is_add, is_sub, is_and, is_or, is_sll, is_sra;
    wire [4:0]func;
    assign func = instruction[6:2];
    assign ra = instruction[21:17];
    assign rd = instruction[26:22];
    assign rt = instruction[16:12];
    assign opcode = instruction[31:27];
    assign is_sw = ~opcode[4] & ~opcode[3] & opcode[2] & opcode[1] & opcode[0];
    assign rb = is_sw ? instruction[26:22] : instruction[16:12];
    
    assign shiftamt = instruction[11:7];
    assign immediate = {{15{instruction[16]}} ,instruction[16:0]};

    assign is_r = ~opcode[4] & ~opcode[3] & ~opcode[2] & ~opcode[1] & ~opcode[0];
    assign is_addi = ~opcode[4] & ~opcode[3] & opcode[2] & ~opcode[1] & opcode[0];
    assign is_sw = ~opcode[4] & ~opcode[3] & opcode[2] & opcode[1] & opcode[0];
    assign is_lw = ~opcode[4] & opcode[3] & ~opcode[2] & ~opcode[1] & ~opcode[0];

    assign is_add = is_r & ~func[4] & ~func[3] & ~func[2] & ~func[1] & ~func[0];
    assign is_sub = is_r & ~func[4] & ~func[3] & ~func[2] & ~func[1] & func[0];
    assign is_and = is_r & ~func[4] & ~func[3] & ~func[2] & func[1] & ~func[0];
    assign is_or = is_r & ~func[4] & ~func[3] & ~func[2] & func[1] & func[0];
    assign is_sll = is_r & ~func[4] & ~func[3] & func[2] & ~func[1] & ~func[0];
    assign is_sra = is_r & ~func[4] & ~func[3] & func[2] & ~func[1] & func[0];
    wire valid_r;
    assign valid_r = is_add | is_sub | is_and | is_or | is_sll | is_sra;
    wire [4:0] add_opcode;
    assign add_opcode = 5'b00000;
    assign alu_opcode = is_r ? func:add_opcode;
    assign alu = is_addi | is_sw | is_lw;

    assign regwrite = is_addi | is_lw | valid_r;
    assign memwrite = is_sw;
    assign memtoreg = is_lw;
    assign overflow[0] = is_add | is_sub;
    assign overflow[1] = is_sub|is_addi;




endmodule