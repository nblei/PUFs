module switch
(
    input  [1:0] i,
    input        b,
    output [1:0] o
);

mux2 u_mux_top(.i(i), .sel(b), .o(o[0]));
mux2 u_mox_bot(.i({i[0], i[1]}), .sel(b), .o(o[1]));


endmodule : switch
