//
// Verilog Module LightSeperator5_lib.Stimulus
//
// Created:
//          by - lierez.UNKNOWN (L330W119)
//          at - 13:23:30 12/28/2015
//
// using Mentor Graphics HDL Designer(TM) 2013.1b (Build 2)
//

`resetall
`timescale 1ns/10ps
module Stimulus_orig#(`include "params.txt")(LightSeparatorInterface.Stimulus inter) ;
// ### Please start your Verilog code here ### 
// Internal Declarations
  reg [Amba_Addr_Depth-1:0] PADDR;
  reg                       PENABLE;
  reg                       PSEL;
  reg [Amba_Word-1:0]       PWDATA;
  reg                       PWRITE;
  reg [PixelPrecision-1:0]  ImInput;
  reg                       clk;
  reg                       rst;  
  
int i,t, COEFFICIENT, j;

// Assigns
  assign   inter.PADDR 	= PADDR;
  assign   inter.PENABLE 	= PENABLE;
  assign   inter.PSEL 	= PSEL;
  assign   inter.PWDATA 	= PWDATA;
  assign   inter.PWRITE 	= PWRITE; 
  assign   inter.ImInput = ImInput;
  assign   inter.clk 	= clk;  
  assign   inter.rst 	= rst;

always
  #15 clk= !clk;

initial 
   begin 
     clk <= #0 1; 
     //MTCompare();
     //RandomImInput();
     GLV_Random_tb();
     //GLV_MTCompare();
 end
     
task GLV_Random_tb();
  for(t=0;t<1000000;t=t+3300) begin
       PSEL <= #t 0; 
       PENABLE <= #t 1; //Enter setup
       PWRITE <= #t 0;  //Enter setup
       //PSEL <= #t 0;    //Enter setup
       rst <= #t 1;
       rst <= #(t+15) 0;
       rst <= #(t+45) 1;
       PSEL <= #t 1;
       PENABLE <= #(t+45) 1; //Enter read
       PENABLE <= #(t+75) 0; //Enter setup
       PWRITE <= #(t+75) 1;
       PENABLE <= #(t+105) 1;  //Enter write
       PENABLE <= #(t+135) 0;  //Enter setup
       PENABLE <= #(t+195) 1;  //Enter write
       for(i=120;i<=225;i=i+15) begin
          PADDR <= #(t+2*i-15) (i-105)/15;
       end
       for(i=120;i<=225;i=i+15) begin
          //PWDATA[11:0] <= #(t+2*i) coeffToReg();
          //PWDATA[23:12] <= #(t+2*i) coeffToReg();
          //PWDATA[11:0] <= #(t+2*i) $random;
          //PWDATA[23:12] <= #(t+2*i) $random;
          PWDATA <= #(t+2*i-15) $random;
       end 
       PADDR <= #(t+480) 0;   //Assert start_work = 1
       PWDATA <= #(t+480) -1; //Assert start_work = 1
       for(i=255;i<=720;i=i+15) begin
          ImInput <= #(t+2*i-15) $random;
       end
       PADDR <= #(t+1605) 0; //Assert start_work = 0;
       PWDATA <= #(t+1605) 0;//Assert start_work = 0;
     rst <= #(t+1635) 0;
     rst <= #(t+1665) 1;
   end
endtask
     
task RandomImInput();
  for(t=0;t<1000000;t=t+110) begin
       PSEL <= #t 0; 
       PENABLE <= #t 0; //Enter setup
       PWRITE <= #t 0;  //Enter setup
       //PSEL <= #t 0;    //Enter setup
       rst <= #t 1;
       rst <= #(t+2) 0;
       rst <= #(t+4) 1;
       PSEL <= #(t+6) 1;
       PENABLE <= #(t+6) 1; //Enter read
       PENABLE <= #(t+8) 0; //Enter setup
       PWRITE <= #(t+8) 1;
       PENABLE <= #(t+10) 1;  //Enter write
       PENABLE <= #(t+12) 0;  //Enter setup
       PENABLE <= #(t+14) 1;  //Enter write
       for(i=8;i<=15;i=i+1) begin
          PADDR <= #(t+2*i) i-7;
       end
       for(i=8;i<=15;i=i+1) begin
          //PWDATA[11:0] <= #(t+2*i) coeffToReg();
          //PWDATA[23:12] <= #(t+2*i) coeffToReg();
          //PWDATA[11:0] <= #(t+2*i) $random;
          //PWDATA[23:12] <= #(t+2*i) $random;
          PWDATA <= #(t+2*i) $random;
       end 
       PADDR <= #(t+32) 0;   //Assert start_work = 1
       PWDATA <= #(t+32) -1; //Assert start_work = 1
       for(i=17;i<=48;i=i+1) begin
          ImInput <= #(t+2*i) $random;
       end
       PADDR <= #(t+108) 0; //Assert start_work = 0;
       PWDATA <= #(t+108) 0;//Assert start_work = 0;
     rst <= #(t+110) 0;
     rst <= #(t+112) 1;
   end
endtask

function  [11:0] randomCoeffs();
          randomize(COEFFICIENT) with
          {
          };
      return COEFFICIENT;
endfunction
     
task GLV_MTCompare();
   PADDR <= #0 0;
   PWDATA <= #0 0;
   PSEL <= #t 0; 
   PENABLE <= #t 0; //Enter setup
   PWRITE <= #t 0;  //Enter setup
   rst <= #0 1;
   rst <= #15 0;
   rst <= #45 1;
   PSEL <= #75 1; 
   PWRITE <= #75 1; 
   PENABLE <= #75 0; 
   PENABLE <= #105 1; 
  for(i=75;i<=90;i=i+15) begin
          PADDR <= #(2*i-15) (i-60)/15;
  end  
  PWDATA[12:0] <= #135 0;
  PWDATA[23:12] <= #135 12'b011111111111;
  PWDATA[12:0] <= #165 0;
  PWDATA[23:12] <= #165 12'b100000000001;
  PADDR <= #195 0;
  PWDATA <= #195 -1;
  ImInput <= #225 8'b10001100;
  ImInput <= #255 8'b11111111;
  ImInput <= #285 8'b10001100;
  ImInput <= #315 8'b00011010;
  PADDR <= #405 0;
  PWDATA <= #405 0;
endtask   
     
task MTCompare();
    rst <= #0 1;
    rst <= #2 0;
    rst <= #4 1;
   PSEL <= #6 1; 
   PWRITE <= #6 1; 
   PENABLE <= #6 0; 
   PENABLE <= #8 1; 
  for(i=5;i<=6;i=i+1) begin
          PADDR <= #(2*i) i-4;
  end  
  PWDATA[12:0] <= #10 0;
  PWDATA[23:12] <= #10 12'b011111111111;
  PWDATA[12:0] <= #12 0;
  PWDATA[23:12] <= #12 12'b100000000001;
  PADDR <= #14 0;
  PWDATA <= #14 -1;
  ImInput <= #16 8'b10001100;
  ImInput <= #18 8'b11111111;
  ImInput <= #20 8'b10001100;
  ImInput <= #22 8'b00011010;
  PADDR <= #28 0;
  PWDATA <= #28 0;
endtask

endmodule