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
