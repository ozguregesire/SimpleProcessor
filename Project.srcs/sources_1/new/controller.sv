`timescale 1ns / 1ps

module controller(
    input [15:0] switch,
    input left,right,lower,
    input clk,done_alu,
    input [3:0] rf_d1,
    input [11:0] instr_out_real,
    output reg [2:0] PC_load=0,opcode=0,rf_wa=0,rf_ad1=0,rf_ad2=0,
    output reg rf_we=0,m_we=0,alu_en=0,
    output reg m_re=0,mux_sel=0,
    output reg [31:0] reg_asc_desc,
    output reg [3:0] m_add,
    output reg [7:0] index,
    output reg [2:0]counts=0
    );
    wire [11:0] instr_out;
    reg real_ins=1;
    reg [7:0]state=0;
    reg [2:0]number_of_regs,PC_inmodule=0;
    reg [27:0] counter=0;
    
    assign instr_out = real_ins ? instr_out_real : switch[11:0];
    always_ff @(posedge clk)
        begin
            if(lower)
                begin
                    state<=0;
                    PC_inmodule<=0;
                end
        else
            begin
                    case(state)
                        default:
                            begin
                                alu_en<=0;
                                state<=state+1;
                                rf_we<=0;
                            end
                        8'd0: //fetch1
                            begin
                                alu_en<=0;
                                m_we<=0;
                                rf_we<=0;
                                if(left)
                                    begin
                                        real_ins<=1;
                                        PC_load<=PC_inmodule;     
                                        state<=state+1;
                                    end
                                else if(right)
                                    begin
                                        real_ins<=0;
                                        state<=3;
                                    end
                            end
                        8'd1: //fetch2
                            begin
                                PC_inmodule<=PC_inmodule+1;
                                state<=state+1;
                            end
                        8'd2: //fetch3
                            begin
                                state<=state+1;
                            end               
                        8'd3: //decode1
                            begin
                                opcode<=instr_out[11:9];
                                counter<=0;    
                                if(instr_out[11:9]==3'b000) //LOAD
                                    begin
                                        m_re<=1;
                                        m_we<=0;
                                        m_add<=instr_out[3:0];
                                        state<=state+1;
                                        rf_we<=0;
                                        rf_wa<=instr_out[6:4]; //buraya yazýlacak
                                        mux_sel<=1; //memory out,
                                    end
                                else  if(instr_out[11:9]==3'b001) //STORE
                                    begin
                                        rf_ad1<=instr_out[6:4];
                                        m_add<=instr_out[3:0];
                                        state<=7;
                                        rf_we<=0;
                                    end
                                else  if(instr_out[11:9]==3'b010) //SUB
                                    begin
                                        alu_en<=1;
                                        rf_ad1<=instr_out[5:3];
                                        rf_ad2<=instr_out[2:0];
                                        rf_wa<=instr_out[8:6];
                                        mux_sel<=0; //ALU out,
                                        state<=9;
                                    end
        
                                else  if(instr_out[11:9]==3'b011) //ADD
                                    begin
                                        alu_en<=1;
                                        rf_ad1<=instr_out[5:3];
                                        rf_ad2<=instr_out[2:0];
                                        rf_wa<=instr_out[8:6];
                                        mux_sel<=0; //ALU out,
                                        state<=12;
                                        
                                    end     
        
                                else  if(instr_out[11:9]==3'b100) //ASC
                                    begin
                                        mux_sel<=0;
                                        counts<=0;
                                        index<=0;
                                        number_of_regs<=instr_out[2:0];
                                        rf_ad1<=instr_out[5:3];
                                        rf_wa<=instr_out[8:6];//start here.
                                        state<=15;
                                        reg_asc_desc<=0;
                                    end      
        
                                else  if(instr_out[11:9]==3'b101) //DESc
                                    begin
                                        mux_sel<=0;
                                        counts<=0;
                                        index<=0;
                                        number_of_regs<=instr_out[2:0];
                                        rf_ad1<=instr_out[5:3];
                                        rf_wa<=instr_out[8:6];//start here.
                                        state<=21;
                                        reg_asc_desc<=0;
                                    end   
                                 else  if(instr_out[11:9]==3'b110) //Disp
                                    begin
                                        counts<=instr_out[2:0];
                                        rf_ad1<=instr_out[5:3];
                                        number_of_regs<=instr_out[2:0];
                                        if(number_of_regs>0)
                                            state<=27;
                                    end                                                                         
                            end
                        8'd4://LOAD
                            begin
                                state<=state+1;
                            end
                        8'd5://LOAD
                            begin
                                rf_we<=1;
                                state<=0;
                                
                            end
                   ////         
                        8'd7://STORE
                            begin
                                m_we<=1;
                                state<=0;
                            end
                ////
                        8'd9://SUB
                            begin
                                alu_en<=0;
                                state<=state+1;
                            
                            end
                        8'd10://SUB
                            begin
                                rf_we<=1;
                                state<=0;
                            end
                //
                
                        8'd12://add
                            begin
                                alu_en<=0;
                                state<=state+1;
                            
                            end
                        8'd13://add
                            begin
                                rf_we<=1;
                                state<=0;
                            end
                //        
                
                        8'd15://ASC
                            begin
                                state<=state+1;
                            end
                        8'd16://ASC
                            begin
                                index[counts]<=1;
                                counts<=counts+1;
                                number_of_regs<=number_of_regs-1;
                                reg_asc_desc<={reg_asc_desc[27:0],rf_d1};
                                if(number_of_regs<=1)
                                    begin
                                        state<=state+1;  
                                        alu_en<=1;
                                    end
                                else
                                    begin
                                        state<=15;
                                        rf_ad1<=rf_ad1+1;
                                    end
                            end
                        8'd17://ASC
                            begin
                                alu_en<=0;
                                if(done_alu)
                                    begin
                                        counts<=counts-1;
                                        if(rf_wa==7 || counts<=1)
                                            state<=248;
                                        else    
                                            state<=state+1;
                                        rf_we<=1;
                                    end
                                
                            end
                        8'd18://ASC
                            begin
                                rf_wa<=rf_wa+1;
                                counts<=counts-1;
                                if(rf_wa==7 || counts<=1)
                                    state<=248;
        
                                rf_we<=1;
                            end
                
                 //        
                
                        8'd21://ASC
                            begin
                                state<=state+1;
                            end
                        8'd22://ASC
                            begin
                                index[counts]<=1;
                                counts<=counts+1;
                                number_of_regs<=number_of_regs-1;
                                reg_asc_desc<={reg_asc_desc[27:0],rf_d1};
                                if(number_of_regs<=1)
                                    begin
                                        state<=state+1;  
                                        alu_en<=1;
                                    end
                                else
                                    begin
                                        state<=21;
                                        rf_ad1<=rf_ad1+1;
                                    end
                            end
                        8'd23://ASC
                            begin
                                alu_en<=0;
                                if(done_alu)
                                    begin
                                        counts<=counts-1;
                                        if(rf_wa==7 || counts<=1)
                                            state<=248;
                                        else    
                                            state<=state+1;
                                        rf_we<=1;
                                    end
                                
                            end
                        8'd24://ASC
                            begin
                                rf_wa<=rf_wa+1;
                                counts<=counts-1;
                                if(rf_wa==7 || counts<=1)
                                    state<=248;
        
                                rf_we<=1;
                            end       
                //
                        8'd27:
                            begin
                                if(counter<100000000)//display 1 sec
                                    begin
                                        counter<=counter+1;
                                             
                                    end
                                else
                                    begin
                                        counter<=0;
                                        if(number_of_regs>1)
                                            begin
                                                rf_ad1<=rf_ad1+1;
                                                number_of_regs<=number_of_regs-1;
                                            end
                                        else
                                            state<=0;
                                    end
                            end
                
                
                    endcase
                end
        end
endmodule
