module tb_apb;
  reg pclk;
  reg prst;
  reg transfer;
  reg pwrite_in;
  
  reg[31:0]write_data;
  reg[8:0]addr;
  
  wire[31:0]read_data;
  
  apb_top dut(
    .pclk(pclk),
    .prst(prst),
    .transfer(transfer),
    .pwrite_in(pwrite_in),
    .write_data(write_data),
    .addr(addr),
    .read_data(read_data)
  );
  
  initial 
    begin
      pclk=1;
      forever #5pclk=~pclk;
    end 
  
  initial 
    begin
     
      $monitor("Time=%0t | pwrite=%b | addr=%3d | write_data=%3d(%b) | read_data=%3d(%b)", 
               $time, pwrite_in, addr, write_data,write_data, read_data,read_data);

      prst=0;
      transfer=0;
      pwrite_in=0;
      addr=0;
      write_data=0;
      
      #20;
      
      prst=1;
      #20;
      
      
      // ARITHMETIC OPERATION: ADDITION (10 + 98 = 108)
     
      pwrite_in=1;
      addr=9'b000000000;
      write_data=10;
      transfer=1;
      #10;
      
      transfer=0;
      #40;
      
      pwrite_in=1;
      addr=9'b000000100;
      write_data=98;
      transfer=1;
      #10;
      
      transfer=0;
      #40;
      
      pwrite_in=1;
      addr=9'b000001000;
      write_data=20;     // Opcode 20 = ADD
      transfer=1;
      #10;
      
      transfer=0;
      #40;

      pwrite_in=0;
      addr=9'b000001100; // Read the Result
      transfer=1;
      #10;
      
      transfer=0;
      #40;
      
      // DISPLAY STATEMENT FOR ADDITION
      $display("== Final Result of Addition (10 + 98): %0d ==", read_data);
      
      
      // ARITHMETIC OPERATION: SUBTRACTION (200 - 98 = 102)
      
      pwrite_in=1;
      addr=9'b000000000;
      write_data=200;
      transfer=1;
      #10;
      
      transfer=0;
      #40;
      
      pwrite_in=1;
      addr=9'b000000100;
      write_data=98;
      transfer=1;
      #10;
      
      transfer=0;
      #40;
      
      pwrite_in=1;
      addr=9'b000001000;
      write_data=1;      // Opcode 1 = SUB
      transfer=1;
      #10;
      
      transfer=0;
      #40;

      pwrite_in=0;
      addr=9'b000001100; // Read the Result
      transfer=1;
      #10;
      
      transfer=0;
      #40;

      // DISPLAY STATEMENT FOR SUBTRACTION
      $display("== Final Result of Subtraction (200 - 98): %0d ==", read_data);

    
      // LOGICAL OPERATION: BITWISE AND (12 & 10 = 8)
     
      pwrite_in=1;
      addr=9'b000000000;
      write_data=12;
      transfer=1;
      #10;
      
      transfer=0;
      #40;
      
      pwrite_in=1;
      addr=9'b000000100;
      write_data=10;
      transfer=1;
      #10;
      
      transfer=0;
      #40;
      
      pwrite_in=1;
      addr=9'b000001000;
      write_data=3;      // Opcode 3 = AND
      transfer=1;
      #10;
      
      transfer=0;
      #40;

      pwrite_in=0;
      addr=9'b000001100; // Read the Result
      transfer=1;
      #10;
      
      transfer=0;
      #40;

      // DISPLAY STATEMENT FOR BITWISE AND
      $display("== Final Result of Bitwise AND (12 & 10): %0d==", read_data);

      // ARITHMETIC OPERATION: DIVISION (100 * 5 = 500)
    
      pwrite_in=1;
      addr=9'b000000000;
      write_data=8'd100;
      transfer=1;
      #10;
      
      transfer=0;
      #40;
      
      pwrite_in=1;
      addr=9'b000000100;
      write_data=8'd5;
      transfer=1;
      #10;
      
      transfer=0;
      #40;
      
      pwrite_in=1;
      addr=9'b000001000;
      write_data=2;     // Opcode 2 = mul (Added in ALU)
      transfer=1;
      #10;
      
      transfer=0;
      #40;

      pwrite_in=0;
      addr=9'b000001100; // Read the Result
      transfer=1;
      #10;
      
      transfer=0;
      #40;

      // DISPLAY STATEMENT FOR multiplication
      
      $display("==Final Result of Multiplication (100 * 5): %0d==", read_data);

     
      
       pwrite_in=1;
      addr=9'b000000000;
      write_data=234;     // Number to ROTATE
      transfer=1;
      #10;
      
      transfer=0;
      #40;
      
      pwrite_in=1;
      addr=9'b000000100;
      write_data=0;      // Operand B is ignored by the ALU for Shifts
      transfer=1;
      #10;
      
      transfer=0;
      #40;
      
      pwrite_in=1;
      addr=9'b000001000;
      write_data=16;     // Opcode 16 = RIGHT ROTATE
      transfer=1;
      #10;
      
      transfer=0;
      #40;

      pwrite_in=0;
      addr=9'b000001100; // Read the Result
      transfer=1;
      #10;
      
      transfer=0;
      #40;

      // DISPLAY STATEMENT FOR LEFT SHIFT
      
      $display("== Final Result of RIGHT ROTATE: %0d==", read_data);
      
      
      pwrite_in=1;
      addr=9'b000000000;
      write_data=255;
      transfer=1;
      #10;
      
      transfer=0;
      #40;
      
      pwrite_in=1;
      addr=9'b000000100;
      write_data=0;
      transfer=1;
      #10;
      
      transfer=0;
      #40;
      
      pwrite_in=1;
      addr=9'b000001000;
      write_data=4;      // Opcode 3 = AND
      transfer=1;
      #10;
      
      transfer=0;
      #40;

      pwrite_in=0;
      addr=9'b000001100; // Read the Result
      transfer=1;
      #10;
      
      transfer=0;
      #40;

      // DISPLAY STATEMENT FOR BITWISE OR
      $display("== Final Result of Bitwise or : %0d==", read_data);

      
      pwrite_in=1;
      addr=9'b000000000;
      write_data=245;
      transfer=1;
      #10;
      
      transfer=0;
      #40;
      
      pwrite_in=1;
      addr=9'b000000100;
      write_data=232;
      transfer=1;
      #10;
      
      transfer=0;
      #40;
      
      pwrite_in=1;
      addr=9'b000001000;
      write_data=5;      // Opcode 5 bitwise nor
      transfer=1;
      #10;
      
      transfer=0;
      #40;

      pwrite_in=0;
      addr=9'b000001100; // Read the Result
      transfer=1;
      #10;
      
      transfer=0;
      #80;

      // DISPLAY STATEMENT FOR BITWISE AND
      $display("== Final Result of Bitwise nor: %0d==", read_data);

      // ARITHMETIC OPERATI

      
      $finish;
      
    end 
  initial 
    begin
      $dumpfile("apb.vcd");
      $dumpvars(0,tb_apb);
    end 
endmodule


