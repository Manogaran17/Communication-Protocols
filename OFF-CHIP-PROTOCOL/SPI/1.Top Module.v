module spi_top(

  input clk,
  input rst,
  input start,
  input [7:0]slavedata_in,
  input [7:0]masterdata_in,

  output [7:0]masterdata_out,
  output [7:0]slavedata_out,
  output done1
);
  wire mosi;
  wire miso;
  wire sclk;
  wire ss;

  spi_master master(
    .clk(clk),
    .rst(rst),
    .start(start),
    .data_in(masterdata_in),
    .miso(miso),
    .mosi(mosi),
    .sclk(sclk),
    .ss(ss),
    .done1(done1),
    .data_out(masterdata_out)
  );
  
  spi_slave slave(
    .sclk(sclk),
    .ss(ss),
    .mosi(mosi),
    .rst(rst),
    .data_in(slavedata_in),
    .miso(miso),
    .data_out(slavedata_out)
  );
endmodule 
