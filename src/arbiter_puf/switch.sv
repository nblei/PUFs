`include "igzo_cells.sv"
module switch
(
    input  [1:0] i,
    input        b,
    output [1:0] o
);

logic [1:0] ob;
mux u_mux_top(.S(b), .A(i[0]), .B(i[1]), .Y(ob[0]));
mux u_mux_bot(.S(b), .A(i[1]), .B(i[0]), .Y(ob[1]));

buf u_buf_top(.A(ob[0]), .Y(o[0]));
buf u_buf_bot(.A(ob[1]), .Y(o[1]));

endmodule : switch
