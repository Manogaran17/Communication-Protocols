// Code your design here
module apb_top(
    input pclk,
    input prst,
    input transfer,
    input pwrite_in,
    input [31:0]write_data,
    input [8:0]addr,
    output [31:0]read_data
);

    
    wire [31:0]pwdata,prdata;
    wire [8:0]paddr;
    wire [2:0]psel;
    wire penable,pwrite,pready;
    
   
    wire [31:0]prdata0,prdata1,prdata2;
    wire pready0,pready1,pready2;

   
    
    wire [31:0]s0_a,s0_b;
    wire [4:0]s0_op;
    
    wire [31:0]s1_a,s1_b;
    wire [4:0]s1_op;
    
    wire [31:0]s2_a,s2_b; 
    wire [4:0]s2_op;
    
    wire [31:0]alu_a,alu_b,alu_result;
    wire [4:0]alu_opcode;
    wire alu_carry,alu_zero;

 
    assign alu_a=(psel[0])?s0_a:
                       (psel[1])?s1_a:
                       (psel[2])?s2_a:32'd0;
                       
    assign alu_b=(psel[0])?s0_b:
                 (psel[1])?s1_b:
                 (psel[2])?s2_b:32'd0;
                       
    assign alu_opcode=(psel[0])?s0_op:
                      (psel[1])?s1_op:
                      (psel[2])?s2_op:5'd0;


    assign prdata=(psel[0])?prdata0:
      (psel[1])?prdata1:
      (psel[2])?prdata2:32'b0;
  
    assign pready=(psel[0])?pready0:
      (psel[1])?pready1:
      (psel[2])?pready2:1'b0;

    
    alu_32bitunsigned alu(
      .a(alu_a),
        .b(alu_b),
        .opcode(alu_opcode),
        .out(alu_result),
        .carry_flag(alu_carry),
        .zero_flag(alu_zero)
    );

    
    apb_master master(
      .pclk(pclk),
      .prst(prst),
      .transfer(transfer),
      .pready(pready),
      .pwrite_in(pwrite_in),
      .write_data(write_data),
      .prdata(prdata),
      .addr(addr),
      .penable(penable),
      .pwrite(pwrite),
      .pwdata(pwdata),
      .paddr(paddr),
      .psel(psel),
      .read_data(read_data)
    );

  
    apb_slave slave0(
      .pclk(pclk),
      .prst(prst),
      .psel(psel[0]),
      .penable(penable), 
      .pwrite(pwrite),
      .paddr(paddr),
      .pwdata(pwdata),
      .prdata(prdata0), 
      .pready(pready0),
      .out_a(s0_a),
      .out_b(s0_b),
      .out_opcode(s0_op),
      .alu_result(alu_result),
      .carry_flag(alu_carry),
      .zero_flag(alu_zero)
    );

   apb_slave slave1(
      .pclk(pclk),
      .prst(prst),
      .psel(psel[1]),
      .penable(penable), 
      .pwrite(pwrite),
      .paddr(paddr),
      .pwdata(pwdata),
      .prdata(prdata1), 
      .pready(pready1),
      .out_a(s1_a),
      .out_b(s1_b),
      .out_opcode(s1_op),
      .alu_result(alu_result),
      .carry_flag(alu_carry),
      .zero_flag(alu_zero)
    );


   apb_slave slave2(
      .pclk(pclk),
      .prst(prst),
     .psel(psel[2]),
      .penable(penable), 
      .pwrite(pwrite),
      .paddr(paddr),
      .pwdata(pwdata),
     .prdata(prdata2), 
     .pready(pready2),
     .out_a(s2_a),
     .out_b(s2_b),
     .out_opcode(s2_op),
      .alu_result(alu_result),
      .carry_flag(alu_carry),
      .zero_flag(alu_zero)
    );


endmodule
