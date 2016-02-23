//
// Verilog Module LightSeperator5_lib.Coverage
//
// Created:
//          by - lierez.UNKNOWN (L330W119)
//          at - 13:38:20 12/28/2015
//
// using Mentor Graphics HDL Designer(TM) 2013.1b (Build 2)
//

`resetall
`timescale 1ns/10ps
module Coverage#(`include "params.txt")(LightSeparatorInterface.Coverage inter);
  //===================================================
  //Coverage Group
  //===================================================
covergroup LS @(posedge inter.clk);
//----------reset----------//
    reset_value : coverpoint inter.rst;
//----------pixel input----------//
    pixel_input_value : coverpoint inter.ImInput{
      bins all_inputs[2**(PixelPrecision)] = {[0:2**PixelPrecision-1]};
    }
//----------pixel output----------//
    pixel_output_value : coverpoint inter.ImOutput{
      bins all_outputs[2**(PixelPrecision)] = {[0:2**PixelPrecision-1]};
    }
//----------output less then zero----------//
//    output_less_then_zero : coverpoint inter.ImOutput{
//    bins transition_to_zero = {[0:2**PixelPrecision-2]};
//  }
//----------PADDR value----------//
    PADDR_value : coverpoint inter.PADDR{
      bins all_addresses[9] = {[0:8]};
    }
//----------PENABLE value----------//
    PENABLE_value : coverpoint inter.PENABLE;
//----------PSEL value----------//
    PSEL_value : coverpoint inter.PSEL;
//----------PWDATA value----------//
    PWDATA_value : coverpoint inter.PWDATA{
      bins positive[100] = {[0:2**Amba_Word-1]};
      bins negative[100] = {[-2**Amba_Word-1:0]};
    }
//----------PWRITE value----------//
    PWRITE_value : coverpoint inter.PWRITE;
//----------PRDATA value----------//
//    PRDATA_value : coverpoint inter.PRDATA{
//      bins all_Rdata = {[0:2**Amba_Word-1]};
//    }
endgroup
  
LS l = new();

// ### Please start your Verilog code here ### 

endmodule
