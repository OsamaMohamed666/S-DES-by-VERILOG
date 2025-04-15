module Dec_SDES(
	input						clk,	
	input						rstn,	
	input						en,	
	input			[7:0]		k1,
	input			[7:0]		k2,
	input			[7:0]		cipher_text	,
	output	reg		[7:0]		pln_txt		
	
	);

// First we need to get the swap or switch temp (SW) from second key & cipher_text
reg		[7:0]	swap_tmp;
reg		[7:0]	expand_2;
reg		[7:0]	xor_o_2;
reg		[3:0]	xor_o_lhf_2,xor_o_rhf_2;

wire	[1:0]	s0_2,s1_2;
reg		[3:0]	s0s1_2,p_s0s1_2,xor_o2_2;
reg 	[7:0]	comb_tmp_2;


always @ (*)
	begin 
		comb_tmp_2 = {cipher_text[6],cipher_text[2],cipher_text[5],cipher_text[7]
					,cipher_text[4],cipher_text[0],cipher_text[3],cipher_text[1]};
		swap_tmp[3:0] = comb_tmp_2[3:0]; // first half
		
		expand_2 ={swap_tmp[0],swap_tmp[3],swap_tmp[2],swap_tmp[1],swap_tmp[2],swap_tmp[1],swap_tmp[0],swap_tmp[3]};
		xor_o_2 = expand_2 ^ k2;
		xor_o_lhf_2 = xor_o_2[7:4];
		xor_o_rhf_2 = xor_o_2[3:0];
	end 
	
	//Getting output from S_Boxes decoders 
S0 U1 (.xor_o_lhf(xor_o_lhf_2),.en(en),.out(s0_2));
S1 U2 (.xor_o_rhf(xor_o_rhf_2),.en(en),.out(s1_2));

always @ (*)
	begin 
		s0s1_2 = {s0_2,s1_2};
		p_s0s1_2 = {s0s1_2[2],s0s1_2[0],s0s1_2[1],s0s1_2[3]};
		xor_o2_2 = comb_tmp_2[7:4];
		swap_tmp[7:4] = xor_o2_2 ^ p_s0s1_2; //second half
	end 
	

// Now we got whole swap temp (SW) bits

// Second stage to get the initial permutation inverse 

wire	[1:0]	s0,s1;
reg		[3:0]	s0s1,p_s0s1,xor_o2;
reg 	[7:0]	comb_tmp;

reg		[7:0]	ip_inv;
reg		[7:0]	expand;
reg		[7:0]	xor_o;
reg		[3:0]	xor_o_lhf,xor_o_rhf;

always @(*)
	begin 
		comb_tmp = {swap_tmp[3:0],swap_tmp[7:4]};
		ip_inv[3:0] = comb_tmp[3:0]; // first 4 bits of IP inverse
		
		expand = {ip_inv[0],ip_inv[3],ip_inv[2],ip_inv[1],ip_inv[2],ip_inv[1],ip_inv[0],ip_inv[3]};
		xor_o = expand ^ k1;
		xor_o_lhf = xor_o[7:4];
		xor_o_rhf = xor_o[3:0];
	end 
	
	// Getting output from S_BOXES decoders
S0 U3 (.xor_o_lhf(xor_o_lhf),.en(en),.out(s0));
S1 U4 (.xor_o_rhf(xor_o_rhf),.en(en),.out(s1));

always @ (*)
	begin 
		s0s1 = {s0,s1};
		p_s0s1 = {s0s1[2],s0s1[0],s0s1[1],s0s1[3]};
		xor_o2 = comb_tmp[7:4];
		ip_inv[7:4] = xor_o2 ^ p_s0s1; // second 4 bits of IP Inverse
	end 

// THIRD STAGE GENERATING THE OUTPUT PLAIN TEXT 

always @ (posedge clk or negedge rstn)
	begin
		if (!rstn)
			pln_txt <=0;
		else if (en)
			pln_txt <= {ip_inv[4],ip_inv[7],ip_inv[5],ip_inv[3]
					   ,ip_inv[1],ip_inv[6],ip_inv[0],ip_inv[2]};
	end 
	
endmodule 
		
		