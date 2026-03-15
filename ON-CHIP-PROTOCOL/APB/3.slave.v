
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
