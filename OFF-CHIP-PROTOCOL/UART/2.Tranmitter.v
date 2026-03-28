
module transmitter #(parameter data_width =8)(
  
  input clk,rst,wr_en,tx_en,parity_en,
  input [7:0] data_in,
  input odd_even_parity,
  output reg tx,
  output busy 
);
  
  reg[2:0]data_count;
  reg[7:0]data_reg;
  reg parity_bit;
  
  parameter [2:0] idle=0, start=1,data=2,parity=3,stop=4;
  
  reg[2:0]state;
  
  always@(posedge clk or posedge rst)
    begin
      if(rst)begin
        tx<=1;
        busy<=0;
        state<=idle;
        data_count=0;
      end 
      
      else begin
        case(state)
          
          idle:begin
            tx<=1;
            if(wr_en)begin
              data_reg<=data_in;
              state<=start;
              parity_bit<=(odd_even_parity)?(^data_reg):(~(^data_reg));
            end 
          end
          
          start:
            begin
              tx<=0;
              if(tx_en)begin
                state<=data;
                data_count<=0;
                tx<=0;
              end 
            end 
          
          data:begin
            if(tx_en)begin
              tx<=data_reg[data_count];
              if(data_count==7)begin
                data_count=0;
                state<=parity_en?parity:stop;
              end 
              else 
                data_count<=data_count+1;
            end 
          end 
          
          parity:begin
            if(tx_en) begin
              tx<=parity_bit;
              state<=stop;
            end 
          end 
          
          stop:begin
            if(tx_en)begin
              tx<=1;
              state<=idle;
            end 
          end 
          end 
          end 
      
          assign busy = (state!=idle);
          endmodule 
  
