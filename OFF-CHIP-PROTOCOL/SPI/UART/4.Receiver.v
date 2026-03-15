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
