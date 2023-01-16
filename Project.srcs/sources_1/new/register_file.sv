`timescale 1ns / 1ps

module register_file(
    input upper,
    input [15:0] switch,
    
    input [2:0] rf_ad1,rf_ad2,rf_wa,
    input rf_we,clk,
    input [3:0] rf_wd,
    output reg [3:0] rf_d1=0,rf_d2=0
    );
    
    reg [3:0] memory[7:0]; //4 bits X 8 length
     
    always_ff @(posedge clk)
        begin
            if(upper)   
                memory[switch[11:9]]<=switch[15:12];
            else if(rf_we)
                memory[rf_wa]<=rf_wd;
        
         
            rf_d1<=memory[rf_ad1];
            rf_d2<=memory[rf_ad2];
        end
                 
endmodule
