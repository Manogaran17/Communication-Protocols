

module uart_tb(
            reg clk,
            reg  rst,
            reg  wr_en,
           
            reg parity_en,
            reg  odd_even-parity,
            reg [data_width-1:0]data_in,
            
            wire  busy,
            wire  done,
            wire  frame_error,
            wire  parity_error,
            wire  [data_width-1:0]data_out
);
  UART_top uart(clk,rst,wr_en,parity_en,odd_even_parity,data_in,busy,done,frame_error,parity_error,data_out);
  
  initial 
    begin
      clk=0;
      forever #5 clk=~clk;
    end 
  initial 
    begin
      rst=1;wr_en=0;parity_en=0;odd_even_parity=0;data_in=0;
      
      #10rst=0;wr_en=0;parity_en=1;odd_even_parity=1;data_in=8'hff;
      #1000$finish;
    end 
  initial 
    begin
      $dumpfile("uart.vcd");
      $dumpvars(1,uart_tb);
    end 
endmodule 
