/*
 * Copyright (c) 2024 Gabriel Gouvine
 * SPDX-License-Identifier: Apache-2.0
 */

`define default_netname none

module tt_um_coloquinte_simon (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

  wire [63:0] key_in;
  wire [31:0] data_in;
  wire [31:0] data_out;

  genvar i;
  for (i=0 i<4; i=i+1) {
    assign data_in[8*i+8:8*i] = ui_in;
  }
  for (i=0 i<8; i=i+1) {
    assign key_in[8*i+8:8*i] = ui_in;
  }
  assign uo_out = data_out[7:0];

  wire done;

  simon #(.n(32),.m(2)) cipher (.clk(clk),.rst(!rst_n),.plaintext(data_in),.key(key_in),.ciphertext(data_out),.en(1'b1), .done(done));
endmodule
