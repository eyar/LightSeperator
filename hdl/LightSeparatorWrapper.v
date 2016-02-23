//
// Verilog Module LightSeperator5_lib.LightSeperatorWarper
//
// Created:
//          by - lierez.UNKNOWN (L330W119)
//          at - 13:17:33 12/28/2015
//
// using Mentor Graphics HDL Designer(TM) 2013.1b (Build 2)
//

`resetall
`timescale 1ns/10ps
module LightSeparatorWraper#(`include "params.txt")(LightSeparatorInterface.LightSeparatorWraper inter) ;
  LightSeparator i_LightSeparator(
    .clk          (inter.clk),
    .rst          (inter.rst),
    .PADDR          (inter.PADDR),
    .PENABLE       (inter.PENABLE),
    .PSEL         (inter.PSEL),
    .PWDATA        (inter.PWDATA),
    .PWRITE        (inter.PWRITE),
    .ImInput         (inter.ImInput),
    .PRDATA          (inter.PRDATA),
    .ImOutput          (inter.ImOutput)
    
  );


// ### Please start your Verilog code here ### 

endmodule
