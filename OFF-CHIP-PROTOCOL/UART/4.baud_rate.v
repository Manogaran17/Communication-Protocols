// Code your design here
// Code your design here
module baud_gen(
  input clk,
  output tx_en,rx_en
);
  
  reg[12:0]tx_counter=0;
  reg[9:0]rx_counter=0;
  
  always@(posedge clk )
    begin
      if(tx_counter==5208)
        tx_counter<=0;
      else
        tx_counter<=tx_counter+1;
    end 
  
  always@(posedge clk )
    begin
      if(rx_counter==325)
        rx_counter<=0;
      else
        rx_counter<=rx_counter+1;
      
    end
  assign tx_en = (tx_counter==0)?1:0;
  assign rx_en = (rx_counter==0)?1:0;
endmodule 
