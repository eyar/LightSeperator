//
// Verilog Module LightSeperator5_lib.LightSeperatorTester2
//
// Created:
//          by - lierez.UNKNOWN (L330W107)
//          at - 09:13:10 12/31/2015
//
// using Mentor Graphics HDL Designer(TM) 2013.1b (Build 2)
//

`resetall
`timescale 1ns/10ps
module LightSeparatorTester2 ;
LightSeparatorInterface inter();
LightSeparatorWraper i_LightSeparatorWraper(inter);

Stimulus i_Stimulus(inter);
Checker i_Checker(inter);
Coverage i_Coverage(inter);

// ### Please start your Verilog code here ### 

endmodule
