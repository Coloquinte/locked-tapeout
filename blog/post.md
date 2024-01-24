# Applying logic locking to a TinyTapeout design with Moosic

When creating a design, most of us are not in possession of the lithography and manufacturing tools necessary to actually create the chip: we send our design to a foundry, that is going to make the chip for us.

This requires a great deal of trust in the toolchain and the foundry: a malicious actor could introduce backdoors, or just steal the design to reuse it themselves.
For security-conscious designers, countermeasures are necessary.

One such countermeasure is logic locking: we are going to lock our design, so that it does not work without a secret key.
We do it by adding or changing some gates in the design to use the key: if the key is incorrect, the design behaviour will be completely modified.
This is going to make it harder to reuse the design without authorization (you have to find the key) or to introduce backdoors (you have to understand what it does).

![My Image](XOR_NXOR_insertion.svg)

We built a Yosys plugin [to do just that](https://github.com/Coloquinte/moosic-yosys-plugin).
The plugin provides a `logic_locking` command that will mangle the design as much as it can.

To illustrate, let's make a design on [TinyTapeout](https://tinytapeout.com/), lock it and synthetize it all the way to silicon.

## Locking a design

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

We run Yosys with the [Moosic plugin](https://github.com/Coloquinte/moosic-yosys-plugin). Since logic locking works on a netlist, we first synthetize our counter with the default library:
```tcl
read_verilog src/counter.v
synth
```

Now we apply locking and save our netlist. To fit in our 8-bit input port, I picked a small 6-bit key. Make it a lot bigger if you use it in the wild! And don't lose the key.
```tcl
logic_locking -key-bits 6 -key 39
write_verilog src/locked_counter.v
```

Looking at the file, our module is now a netlist with an additional port `moosic_key`. Following TinyTapeout's philosophy, it all runs as a [Github action](https://github.com/Coloquinte/locked-tapeout/actions/runs/7582853506/workflow).
```verilog
module counter(do_incr, data_out, clk, rst_n, moosic_key);
  input do_incr;
  output [7:0] data_out;
  input clk;
  input rst_n;
  input [5:0] moosic_key;
```

## TinyTapeout

With TinyTapeout, we can synthetize this design to silicon.
We will have to make a wrapper in order to load the key on our design... and test that our design works as expected when the key is provided.
The [main project file](https://github.com/Coloquinte/locked-tapeout/blob/main/src/project.v) will be responsible for loading the key.
We are going to keep it simple and read the key directly from the primary inputs. On a production design, getting the key in would be part of the boot sequence.

To make sure it all works, we write a [testbench](https://github.com/Coloquinte/locked-tapeout/blob/main/test/test.py) that checks that our counter behaves as expected... and is indeed broken with the wrong key.

And finally we have the full tapeout! The code for the TinyTapeout project is available [here](https://github.com/Coloquinte/locked-tapeout).
If you want to go further, have a look at [the project page](https://github.com/Coloquinte/moosic-yosys-plugin) or [our Free Silicon Conference presentation](https://peertube.f-si.org/videos/watch/7f250190-6d8f-4a67-8ed6-d07deda7fba0).
For power users, the plugin provides a lot of additional options to pick your security metrics, or to balance security and performance.
Logic locking is an active area of research, and we are happy to provide an open-source tool to apply it to your designs.
