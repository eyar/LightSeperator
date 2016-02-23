//
// Verilog Module LightSeperator5_lib.Checker
//
// Created:
//          by - lierez.UNKNOWN (L330W119)
//          at - 12:46:35 12/28/2015
//
// using Mentor Graphics HDL Designer(TM) 2013.1b (Build 2)
//

`resetall
`timescale 1ns/10ps
module Checker#(  `include "params.txt")(LightSeparatorInterface.Checker inter);

  `define IDLE 2'b00
  `define SETUP 2'b01
  `define ACCES_READ 2'b10
  `define ACCES_WRITE 2'b11
  
  
  `define STATE {inter.PSEL, inter.PENABLE}
    //port decleration
  

//----------reset_active----------//
  property reset_active;
    @(posedge inter.clk) inter.rst==0
      |=> (inter.PRDATA==0 && inter.ImOutput==0);
  endproperty
  assert property(reset_active)
  else $error("problem with reset");
  cover property (reset_active);
//----------setup to write----------//
  property setup_to_write;
    @(posedge inter.clk) inter.PSEL==1 & inter.PENABLE==0
      |=> inter.PSEL==1 & inter.PENABLE==1 & inter.PWRITE==1;
  endproperty
  assert property(setup_to_write)
  else $error("problem with state");
  cover property (setup_to_write);
  //----------setup to read----------//
  property setup_to_read;
    @(posedge inter.clk) inter.PSEL==1 & inter.PENABLE==0
      |=> inter.PSEL==1 & inter.PENABLE==1 & inter.PWRITE==0;
  endproperty
  assert property(setup_to_read)
  else $error("problem with state");
  cover property (setup_to_read);
//----------assert read_to_setup----------//
  property read_to_setup;
    @(posedge inter.clk) inter.PSEL==1 & inter.PENABLE==1 & inter.PWRITE==0  
      |=> inter.PSEL==1 & inter.PENABLE==0;
  endproperty
  assert property(read_to_setup)
  else $error("problem with state");
  cover property (read_to_setup);
//----------assert write_to_setup----------//
  property write_to_setup;
    @(posedge inter.clk) inter.PSEL==1 & inter.PENABLE==1 & inter.PWRITE==1  
      |=> inter.PSEL==1 && inter.PENABLE==0;
  endproperty
  assert property(write_to_setup)
  else $error("problem with state");
  cover property (write_to_setup);
  
endmodule
