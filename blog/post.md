# Applying logic locking to a TinyTapeout design

When creating a design, most of us are not in possession of the lithography and manufacturing tools necessary to actually create the chip: we send our design to a foundry, that is going to make the chip for us.

This requires a great deal of trust in the toolchain and the foundry: a malicious actor could introduce backdoors, or just steal the design to reuse it themselves.
For security-conscious designers, countermeasures are necessary.

One such countermeasure is logic locking: we are going to lock our design, such that it is not going to work without the secret key.
We built a yosys plugin [just for that](https://github.com/Coloquinte/moosic-yosys-plugin).
To illustrate, let's make a design on [TinyTapeout](https://tinytapeout.com/), lock it and synthetize it all the way to silicon.

Let's start with a toy design. This is a counter, that is incremented at each clock cycle where `do_incr` is set:
```verilog
module counter (
    input wire do_incr,
    output wire [7:0] data_out,
    input wire clk,
    input wire rst_n
);

reg [7:0] counter;
assign data_out = counter;

always @(posedge clk) begin
    if (!rst_n) begin
        counter <= 0;
    end else if (do_incr) begin
        counter <= counter + 1;
    end
end
endmodule
```

Having installed Yosys and [the Moosic plugin](https://github.com/Coloquinte/moosic-yosys-plugin), let's synthetize our counter with the default library:
```tcl
read_verilog src/counter.v
synth
```

Now let's apply locking and save it. To fit in our 8-bit input port, I picked a small 6-bit key. Make it a lot bigger if you use it in the wild!
```tcl
logic_locking -key-bits 6 -key 39 -target corruption
write_verilog src/locked_counter.v
```

Our module is now a netlist, with an additional port `moosic_key`:
```verilog
module counter(do_incr, data_out, clk, rst_n, moosic_key);
  input do_incr;
  output [7:0] data_out;
  input clk;
  input rst_n;
  input [5:0] moosic_key;
```



