`timescale 1ns/1ps
module multiplier #(
  parameter W = 16
)(
  input  wire              clk,
  input  wire              rst_n,
  input  wire              valid_in,
  input  wire [W-1:0]      a,
  input  wire [W-1:0]      b,
  output reg               valid_out,
  output reg [2*W-1:0]     y
);

  wire [2*W-1:0] prod_d;

  assign prod_d = a * b;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      y         <= {2*W{1'b0}};
      valid_out <= 1'b0;
    end else begin
      y         <= prod_d;
      valid_out <= valid_in;
    end
  end

endmodule
