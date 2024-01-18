# SPDX-FileCopyrightText: © 2023 Uri Shaked <uri@tinytapeout.com>
# SPDX-License-Identifier: MIT

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_adder(dut):
  dut._log.info("Start")
  
  # Our example module doesn't use clock and reset, but we show how to use them here anyway.
  clock = Clock(dut.clk, 10, units="us")
  cocotb.start_soon(clock.start())

  # Reset
  dut._log.info("Reset")
  dut.ena.value = 1
  dut.ui_in.value = 0
  dut.uio_in.value = 0
  dut.rst_n.value = 0
  await ClockCycles(dut.clk, 10)
  dut.rst_n.value = 1

  # Set the key
  # 39 in hexa, and two bit of control
  # 11 1001 10 => 0xe6
  dut.ui_in.value = 0xe6
  await ClockCycles(dut.clk, 10)

  # Set the input values, wait one clock cycle, and check the output
  dut._log.info("Test")
  dut.ui_in.value = 1
  dut.uio_in.value = 0

  for i in range(10):
    print("Value at cycle {}: {}".format(i, dut.uo_out.value))
    await ClockCycles(dut.clk, 1)
    assert dut.uo_out.value == i

  # Set the wrong key
  dut.ui_in.value = 0xaa
  await ClockCycles(dut.clk, 10)

  # Set the input values, wait one clock cycle, and check the output
  dut._log.info("Test")
  dut.ui_in.value = 1
  dut.uio_in.value = 0

  for i in range(3):
    print("Value at cycle {}: {}".format(i, dut.uo_out.value))
    await ClockCycles(dut.clk, 1)
    # Test that this is always wrong. Of course there could be collisions
    assert dut.uo_out.value != i
