

module apb_slave(
    input pclk,
    input prst,
    input psel,
    input penable,
    input pwrite,
    input [8:0]paddr,
    input [31:0]pwdata,
    output reg[31:0]prdata,
    output reg pready,
    
    
    output reg [31:0]out_a,
    output reg [31:0]out_b,
    output reg [4:0]out_opcode,
    
    
    input [31:0]alu_result,
    input carry_flag,
    input zero_flag
  
);
  
  reg[31:0]temp_a;
  reg[31:0]temp_b;
  
  
    always @(posedge pclk or negedge prst) 
      begin
        if (!prst)
          begin
            pready<=0;
            prdata<=0;
            out_a<=0;
            out_b<=0;
            out_opcode<=0;
            temp_a<=0;
            temp_b<=0;
        end 
        else
          begin
            pready<=0; 
            
            if(psel&&penable)
              begin
                pready<=1; 
                
                if(pwrite)
                  begin
                    
                    case(paddr[7:0])
                        8'h00:temp_a<=pwdata;
                        8'h04:temp_b<=pwdata;
                        8'h08:begin
                          out_a<=temp_a;
                          out_b<=temp_b;
                          out_opcode<=pwdata[4:0];
                        end 
                    endcase
                    
                end
                else 
                  begin
                    
                    case (paddr[7:0])
                        8'h00:prdata<=temp_a;
                        8'h04:prdata<=temp_b;
                        8'h08:prdata<={27'd0, out_opcode}; 
                        8'h0C:prdata<=alu_result; 
                        8'h10:prdata<={30'd0,carry_flag,zero_flag};
                        default:prdata<=32'd0;
                    endcase
                end
            end
        end
    end
endmodule
