/*
 * Copyright (c) 2024 Gabriel Gouvine
 * SPDX-License-Identifier: Apache-2.0
 */

`define default_netname none

module tt_um_coloquinte_moosic (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

  localparam KEY_SIZE = 6;

  wire do_incr = ui_in[0];
  wire load_key = ui_in[1];
  wire [KEY_SIZE-1:0] key_data = ui_in[KEY_SIZE+1:2];
  assign uio_out = 0;
  assign uio_oe = 0;

  reg [KEY_SIZE-1:0] key;

  always @(posedge clk) begin
	  if (!rst_n) begin
		  key <= 0;
	  end else if (load_key) begin
		  key <= key_data;
	  end
  end

  counter c(.do_incr(do_incr),.data_out(uo_out),.clk(clk),.rst_n(rst_n),.moosic_key(key));

endmodule
