module g2b(
  input [3:0] in,
  output [3:0] out
);
  assign out[3] = in[3];
  assign out[2] = out[3] ^ in[2];
  assign out[1] = out[2] ^ in[1];
  assign out[0] = out[1] ^ in[0];
endmodule
