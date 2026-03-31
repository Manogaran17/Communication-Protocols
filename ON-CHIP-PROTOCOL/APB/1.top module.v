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
   
