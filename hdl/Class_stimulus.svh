//
// Verilog Module part2_lib.class_stimulus
//
// Created:
//          by - lierez.UNKNOWN (L330W120)
//          at - 13:41:07 01/ 7/2016
//
// using Mentor Graphics HDL Designer(TM) 2013.1b (Build 2)
//

`resetall
`timescale 1ns/10ps
class class_stimulus #(`include "Params.txt") ;
  virtual LightSeparatorInterface.Stimulus _inter; 
  
  integer                   i;
  integer                   t;
  integer                   COEFFICIENT;
  
  
  
  function new(virtual LightSeparatorInterface.Stimulus inter);
    begin
      inter.PADDR     =     {Amba_Addr_Depth{1'b0}};
      inter.PENABLE   =     1'b0;
      inter.PSEL      =     1'b0;
      inter.PWDATA    =     1'b0;
      inter.PWRITE    =     1'b0;
      inter.ImInput   =     {PixelPrecision{1'b0}};
      inter.clk       =     1'b0;
      inter.rst       =     1'b0;
      i               =     0;
      t               =     0;
      COEFFICIENT     =     0;
      this._inter=inter; 
    end
  endfunction
   
  function  [Amba_Word-1:0] randomCoeffs();
          randomize(COEFFICIENT) with
          {
          };
      return COEFFICIENT;
  endfunction

task Random_tb();
  for(t=0;t<1000000;t=t+1710) begin
       _inter.PSEL <= #t 0; 
       _inter.PENABLE <= #t 0; 
       _inter.PWRITE <= #t 0; 
       _inter.rst <= #t 1;
       _inter.rst <= #(t+30) 0;
       _inter.rst <= #(t+60) 1;
       _inter.PSEL <= #(t+120) 1; //Enter setup
       _inter.PENABLE <= #(t+150) 1; //Enter read
       _inter.PENABLE <= #(t+180) 0; //Enter setup
       _inter.PWRITE <= #(t+210) 1;
       _inter.PENABLE <= #(t+240) 0; //Enter write
       _inter.PENABLE <= #(t+240) 1; //Stay in write
       for(i=120;i<=225;i=i+15) begin
          _inter.PADDR <= #(t+2*i) (i-105)/15;
       end
       for(i=120;i<=225;i=i+15) begin
          //PWDATA[11:0] <= #(t+2*i) coeffToReg();
          //PWDATA[23:12] <= #(t+2*i) coeffToReg();
          //PWDATA[11:0] <= #(t+2*i) $random;
          //PWDATA[23:12] <= #(t+2*i) $random;
          _inter.PWDATA <= #(t+2*i) randomCoeffs();
       end 
       _inter.PADDR <= #(t+480) 0;   //Assert start_work = 1
       _inter.PWDATA <= #(t+480) -1; //Assert start_work = 1
       for(i=255;i<=720;i=i+15) begin
          _inter.ImInput <= #(t+2*i) randomCoeffs();
       end
       _inter.PADDR <= #(t+1620) 0; //Assert start_work = 0;
       _inter.PWDATA <= #(t+1620) 0;//Assert start_work = 0;
   end
endtask

task MTCompare();
   _inter.PADDR <= #0 0;
   _inter.PWDATA <= #0 0;
   _inter.PSEL <= #t 0; 
   _inter.PENABLE <= #t 0; //Enter setup
   _inter.PWRITE <= #t 0;  //Enter setup
   _inter.rst <= #0 1;
   _inter.rst <= #30 0;
   _inter.rst <= #60 1;
   _inter.PSEL <= #120 1; 
   _inter.PWRITE <= #120 1; //Prepare write
   _inter.PENABLE <= #120 0; //Enter write
   _inter.PENABLE <= #150 1; //Stay in write
  for(i=90;i<=105;i=i+15) begin
          _inter.PADDR <= #(2*i) (i-75)/15;
  end  
  _inter.PWDATA[12:0] <= #180 0;
  _inter.PWDATA[23:12] <= #180 12'b011111111111;
  _inter.PWDATA[12:0] <= #210 0;
  _inter.PWDATA[23:12] <= #210 12'b100000000001;
  _inter.PADDR <= #240 0;
  _inter.PWDATA <= #240 -1;
  _inter.ImInput <= #270 8'b10001100;
  _inter.ImInput <= #300 8'b11111111;
  _inter.ImInput <= #330 8'b10001100;
  _inter.ImInput <= #360 8'b00011010;
  _inter.PADDR <= #450 0;
  _inter.PWDATA <= #450 0;
endtask 

  task reset; 
    begin
    _inter.rst <= 0;  
    #50 _inter.rst <= 1;
    end
  endtask

// ### Please start your Verilog code here ### 

endclass
