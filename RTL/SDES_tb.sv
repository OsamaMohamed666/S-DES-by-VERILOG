module SDES_tb();

//Inputs 
bit clk,rstn;
bit [9:0] i_key;
bit en_dec,en_enc;
bit [7:0] i_enc_pln_txt;
bit [7:0] i_dec_cipher_text;
//Outputs
logic [7:0] o_dec_pln_txt;
logic [7:0] o_enc_cipher_text;


initial 
	begin 
		// INITIALIZATION
		clk=0;
		rstn=0; // asserting reset
		en_enc =0; //start encoding
		en_dec =0;
		i_key =	10'b1010000010; // for both 
		i_enc_pln_txt = 8'b0; 
		i_dec_cipher_text=0;
		#20
		rstn=1; // deasserting 
		
		// *****************NOW START ENCODING TO TEST DECODING*****************
		en_enc =1; 
		i_enc_pln_txt = $urandom; 
		#20
		
		// TURN ON DECODING TO BEGIN TESTING, TURINING OFF ENCODING
		en_enc=0;
		en_dec=1;
		i_dec_cipher_text = o_enc_cipher_text; // getting output of encoder as input for decoder
		#20
		
		if (o_dec_pln_txt == i_enc_pln_txt)
			$display("CORRECT DECODING:output plain text of decoder = %0b, input plain text of encoder = %0b @%0t ns",o_dec_pln_txt,i_enc_pln_txt,$time);
		else 
			$display("WRONG DECODING:output plain text of decoder = %0b, input plain text of encoder = %0b @%0t ns",o_dec_pln_txt,i_enc_pln_txt,$time);
		
		// *****************NOW START DECODING TO TEST ENCODING*****************
		i_dec_cipher_text = $urandom;
		#20
		
		// TURN ON ENCODING TO BEGIN TESTING, TURINING OFF DECODING
		en_enc=1;
		en_dec=0;
		i_enc_pln_txt = o_dec_pln_txt;
		#20
		
		if (o_enc_cipher_text == i_dec_cipher_text)
			$display("CORRECT ENCODING:output cipher text of encoder = %0b, input cipher text of decoder = %0b @%0t ns",o_enc_cipher_text,i_dec_cipher_text,$time);
		else 
			$display("WRONG ENCODING:output cipher text of encoder = %0b, input cipher text of decoder = %0b @%0t ns",o_enc_cipher_text,i_dec_cipher_text,$time);
			

		#100
		$finish;
	end 
		






always #10 clk=~clk;


SDES_top DUT (
.clk(clk),
.rstn(rstn),
.i_key(i_key),
.en_enc(en_enc),
.en_dec(en_dec),
.i_enc_pln_txt(i_enc_pln_txt),
.o_dec_pln_txt(o_dec_pln_txt),
.o_enc_cipher_text(o_enc_cipher_text),
.i_dec_cipher_text(i_dec_cipher_text)
);

endmodule 