
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
