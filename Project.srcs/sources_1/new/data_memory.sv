`timescale 1ns / 1ps

module data_memory(
    input [3:0] m_add,//address
    input [3:0] m_wd,// write data
    input m_we,clk,//write 
    input m_re, //read
    output reg [3:0] m_rd// read data
    );
    
    reg [3:0] memory[15:0]; //4 bits X 16 length
    
    always_ff @(posedge clk)
        begin
            if(m_we)
                memory[m_add]<=m_wd;
        
            if(m_re)
                m_rd<=memory[m_add];
           
        end
               
endmodule
