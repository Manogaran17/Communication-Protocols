
module apb_master(
  input pclk,
  input prst,
  input transfer,
  input pready,
  input pwrite_in,
  input[7:0]write_data,
  input [7:0] prdata,
  input [8:0]addr,
  output reg penable,
  output reg pwrite,
  output reg [7:0]pwdata,
  output reg [8:0]paddr,
  output reg [2:0]psel,
  output reg [7:0] read_data

);
  reg [1:0] state,nxt_state;
  
  parameter idle = 2'b00, setup = 2'b01, access = 2'b10;

  always@(posedge pclk or negedge prst )
    begin
      if(~prst)
        begin
        state <= idle;
        read_data<=0;
        end 
      else 
        state <= nxt_state;
    end 
  
  always@(posedge pclk or negedge prst)
    begin
      if(state==access&&pready&&!pwrite)
        read_data<=prdata;
    end 
  
  always@(*)
    begin
      case(state)
        idle:
          begin
          if(transfer)
            nxt_state = setup;
        else
          nxt_state = idle;
          end 
        setup:
          begin
            penable =0;
            nxt_state=access;
          end 
        access:
          if(pready)
            nxt_state = transfer?setup:idle;
            else
              nxt_state = access;
        default:
          nxt_state = idle;
      endcase
    end 
  
  always@(*)
    begin

      penable = (state == access);
      pwrite=pwrite_in;
      pwdata=write_data;
      paddr=addr;

      psel = 3'b000;
  
      if(state==setup||state==access)
        begin
          case(addr[8:7])
            
            2'b00:psel=3'b001;
            2'b01:psel=3'b010;
            2'b10:psel=3'b100;
          endcase
        end
    end 
endmodule
