`timescale 1ns / 1ps

module alu(
    output reg [3:0] Anode_Activate,
    output reg [6:0] LED_out,
    input clk,alu_en,
    input [3:0] rf_d1,rf_d2,
    input [2:0]opcode,counts,
    input [7:0] index,
    input [31:0] reg_asc_desc,
    output reg done_alu=0,
    output reg signed [3:0] alu_out
    );
    reg signed [3:0] data_candidates[7:0];
    reg signed [3:0] data_candidates_reg[7:0];
    
    reg [2:0]start_from,candidate;
    reg [31:0] data_reg,data_reg2;
    reg [2:0]counts_reg=0,howmany=0;
    reg signed [3:0]max,min;
    reg [7:0]state=0;
    reg [7:0] index_reg;
    reg [2:0] i,ii;
    reg signed [3:0] candidate_data;
    wire signed [3:0] signed_data;
    assign signed_data = data_reg2[3:0];
    reg asc_bitti=0;
    reg direk_goster=0;
    reg [3:0] num1,num2,num4,gorunenler;
    always_ff @(posedge clk)
        begin
            case(state)
                8'd0:
                    begin
                        asc_bitti<=0;
                        done_alu<=0;
                        if(alu_en)
                            begin
                                i<=0;
                                start_from<=0;
                                max<=-8;
                                min<=7;
                                index_reg<=index;
                                counts_reg<=counts;
                                data_reg<=reg_asc_desc;
                                data_reg2<=reg_asc_desc;
                                if(opcode==3'b010) 
                                    begin
                                        gorunenler<=4'b1101;
                                        direk_goster<=1;
                                        num1<=rf_d1;
                                        num2<=rf_d2;
                                        
                                        num4<=rf_d1-rf_d2;
                                        alu_out<=rf_d1-rf_d2;
                                    end
                                else if(opcode==3'b011) 
                                    begin
                                        gorunenler<=4'b1101;
                                        direk_goster<=1;
                                        num1<=rf_d1;
                                        num2<=rf_d2;
                                        
                                        num4<=rf_d1+rf_d2;                                        
                                        alu_out<=rf_d1+rf_d2;
                                    end
                                else if(opcode==3'b100) //asc,find min first
                                    begin
                                        gorunenler<=4'b1001;
                                        direk_goster<=0;  
                                        num1<=counts;
                                        state<=1;
                                    end
                                else if(opcode==3'b101) //des,find max first
                                    begin
                                        gorunenler<=4'b1001;
                                        direk_goster<=0;  
                                        num1<=counts;
                                        state<=7;                      
                                    end  
                                else if(opcode==3'b110) //disp sequentially
                                    begin
                                        gorunenler<=4'b1001;
                                        direk_goster<=1;
                                        num1<=counts;
                                        num4<=rf_d1;
                                    end   
                                else
                                    direk_goster<=0;    
                            end
                    end

                8'd1:
                    begin
                        data_reg2<={4'd0,data_reg2[31:4]};
                        start_from<=start_from+1;
                        state<=state+1;
                        if(index_reg[start_from]==1 )
                            begin
                                if(signed_data<=min)
                                    begin
                                        min<=signed_data;
                                        candidate<=start_from;
                                        candidate_data<=signed_data;
                                    end
                            end
                    end
                8'd2:
                    begin
                        if(start_from<counts_reg) //continue
                            begin
                                state<=state-1;
                            
                            end
                        else
                            begin
                                index_reg[candidate]<=0;
                                state<=state+1;
                            
                            end
                    end
                8'd3:
                    begin
                        howmany<=counts_reg;
                        data_reg2<=data_reg;
                        data_candidates[i]<=candidate_data;
                        if(index_reg==0) //done
                            begin
                                i<=0;
                                state<=state+1;
                                done_alu<=1;
                            end
                        else
                            begin
                                i<=i+1;
                                state<=1;
                                min<=7;
                                start_from<=0;
                            end
                    end
                8'd4:
                    begin
                        asc_bitti<=1;
                        i<=i+1;
                        counts_reg<=counts_reg-1;
                        alu_out<=data_candidates[i];
                        if(counts_reg==1)
                            state<=0;
                            
                    end
        /////////////////

                8'd7:
                    begin
                        data_reg2<={4'd0,data_reg2[31:4]};
                        start_from<=start_from+1;
                        state<=state+1;
                        if(index_reg[start_from]==1 )
                            begin
                                if(signed_data>=max)
                                    begin
                                        max<=signed_data;
                                        candidate<=start_from;
                                        candidate_data<=signed_data;
                                    end
                            end
                    end
                8'd8:
                    begin
                        if(start_from<counts_reg) //continue
                            begin
                                state<=state-1;
                            
                            end
                        else
                            begin
                                index_reg[candidate]<=0;
                                state<=state+1;
                            
                            end
                    end
                8'd9:
                    begin
                        howmany<=counts_reg;
                        data_reg2<=data_reg;
                        data_candidates[i]<=candidate_data;
                        if(index_reg==0) //done
                            begin
                                i<=0;
                                state<=state+1;
                                done_alu<=1;
                            end
                        else
                            begin
                                i<=i+1;
                                state<=7;
                                max<=-8;
                                start_from<=0;
                            end
                    end
                8'd10:
                    begin
                        asc_bitti<=1;
                        i<=i+1;
                        counts_reg<=counts_reg-1;
                        alu_out<=data_candidates[i];
                        if(counts_reg==1)
                            state<=0;
                            
                    end  
                endcase      
        end      
        
        reg [15:0] displayed_number;
        reg [7:0]state_seven_seg=0;
        reg [27:0] counter=0;
        always  @(posedge clk)
            begin
                case(state_seven_seg)
                    8'd0:
                        begin
                            counter<=0;
                            if(direk_goster)
                                begin
                                    displayed_number<=  {num1,num2,4'd15,num4};
                                
                                end
                            else if(asc_bitti)
                                begin
                                    ii<=1;
                                    state_seven_seg<=state_seven_seg+1;
                                    data_candidates_reg<=data_candidates;
                                    displayed_number<=  {num1,4'd15,4'd15,data_candidates[0]};
                                end
                        end
                    8'd1:
                        begin
                            if(counter<100000000)
                                counter<=counter+1;
                            else
                                begin
                                    counter<=0;
                                    if(howmany>ii)//continue
                                        begin
                                            ii<=ii+1;
                                            displayed_number[3:0]<=data_candidates[ii];
                                        end
                                    else
                                        begin
                                            state_seven_seg<=0;
                                        end
                                
                                end
                        end
            
                endcase
            end


reg [3:0] number;
// Cathode patterns of the 7-segment LED display 
always @(*)
begin
 case(number) //ABCDEF
 4'b0000: LED_out = 7'b0000001; // "0"  
 4'b0001: LED_out = 7'b1001111; // "1" 
 4'b0010: LED_out = 7'b0010010; // "2" 
 4'b0011: LED_out = 7'b0000110; // "3" 
 4'b0100: LED_out = 7'b1001100; // "4" 
 4'b0101: LED_out = 7'b0100100; // "5" 
 4'b0110: LED_out = 7'b0100000; // "6" 
 4'b0111: LED_out = 7'b0001111; // "7" 
 4'b1000: LED_out = 7'b0000000; // "8"  
 4'b1001: LED_out = 7'b0000100; // "9" 
 4'b1010: LED_out = 7'b0001000; // "A"
 4'b1011: LED_out = 7'b1100000; // "b"
 4'b1100: LED_out = 7'b0110001; // "c"
 4'b1101: LED_out = 7'b1000010; // "d"
 4'b1110: LED_out = 7'b0110000; // "E"
 4'b1111: LED_out = 7'b0111000; // "F"
 default: LED_out = 7'b0000001; // "0"
 endcase
end

reg [19:0] refresh_counter; 

wire [1:0] LED_activating_counter; 

always @(posedge clk )
begin 

  refresh_counter <= refresh_counter + 1;
end 
assign LED_activating_counter = refresh_counter[19:18];

    always @(*)
    begin
        case(LED_activating_counter)
        2'b00: begin
            if(gorunenler[3])
                Anode_Activate = 4'b0111; 
            else
                Anode_Activate = 4'b1111; 
            number = displayed_number[15:12];

             end
        2'b01: begin
            if(gorunenler[2])
                Anode_Activate = 4'b1011; 

            else
                Anode_Activate = 4'b1111;                 
            number = displayed_number[11:8];
       
                end
        2'b10: begin
            if(gorunenler[1])
                Anode_Activate = 4'b1101; 

            else
                Anode_Activate = 4'b1111;   
            number = displayed_number[7:4];
       
              end
        2'b11: begin
            if(gorunenler[0])
                Anode_Activate = 4'b1110; 

            else
                Anode_Activate = 4'b1111;   
             number = displayed_number[3:0];

               end   
        default:begin
             Anode_Activate = 4'b0111; 
            number = displayed_number[15:11];
           
            end
        endcase
    end

endmodule
