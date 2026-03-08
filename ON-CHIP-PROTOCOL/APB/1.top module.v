// Code your design here

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
  
  module apb_slave(
    
    input pclk,
    input prst,
    input psel,
    input penable,
    input pwrite,
    input[8:0]paddr,
    input [7:0]pwdata,
    output reg[7:0]prdata,
    output reg pready
  );
    
    reg [7:0]mem[0:127];
    
    integer i;
    
    always@(posedge pclk or negedge prst)
      begin
        if(!prst)
          begin
          pready<=0;
          prdata<=0;
            
            for(i=0;i<128;i=i+1)
              mem[i]<=0;
          end 
        else
          begin
            pready<=0;
            
            if(psel&&penable)
              begin
                pready<=1;
                if(pwrite)
                  mem[paddr[6:0]]<=pwdata;
                else 
                  prdata<=mem[paddr[6:0]];
              end 
          end
      end 
  endmodule  
  
 
  
 module apb_top(

input pclk,
input prst,
input transfer,
input pwrite_in,
input [7:0] write_data,
input [8:0] addr,

output [7:0] read_data

);

wire[7:0]pwdata;
wire[7:0]prdata;
wire[7:0]prdata0,prdata1,prdata2;
wire[8:0]paddr;
wire[2:0]psel;
wire penable;
wire pwrite;   
wire pready;
wire pready0,pready1,pready2;

assign prdata=(psel[0]) ? prdata0 :(psel[1]) ? prdata1 :
                (psel[2]) ? prdata2 : 8'b0;

assign pready=(psel[0]) ? pready0 :
                (psel[1]) ? pready1 :
                (psel[2]) ? pready2 : 1'b0;


apb_master master(

.pclk(pclk),
.prst(prst),
.transfer(transfer),
.pready(pready),
.pwrite_in(pwrite_in),
.write_data(write_data),
.prdata(prdata),
.addr(addr),

.penable(penable),
.pwrite(pwrite),
.pwdata(pwdata),
.paddr(paddr),
.psel(psel),
.read_data(read_data)

);


apb_slave slave0(

.pclk(pclk),
.prst(prst),
.psel(psel[0]),
.penable(penable),
.pwrite(pwrite),
.paddr(paddr),
.pwdata(pwdata),

.prdata(prdata0),
.pready(pready0)

);


apb_slave slave1(

.pclk(pclk),
.prst(prst),
.psel(psel[1]),
.penable(penable),
.pwrite(pwrite),
.paddr(paddr),
.pwdata(pwdata),

.prdata(prdata1),
.pready(pready1)

);

apb_slave slave2(

.pclk(pclk),
.prst(prst),
.psel(psel[2]),
.penable(penable),
.pwrite(pwrite),
.paddr(paddr),
.pwdata(pwdata),

.prdata(prdata2),
.pready(pready2)

);

endmodule
     
            
            
    
    
      
      
      
            
            
        
         
        
      
      
      
