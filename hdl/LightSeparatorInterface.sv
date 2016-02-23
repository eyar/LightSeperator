//
// Verilog interface LightSeperator5_lib.LightSeperatorInterface
//
// Created:
//          by - lierez.UNKNOWN (L330W119)
//          at - 13:05:15 12/28/2015
//
// using Mentor Graphics HDL Designer(TM) 2013.1b (Build 2)
//

`resetall
`timescale 1ns/10ps
interface LightSeparatorInterface#(`include "params.txt");
   logic                           clk;
   logic                           rst;
   logic    [Amba_Addr_Depth-1:0]  PADDR;
   logic                           PENABLE;
   logic                           PSEL;
   logic    [Amba_Word-1:0]        PWDATA;
   logic                           PWRITE; 
   logic    [PixelPrecision-1:0]   ImInput;
   logic    [Amba_Word-1:0]        PRDATA;
   logic    [PixelPrecision-1:0]   ImOutput;
   

modport Checker(input clk, rst, PADDR, PENABLE, PSEL, PWDATA, PWRITE, ImInput, PRDATA, ImOutput);
modport Stimulus(output clk, rst, PADDR, PENABLE, PSEL, PWDATA, PWRITE, ImInput);
modport Coverage(input clk, rst, PADDR, PENABLE, PSEL, PWDATA, PWRITE, ImInput, PRDATA, ImOutput);
modport LightSeparatorWraper(input clk, rst, PADDR, PENABLE, PSEL, PWDATA, PWRITE, ImInput, output PRDATA, ImOutput);



// ### Please start your Verilog code here ### 
endinterface
