module alu_32bitunsigned(

  input [31:0]a,
  input [31:0]b,
  input [4:0]opcode,
  output reg [31:0]out,
  output carry_flag,
  output zero_flag
  
);
  
  wire [32:0]temp;
  assign temp = a+b;
  
  
  assign carry_flag = temp[32];
  assign zero_flag = (out==0);
  
  always@(*)
    begin
      case(opcode)
        
       // ARITHMETIC OPERATIONS
        
        5'd20:out=(a+b);  // ADDITION
        5'd1:out=(a-b);  // SUBSTRACTION
        5'd2:out=(a*b);  // MULTIPLICATION
        
       // BITWISE OPERATIONS
        
        5'd3:out=(a&b);  // BITWISE AND 
        5'd4:out=(a|b);  // BITWISE OR
        5'd5:out=~(a|b); // BITWISE NOR
        5'd6:out=~(a&b); // BITWISE NAND 
        5'd7:out=~a;     // BITWISE NOT
       
       // LOGICAL OPERATIONS
        
        5'd8:out=(a&&b); // LOGICAL AND 
        5'd9:out=(a||b); // LOGICAL OR
        5'd10:out=~(a||b); // LOGICAL NOR
        5'd11:out=~(a&&b); //LOGICAL NAND 
        5'd12:out=!a; // LOGICAL NOT 
        
        // SHIFT OPERATIONS
      
        5'd13:out={a[30:0],1'b0}; // LEFT SHIFT 
        5'd14:out={1'b0,a[31:1]}; // RIGHT SHIFT 
        
        // ROTATE OPERATIONS 
        
        5'd15:out={a[30:0],a[31]}; // LEFT ROTATE 
        5'd16:out={a[0],a[31:1]}; // RIGHT ROTATE
        
        // COMPARISON OPERATIONS 
        
        5'd17:out=(a==b); // EQUALITY 
        5'd18:out=(a<b); // LESS THAN
        5'd19:out=(a>b); // GREATER THAN 
        default:out=0;
        
      endcase 
    end 
  
endmodule 

