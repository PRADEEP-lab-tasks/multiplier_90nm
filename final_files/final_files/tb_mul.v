`timescale 1ns/1ps
module tb_mul;
  parameter W = 16;
  reg               clk, rst_n, valid_in;
  reg  [W-1:0]      a, b;
  wire              valid_out;
  wire [2*W-1:0]    y;

  multiplier #(.W(W)) dut (
    .clk       (clk),
    .rst_n     (rst_n),
    .valid_in  (valid_in),
    .a         (a),
    .b         (b),
    .valid_out (valid_out),
    .y         (y)
  );

  initial clk = 0;
  always #5 clk = ~clk;  // 100 MHz

  initial begin
    rst_n     = 0;
    valid_in  = 0;
    a         = 0;
    b         = 0;
    repeat (3) @(posedge clk);
    rst_n = 1;

    // Basic vectors
    apply_vec(0,0);
    apply_vec(1,0);
    apply_vec(1,1);
    apply_vec(16'hFFFF, 16'h0002);

    // Random
    repeat (100) apply_vec($urandom, $urandom);

    repeat (5) @(posedge clk);
    $display("tb_mul PASS");
    $finish;
  end

  task apply_vec(input [W-1:0] aa, input [W-1:0] bb);
    reg [2*W-1:0] expected;
    begin
      @(posedge clk);
      a        <= aa;
      b        <= bb;
      valid_in <= 1'b1;
      expected = aa * bb;
      @(posedge clk);
      valid_in <= 1'b0;
      @(posedge clk);
      if (valid_out !== 1'b1 || y !== expected) begin
        $display("ERROR: a=%0d b=%0d got y=%0d exp=%0d", aa, bb, y, expected);
        $stop;
      end
    end
  endtask

endmodule
