//
// Verilog Module my_project3_lib.combined
//
// Created:
//          by - Eyar.UNKNOWN (DESKTOP-SPCI77R)
//          at - 21:19:43 12/ 9/2015
//
// using Mentor Graphics HDL Designer(TM) 2012.1 (Build 6)
//

`resetall
`timescale 1ns/10ps
module LightSeparator(clk, PADDR, PENABLE, PSEL, PWDATA, PWRITE, PRDATA, rst, ImInput, ImOutput);
//`include "C:\\LS_part2\\1\\default_lib\\hdl\\params.v"
`include "/params.v"

   // Port Declarations
   input   wire                           clk;
   input   wire                           rst;
   input   wire    [Amba_Addr_Depth-1:0]  PADDR;
   input   wire                           PENABLE;
   input   wire                           PSEL;
   input   wire    [Amba_Word-1:0]        PWDATA;
   input   wire                           PWRITE; 
   input   wire    [PixelPrecision-1:0]   ImInput;
   output  reg     [Amba_Word-1:0]        PRDATA;
   output  reg     [PixelPrecision-1:0]   ImOutput;

// Internal Declarations
parameter REGISTER_SIZE = 32;
parameter MAX_LOG_N = 4;
parameter COEFFICIENT_SIZE = 12;
parameter B_REGISTER_NUM = 8;

reg rst_n, rff1;
reg[REGISTER_SIZE-1:0] CTRL;//, b1b2, b3b4, b5b6, b7b8, b9b10, b11b12, b13b14, b15b16;
reg[REGISTER_SIZE-1:0] BankRegister [7:0];
wire[11:0] BankRegisterDebug [15:0]; //DEBUG
reg[PixelPrecision + MAX_LOG_N + COEFFICIENT_SIZE - 1:0] picStore [0:Row-1][0:Col-1];
reg[3:0] i;
reg[5:0] j,k;

integer ii,jj,kk;

reg [1:0] apb_st_current_state;
parameter SETUP = 0,
           W_ENABLE = 1,
           R_ENABLE = 2;

//For Debug
assign BankRegisterDebug[0] = BankRegister[0][11:0];
assign BankRegisterDebug[1] = BankRegister[0][23:12];
assign BankRegisterDebug[2] = BankRegister[1][11:0];
assign BankRegisterDebug[3] = BankRegister[1][23:12];
assign BankRegisterDebug[4] = BankRegister[2][11:0];
assign BankRegisterDebug[5] = BankRegister[2][23:12];
assign BankRegisterDebug[6] = BankRegister[3][11:0];
assign BankRegisterDebug[7] = BankRegister[3][23:12];
assign BankRegisterDebug[8] = BankRegister[4][11:0];
assign BankRegisterDebug[9] = BankRegister[4][23:12];
assign BankRegisterDebug[10] = BankRegister[5][11:0];
assign BankRegisterDebug[11] = BankRegister[5][23:12];
assign BankRegisterDebug[12] = BankRegister[6][11:0];
assign BankRegisterDebug[13] = BankRegister[6][23:12];
assign BankRegisterDebug[14] = BankRegister[7][11:0];
assign BankRegisterDebug[15] = BankRegister[7][23:12];



// ### Please start your Verilog code here ### 
always@(posedge clk or negedge rst) begin :alwyas_block
  if (!rst) {rst_n,rff1} <= 2'b0;
  else begin
    {rst_n,rff1} <= {rff1,1'b1};
    if(!rst_n) begin
      apb_st_current_state <= 0;
      PRDATA <= 0;
      ImOutput <= 0;
      CTRL <= 0;
      i <= 0;
      j <= 0;
      k <= 0;
      for(ii=0;ii<B_REGISTER_NUM;ii=ii+1) begin
        BankRegister[ii] <= 0;
      end
      for(jj=0;jj<Row;jj=jj+1) begin
        for(kk=0;kk<Col;kk=kk+1) begin
          picStore[jj][kk] <= 0;
        end
      end
    end
    else begin
      {rst_n,rff1} <= {rff1,1'b1};
      case (apb_st_current_state)
      SETUP : begin
        // clear the prdata
        PRDATA <= 0;

        // Move to ENABLE when the psel is asserted
        if (PSEL && !PENABLE) begin
          if (PWRITE) begin
            apb_st_current_state <= W_ENABLE;
          end

          else begin
            apb_st_current_state <= R_ENABLE;
          end
        end
      end

      W_ENABLE : begin
        // write pwdata to memory
        if (PSEL && PENABLE && PWRITE) begin
          case(PADDR)
            0: CTRL[Amba_Word-1:1] <= PWDATA[Amba_Word-1:1];
            default:BankRegister[PADDR-1] <= PWDATA;
          endcase
        end
        else begin
           apb_st_current_state <= SETUP;
        end
      end
      R_ENABLE : begin
        // read prdata from memory
        if (PSEL && PENABLE && !PWRITE) begin
          case(PADDR)
            0: PRDATA <= CTRL[Amba_Word-1:1];
            default:PRDATA <= BankRegister[PADDR-1];
          endcase
        end
        else begin
           apb_st_current_state <= SETUP;
        end
      end
    endcase
	// Start Work
      if(CTRL[1] && !CTRL[0]) begin
		// Last Pixel
        if(k==Col-1 && j==Row-1 && i==N-1) begin
          case(i%2)
            0:begin
                case(BankRegister[i/2][11])
                  0:picStore[j][k] <= picStore[j][k] + ImInput*BankRegister[i/2][11:0];
                  1:picStore[j][k] <= picStore[j][k] - ImInput*BankRegister[i/2][11:0];
                endcase
              end
            1:begin
                case(BankRegister[(i-1)/2][23])
                  0:picStore[j][k] <= picStore[j][k] + ImInput*BankRegister[(i-1)/2][23:12];
                  1:picStore[j][k] <= picStore[j][k] - ImInput*BankRegister[(i-1)/2][23:12];
                endcase
              end
          endcase
          i <= 0;
          j <= 0;
          k <= 0;
          CTRL[0] <= 1;
        end
        else if (k==Col-1 && j==Row-1) begin
          case(i%2)
            0:begin
                case(BankRegister[i/2][11])
                  0:picStore[j][k] <= picStore[j][k] + ImInput*BankRegister[i/2][11:0];
                  1:picStore[j][k] <= picStore[j][k] - ImInput*BankRegister[i/2][11:0];
                endcase
              end
            1:begin
                case(BankRegister[(i-1)/2][23])
                  0:picStore[j][k] <= picStore[j][k] + ImInput*BankRegister[(i-1)/2][23:12];
                  1:picStore[j][k] <= picStore[j][k] - ImInput*BankRegister[(i-1)/2][23:12];
                endcase
              end
          endcase
          i <= i + 1;
          j <= 0;
          k <= 0;
        end
        else if (k==Col-1) begin
          case(i%2)
            0:begin
                case(BankRegister[i/2][11])
                  0:picStore[j][k] <= picStore[j][k] + ImInput*BankRegister[i/2][11:0];
                  1:picStore[j][k] <= picStore[j][k] - ImInput*BankRegister[i/2][11:0];
                endcase
              end
            1:begin
                case(BankRegister[(i-1)/2][23])
                  0:picStore[j][k] <= picStore[j][k] + ImInput*BankRegister[(i-1)/2][23:12];
                  1:picStore[j][k] <= picStore[j][k] - ImInput*BankRegister[(i-1)/2][23:12];
                endcase
              end
          endcase
          j <= j + 1;
          k <= 0;
        end
        else if(k<Col && j<Row && i<N)begin
          case(i%2)
            0:begin
                case(BankRegister[i/2][11])
                  0:picStore[j][k] <= picStore[j][k] + ImInput*BankRegister[i/2][11:0];
                  1:picStore[j][k] <= picStore[j][k] - ImInput*BankRegister[i/2][11:0];
                endcase
              end
            1:begin
                case(BankRegister[(i-1)/2][23])
                  0:picStore[j][k] <= picStore[j][k] + ImInput*BankRegister[(i-1)/2][23:12];
                  1:picStore[j][k] <= picStore[j][k] - ImInput*BankRegister[(i-1)/2][23:12];
                endcase
              end
          endcase
          k <= k + 1;
        end
      end
	  // Start Transmit
      else if(CTRL[1] && CTRL[0]) begin
        if (k==Col-1 && j==Row-1) begin
          case(picStore[j][k][PixelPrecision + MAX_LOG_N + COEFFICIENT_SIZE - 1])
            0:begin ImOutput <= picStore[j][k][PixelPrecision + $clog2(N) + (COEFFICIENT_SIZE-1): $clog2(N) + (COEFFICIENT_SIZE-1)]; end
            1:begin ImOutput <= 0; end
          endcase
          j <= 0;
          k <= 0;
          i <= 0;
        end
        else if (k==Col-1) begin
          case(picStore[j][k][PixelPrecision + MAX_LOG_N + COEFFICIENT_SIZE - 1])
            0:begin ImOutput <= picStore[j][k][PixelPrecision + $clog2(N) + (COEFFICIENT_SIZE-1): $clog2(N) + (COEFFICIENT_SIZE-1)]; end
            1:begin ImOutput <= 0; end
          endcase
          j <= j + 1;
          k <= 0;
        end
        else if(k<Col && j<Row) begin
          case(picStore[j][k][PixelPrecision + MAX_LOG_N + COEFFICIENT_SIZE - 1])
            0:begin ImOutput <= picStore[j][k][PixelPrecision + $clog2(N) + (COEFFICIENT_SIZE-1): $clog2(N) + (COEFFICIENT_SIZE-1)]; end
            1:begin ImOutput <= 0; end
          endcase
          k <= k + 1;
        end
      end
	  // Assert !frame_ready
      else if(!CTRL[1] && CTRL[0]) begin
        CTRL[0] <= 0;
      end
    end
  end
end
endmodule
