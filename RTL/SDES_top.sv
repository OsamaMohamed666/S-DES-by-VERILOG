module SDES_top(

	input						clk,	
	input						rstn,	
	input			[9:0]		i_key,	
	input						en_enc,	// encoder enable
	input						en_dec,	// decoder enable 
	input			[7:0]		i_enc_pln_txt,	
	input			[7:0]		i_dec_cipher_text,	
	output			[7:0]		o_dec_pln_txt,	
	output			[7:0]		o_enc_cipher_text	
	);
	

ENC_SDES_top ENC_DUT (
.clk(clk),
.rstn(rstn),
.i_key(i_key),
.en(en_enc),
.pln_txt(i_enc_pln_txt),
.cipher_text(o_enc_cipher_text)
);


Dec_SDES_top DEC_DUT (
.clk(clk),
.rstn(rstn),
.i_key(i_key),
.en(en_dec),
.cipher_text(i_dec_cipher_text),
.pln_txt(o_dec_pln_txt)
);


endmodule 
