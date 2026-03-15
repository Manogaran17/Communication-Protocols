// Code your design here
module baud_gen(
  input clk,
  output tx_en,rx_en
);
  
  reg[12:0]tx_counter;
  reg[9:0]rx_counter;
  
  always@(posegde clk )
    begin
      if(tx_counter==5208)
        tx_count=0;
      else
        tx_counter=tx_counter+1;
    end 
  
  always@(posegde clk )
    begin
      if(rx_counter==325)
        rx_count=0;
      else
        rx_counter=rx_counter+1;
      
    end
  assign tx_en = (tx_counter==0)?1:0;
  assign rx_en = (rx_counter==0)?1:0;
endmodule 

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
  
  parameter [2:0] idle=0, start = 1,data=2,parity=3,stop=4;
  
  reg[2:0]state;
  
  always@(posedge clk or posedge rst)
    begin
      if(rst)begin
        tx<=1;
        busy<=0;
        state<=idle;
      end 
      
      else begin
        case(state)
          
          idle:begin
            tx<=1;
            if(wr_en)begin
              data_reg<=data_in;
              state<=start;
              parity_bit<=(odd_even_parity)?(^data):(~(^data));
            end 
          end
          
          start:
            begin
              tx<=1;
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
          assign busy = (state!=idle);
          endmodule 
          
          
          module receiver #(parameter data_width = 8)(
            input clk,rst,rx,rx_en,parity_en,odd_even_parity;
            output reg done,frame_error,parity_error,
            output reg[7:0] data_out
          );
            
            localparam data_count_width = $clog2(data_width);
            reg[data_count_width-1:0]data_count;
            reg[data_width-1:0]data_reg;
            reg[data_count_width:0]sample;
            
            parameter [2:0] idle=0,start=1,data=2,parity=3,stop=4;
            
            reg[2:0]state;
            
            always@(posedge clk or posedge rst)begin
              if(rst)begin
                state<=idle;
                frame_error<=0;
                parity_error<=0;
                data_out<=0;
                sample<=0;
                done<=0;
                
              end 
              
              else if(rx_en)begin
                done<=0;
                case(state)
                  
                  idle:begin
                    frame_error<=0;
                    parity_error<=0;
                    data_out<=0;
                    sample<=0;
                    if(rx==0)begin
                      state<=start;
                    end 
                  end
                  
                  start:begin
                    if(sample==7)begin
                      if(rx==0)begin
                        state<=data;
                        sample<=0;
                        data_count<=0;
                      end 
                      else begin
                        state<=idle;
                      end 
                    end
                    else begin
                      sample<= sample+1;
                    end 
                  end 
                  
                  data:begin
                    if(sample==15)begin
                      data_reg[data_count]<=rx;
                      sample<=0;
                      if(data_count==data_width-1)begin
                        data_count<=0;
                        state<=parity_en?parity:stop;
                      end 
                      else begin
                        data_count<=data_count+1;
                      end 
                    end 
                    else begin
                      sample <=sample+1;
                    end 
                  end 
                  
                  parity:begin
                    if(sample ==15)begin
                      state<=stop;
                      sample<=0;
                      parity_error<=(odd_even_parity)?(^data_reg!=rx):(~(^data_reg!=rx));
                    end 
                    else begin
                      sample<=sample+1;
                    end 
                  end 
                  stop:
                    begin
                      if(sample==15)begin
                        if(rx==1)begin
                          done<=1;
                          data_out<=data_reg;
                          sample<=0;
                          state<=idle;
                        end
                        else begin
                          frame_error<=(rx!=1);
                        end
                      end 
                      else begin
                        smaple<=sample+1;
                      end 
                    end 
                  default:state<=idle;
                endcase
              end
            end
          endmodule 
          
          module UART_top(
          input clk,
          input rst,
            input wr_en,
            input rx,
            input parity_en,
            input odd_even-parity,
            input [data_width-1:0]data_in,
            
            output tx,
            output busy,
            output done,
            output frame_error,
            output parity_error,
            output [data_width-1:0]data_out
          );
            
            wire tx_en;
            wire rx_en;
            
            baud_gen baud(
              .clk(clk),
              .tx_en(tx_en),
              .rx_en(rx_en)
            );
            
            transmitter #(.data_width(data_width))transmit(
              .clk(clk),
              .rst(rst),
              .wr_en(wr_en),
              .tx_en(tx_en),
              .parity_en(parity_en),
              .odd_even_parity(odd_even_parity),
              .data_in(data_in),
              .tx(tx),
              .busy(busy)
            );
            
            receiver #(.data_width(data_width)) receive(
              .clk(clk),
              .rst(rst),
              .rx(rx),
              .rx_en(rx_en),
              .parity_en(parity_en),
              .odd_even_parity(odd_even_parity),
              .done(done),
              .frame_error(frame_error),
              .parity_error(parity_error),
              .data_out(data_out),
            );
          endmodule 
              
              
              
                          
                          
                          
                      
                    
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
