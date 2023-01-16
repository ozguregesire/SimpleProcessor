`timescale 1ns / 1ps

module cpu(
    output  [3:0] Anode_Activate,
    output  [6:0] LED_out,
    
    input clk,
    input left_in,right_in,mid_in,upper_in,lower_in,
    input [15:0] switch
    );
    wire  left,right,mid,upper,lower;
    reg left_in_d=0,right_in_d=0,mid_in_d=0,upper_in_d=0,lower_in_d=0;
    reg left_in_2d=0,right_in_2d=0,mid_in_2d=0,upper_in_2d=0,lower_in_2d=0;
    
    reg [18:0] cnt_debounce=1;
    assign left = !left_in_2d && left_in_d;
    assign right = !right_in_2d && right_in_d;
    assign mid = !mid_in_2d && mid_in_d;
    assign upper = !upper_in_2d && upper_in_d;
    assign lower = !lower_in_2d && lower_in_d;
    always @(posedge clk)//10ns 
        begin
            cnt_debounce<=cnt_debounce+1;
                    left_in_2d<=left_in_d;
                    right_in_2d<=right_in_d;
                    mid_in_2d<=mid_in_d;
                    upper_in_2d<=upper_in_d;
                    lower_in_2d<=lower_in_d;
            if(cnt_debounce==0)
                begin
                    left_in_d<=left_in;
                    right_in_d<=right_in;
                    mid_in_d<=mid_in;
                    upper_in_d<=upper_in;
                    lower_in_d<=lower_in;
                end
        end

   wire done_alu;
wire [3:0] rf_d1,rf_wd,rf_d2,m_wd,m_rd,alu_out;
wire [11:0] instr_out,out_data;
wire  [2:0] PC_load,opcode,rf_wa,rf_ad1,rf_ad2,pc_out;
wire  rf_we,m_we,alu_en;
wire  m_re,mux_sel;
wire  [31:0] reg_asc_desc;
wire  [3:0] m_add;
wire  [7:0] index;
wire  [2:0]counts;
    
    controller controller (
    .lower(lower),
    .switch(switch),
    .left(left),
    .right(right),
    .clk(clk), 
    .done_alu(done_alu), 
    .rf_d1(rf_d1), 
    .instr_out_real(instr_out), 
    .PC_load(PC_load), 
    .opcode(opcode), 
    .rf_wa(rf_wa), 
    .rf_ad1(rf_ad1), 
    .rf_ad2(rf_ad2), 
    .rf_we(rf_we), 
    .m_we(m_we), 
    .alu_en(alu_en), 
    .m_re(m_re), 
    .mux_sel(mux_sel), 
    .reg_asc_desc(reg_asc_desc), 
    .m_add(m_add), 
    .index(index), 
    .counts(counts)
    );

assign rf_wd = mux_sel ? m_rd : alu_out;
register_file register_file (
    .upper(upper),
    .switch(switch), 
    .rf_ad1(rf_ad1), 
    .rf_ad2(rf_ad2), 
    .rf_wa(rf_wa), 
    .rf_we(rf_we), 
    .clk(clk), 
    .rf_wd(rf_wd), 
    .rf_d1(rf_d1), 
    .rf_d2(rf_d2)
    );

data_memory data_memory (
    .m_add(m_add), 
    .m_wd(rf_d1), 
    .m_we(m_we), 
    .clk(clk), 
    .m_re(m_re), 
    .m_rd(m_rd)
    );

instr_register instr_register (
    .clk(clk), 
    .instr_in(out_data), 
    .instr_out(instr_out)
    );

instruction_memory instruction_memory (
.clk(clk), 
.mid(mid), 
.switch(switch), 
    .rd_address(pc_out), 
    .out_data(out_data)
    );

prog_counter prog_counter (
    .clk(clk), 
    .pc_in(PC_load), 
    .pc_out(pc_out)
    );

alu alu (
.Anode_Activate(Anode_Activate),
.LED_out(LED_out),
    .clk(clk), 
    .alu_en(alu_en), 
    .rf_d1(rf_d1), 
    .rf_d2(rf_d2), 
    .opcode(opcode), 
    .counts(counts), 
    .index(index), 
    .reg_asc_desc(reg_asc_desc), 
    .done_alu(done_alu), 
    .alu_out(alu_out)
    );

endmodule
