
module tb_apb;

reg pclk;
reg prst;
reg transfer;
reg pwrite_in;

reg [7:0] write_data;
reg [8:0] addr;

wire [7:0] read_data;

apb_top DUT(

.pclk(pclk),
.prst(prst),
.transfer(transfer),
.pwrite_in(pwrite_in),
.write_data(write_data),
.addr(addr),
.read_data(read_data)

);
initial
begin
    pclk = 1;
    forever #5 pclk = ~pclk;
end
initial
begin
prst = 0;
transfer = 0;
pwrite_in = 0;
addr = 0;
write_data = 0;
#20;
prst = 1;
#20;
pwrite_in = 1;
addr = 9'b000000010;
write_data = 8'hAA;
transfer = 1;
#10;
transfer = 0;
#40;
    
pwrite_in = 1;
addr = 9'b010000100;
write_data = 8'hBB;
transfer = 1;
#10;
transfer = 0;
#40;
    
pwrite_in = 1;
addr = 9'b100000110;
write_data = 8'hCC;
transfer = 1;
#10;
transfer = 0;
#40;
    
pwrite_in = 1;
addr = 9'b010000011;
write_data = 8'hDD;
transfer = 1;
#10;
transfer = 0;
  #40;
    
pwrite_in = 0;
addr = 9'b000000010;
transfer = 1;
#10;
transfer = 0;
#40;
    
 pwrite_in = 0;
addr = 9'b010000100;
transfer = 1;
#10;
transfer = 0;
  #40;
  
pwrite_in = 0;
addr = 9'b100000110;;
transfer = 1;
#10;
transfer = 0;
    
#80;
$finish;

end
  initial 
    begin
      $dumpfile("apb.vcd");
      $dumpvars(1,tb_apb);
    end 
endmodule


