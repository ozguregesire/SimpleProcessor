`timescale 1ns / 1ps

module instruction_memory(
    input mid,clk,
    input [15:0] switch,
    input [2:0] rd_address,
    output [11:0] out_data
    );
    
    
    reg [11:0] memory[7:0]; //12 bits X 8 length
    
    assign out_data=memory[rd_address];
    reg [2:0] wr_addr=0;
    always_ff @ (posedge clk)
        begin
        
            if(mid)
                begin
                    memory[wr_addr]<=switch[11:0];
                end
               
        end
    
endmodule
