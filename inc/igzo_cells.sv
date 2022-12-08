module buf(input A, output Y);
    BUFx1(.A, .Y);
endmodule : buf

module mux(input S, A, B, output Y);
    MX2(.S, .A, .B, .Y);
endmodule : mux
