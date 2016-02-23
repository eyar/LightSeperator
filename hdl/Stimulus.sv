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
`include "class_stimulus.svh"
module Stimulus#(`include "params.txt")(LightSeparatorInterface.Stimulus inter) ;
// ### Please start your Verilog code here ### 
// Internal Declarations
  class_stimulus stim;
  
  initial begin
    stim = new(inter);
  end
  
  always #15 inter.clk = !inter.clk;
  
  initial begin
    //stim.reset();
    stim.Random_tb();
    //stim.MTCompare();
  end

endmodule