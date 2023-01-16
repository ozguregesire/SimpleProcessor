`timescale 1ns / 1ps

module cpu_tb(

    );
    
    reg clk;
reg left,right,mid,upper,lower;
reg [15:0] switch;
    
    
always begin
    clk = 0;
    #5;
    clk = 1;
    #5;
end

    cpu cpu(
.clk( clk),
.left_in( left),
.right_in( right),
.mid_in( mid),
.upper_in( upper),
.lower_in( lower),
.switch( switch) ) ;

initial begin
left=0;
right=0;
mid=0;
upper=0;
lower=0;
switch =0;

#10000000 //load reg file , Rf1=2
upper=1;
switch[15:9] ={ 4'd2,3'd1}; // 0010 001 
#10000000
upper=0;

#10000000 //load reg file , Rf4=5
upper=1;
switch[15:9] ={ 4'd5,3'd4}; // 0101 100
#10000000
upper=0;

#10000000 //load reg file , Rf2=3
upper=1;
switch[15:9] ={ 4'd3,3'd2}; // 0011 010
#10000000
upper=0;

#10000000 //load reg file , Rf3=10
upper=1;
switch[15:9] ={ 4'd10,3'd3}; // 1010 011
#10000000
upper=0;


#10000000 //STORE 
right=1; 
switch[11:0]= 12'b001000010100 ; // mem(4) = RF1

#10000000
right=0;


#10000000 //ADD 
right=1; 
switch[11:0]= 12'b011110001100 ; // add rf6 = rf1+rf4

#10000000
right=0;


#10000000 //SUB 
right=1; 
switch[11:0]= 12'b010111001100 ; // add rf7 = rf1-rf4

#10000000
right=0;


#10000000 //LOAD 
right=1; 
switch[11:0]= 12'b000000000100 ; // RF0 = mem(4)

#10000000
right=0;


#10000000 //ASCENDING 
right=1; 
switch[11:0]= 12'b100010000101 ; // ascend 01234 to 23456

#10000000
right=0;


#10000000 //DESCENDING
right=1; 
switch[11:0]= 12'b101000000111 ; // descend 01234567 to 76543210

#10000000
right=0;

    end
endmodule

