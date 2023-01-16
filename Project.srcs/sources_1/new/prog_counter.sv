`timescale 1ns / 1ps

module prog_counter(
    input clk,
    input [2:0] pc_in,
    output reg [2:0] pc_out=0
    );
      
     always_ff @(posedge clk)
        begin
            pc_out<=pc_in;
        end   
endmodule
