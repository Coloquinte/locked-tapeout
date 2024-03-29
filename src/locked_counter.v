/* Generated by Yosys 0.35+56 (git sha1 8614d9b32, gcc 11.4.0-1ubuntu1~22.04 -fPIC -Os) */

(* src = "src/counter.v:2.1-21.10" *)
module counter(do_incr, data_out, clk, rst_n, moosic_key);
  wire _00_;
  wire _01_;
  wire _02_;
  wire _03_;
  wire _04_;
  wire _05_;
  wire _06_;
  wire _07_;
  (* force_downto = 32'd1 *)
  (* src = "src/counter.v:17.16-17.27|/home/alnurn/.local/bin/../share/yosys/techmap.v:270.23-270.24" *)
  wire [7:0] _08_;
  (* force_downto = 32'd1 *)
  (* src = "src/counter.v:17.16-17.27|/home/alnurn/.local/bin/../share/yosys/techmap.v:270.26-270.27" *)
  wire [7:0] _09_;
  reg _10_;
  reg _11_;
  reg _12_;
  reg _13_;
  reg _14_;
  reg _15_;
  (* src = "src/counter.v:5.13-5.16" *)
  input clk;
  wire clk;
  (* src = "src/counter.v:9.11-9.18" *)
  wire [7:0] counter;
  (* src = "src/counter.v:4.20-4.28" *)
  output [7:0] data_out;
  wire [7:0] data_out;
  (* src = "src/counter.v:3.13-3.20" *)
  input do_incr;
  wire do_incr;
  input [5:0] moosic_key;
  wire [5:0] moosic_key;
  (* src = "src/counter.v:6.13-6.18" *)
  input rst_n;
  wire rst_n;
  assign _08_[0] = ~counter[0];
  assign _09_[1] = counter[1] ^ counter[0];
  assign _00_ = ~(counter[1] & counter[0]);
  assign _09_[2] = ~(_00_ ^ counter[2]);
  assign _01_ = counter[2] & ~(_00_);
  assign _09_[3] = _01_ ^ counter[3];
  assign _02_ = ~(counter[3] & counter[2]);
  assign _03_ = _02_ | _00_;
  assign _09_[4] = ~(_03_ ^ counter[4]);
  assign _04_ = counter[4] & ~(_03_);
  assign _09_[5] = _04_ ^ counter[5];
  assign _05_ = ~(counter[5] & counter[4]);
  assign _06_ = _05_ | _03_;
  assign _09_[6] = ~(_06_ ^ counter[6]);
  assign _07_ = counter[6] & ~(_06_);
  assign _09_[7] = _07_ ^ counter[7];
  reg \counter_reg[2] ;
  (* src = "src/counter.v:13.1-19.4" *)
  always @(posedge clk)
    if (!rst_n) \counter_reg[2]  <= 1'h0;
    else if (do_incr) \counter_reg[2]  <= _09_[2];
  assign counter[2] = \counter_reg[2] ;
  (* src = "src/counter.v:13.1-19.4" *)
  always @(posedge clk)
    if (!rst_n) _15_ <= 1'h0;
    else if (do_incr) _15_ <= _09_[3];
  (* src = "src/counter.v:13.1-19.4" *)
  always @(posedge clk)
    if (!rst_n) _14_ <= 1'h0;
    else if (do_incr) _14_ <= _09_[4];
  (* src = "src/counter.v:13.1-19.4" *)
  always @(posedge clk)
    if (!rst_n) _13_ <= 1'h0;
    else if (do_incr) _13_ <= _09_[5];
  (* src = "src/counter.v:13.1-19.4" *)
  always @(posedge clk)
    if (!rst_n) _11_ <= 1'h0;
    else if (do_incr) _11_ <= _09_[6];
  (* src = "src/counter.v:13.1-19.4" *)
  always @(posedge clk)
    if (!rst_n) _12_ <= 1'h0;
    else if (do_incr) _12_ <= _09_[7];
  (* src = "src/counter.v:13.1-19.4" *)
  always @(posedge clk)
    if (!rst_n) _10_ <= 1'h0;
    else if (do_incr) _10_ <= _08_[0];
  reg \counter_reg[1] ;
  (* src = "src/counter.v:13.1-19.4" *)
  always @(posedge clk)
    if (!rst_n) \counter_reg[1]  <= 1'h0;
    else if (do_incr) \counter_reg[1]  <= _09_[1];
  assign counter[1] = \counter_reg[1] ;
  assign counter[0] = _10_ ~^ moosic_key[0];
  assign counter[5] = _13_ ~^ moosic_key[3];
  assign counter[4] = _14_ ~^ moosic_key[4];
  assign counter[3] = _15_ ~^ moosic_key[5];
  assign counter[6] = _11_ ^ moosic_key[1];
  assign counter[7] = _12_ ^ moosic_key[2];
  assign _08_[7:1] = counter[7:1];
  assign _09_[0] = _08_[0];
  assign data_out = counter;
endmodule
