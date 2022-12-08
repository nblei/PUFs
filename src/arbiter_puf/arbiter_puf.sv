module arbiter_puf
#(parameter int N)
(
    // Reproduce the race signal in order to prevent logic synthesis optimizations
    input  [1:0]   race_signal_i,
    input  [N-1:0] challenge_i,
    output         response_o
);

logic [1:0] mux_val [N];

switch u_switch0(.i(race_signal_i), .b(challenge_i[0]), .o(mux_val[0]));
generate
for (genvar i = 1; i < N-1; i++) begin : gen_switches
    switch u_switch_(.i(mux_val[i-1]), .b(challenge_i[i]), .o(mux_val[i]));
end
endgenerate
switch u_switchNm1(.i(mux_val[N-2]), .b(challenge_i[N-1]), .o(mux_val[N-1]));

logic d, g;
assign d = mux_val[N-1][0];
assign g = mux_val[N-1][1];

logic response_q;

always_ff @(posedge g) begin
    response_q <= d;
end

assign response_o = response_q;

endmodule : arbiter_puf
