`timescale 1ns / 1ps

module instr_register(
    input clk,
    input [11:0] instr_in,
    output reg [11:0] instr_out
    );
    
    always_ff @(posedge clk)
        begin
            instr_out<=instr_in;
        end
                
endmodule
