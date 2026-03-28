module spi_slave(
  input sclk,
  input ss,
  input mosi,
  input rst,
  input [7:0]data_in,
  
  output reg miso,
  output reg [7:0]data_out
);
  reg[7:0]shift_reg;
  reg[3:0]bit_count;
  
  always@(posedge sclk or posedge rst)
    begin
      if(rst)
        begin
          shift_reg<=8'b0;
          bit_count<=4'd8;
          miso<=0;
        end 
      
      else if(ss==0)
        begin
          
          shift_reg<={shift_reg[6:0],mosi};
          
          miso<=shift_reg[7];
          bit_count<=bit_count-1;
          
          if(bit_count==0)
            begin
              data_out<=shift_reg;
              bit_count<=4'd8;
            end
        end 
    end
  endmodule 
