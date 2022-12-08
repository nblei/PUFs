module mux2
(
    input [1:0] i,
    input       sel,
    output      o
);

assign o = i[sel];

endmodule : mux2
