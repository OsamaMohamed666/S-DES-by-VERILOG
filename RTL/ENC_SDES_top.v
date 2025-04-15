module ENC_SDES_top(

	input						clk,	
	input						rstn,	
	input						en,	
	input			[7:0]		pln_txt,	
	input			[9:0]		i_key,	
	output			[7:0]		cipher_text	
	);
	
wire [7:0] k1,k2;

ENC_SDES U1 (
.clk(clk),
.rstn(rstn),
.en(en),
.pln_txt(pln_txt),
.k1(k1),
.k2(k2),
.cipher_text(cipher_text)
);

key_gen U2 (
.k1(k1),
.k2(k2),
.i_key(i_key)
);

endmodule 