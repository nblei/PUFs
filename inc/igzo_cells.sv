module _buf(input A, output Y);
    BUFx1(.A, .Y);
endmodule : _buf

module mux(input S, A, B, output Y);
    MX2x1(.S, .A, .B, .Y);
endmodule : mux
