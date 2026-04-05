module spi_master(
 input clk,
 input rst,
 input start,
 input [7:0]data_in,
  input miso,
  
  output reg mosi,
  output reg sclk,
  output reg ss,
  output reg done1,
  output reg [7:0]data_out
);
 
  reg[7:0] shift_reg;
  reg[3:0]bit_count;
  
  reg[1:0]state,nxt_state;
  
  parameter idle=2'b00,load=2'b01,transfer=2'b10,done=2'b11;
  
  always@(posedge clk or posedge rst)
    begin
      if(rst)
        state<=idle;
      else 
        state<=nxt_state;
    end 
  always@(*)
    begin
      case(state)
        idle:
          begin
          if(start)
            nxt_state=load;
            else
              nxt_state=idle;
          end
        
        load:
          nxt_state=transfer;
        
        transfer:
          begin
          if(bit_count==0)
            nxt_state=done;
          else 
            nxt_state=transfer;
          end 
        
        done:
          nxt_state=idle;
        default:
          nxt_state=idle;
      endcase
    end
  
  always@(posedge clk or posedge rst)
    begin
      if(rst)
        begin
          ss<=0;
          sclk<=0;
          done1<=0;
          bit_count<=0;
        end 
      else
        begin
          case(state)
            idle:
              begin
                ss<=1;
                done1<=0;
                sclk<=0;
              end 
            load:
              begin
              ss<=0;
              shift_reg<=data_in;
              bit_count<=4'd8;
              end 
            transfer:
              begin
                sclk<=~sclk;
                if(sclk==0)
                  begin
                    mosi<=shift_reg[7];
                    shift_reg<={shift_reg[6:0],miso};
                    bit_count<=bit_count-1;
                  end 
              end 
            done:
            begin
              ss<=1;
              done1<=1;
              data_out<=shift_reg;
              if(start==0)
                nxt_state=idle;
            end 
          endcase
        end 
    end 
endmodule
