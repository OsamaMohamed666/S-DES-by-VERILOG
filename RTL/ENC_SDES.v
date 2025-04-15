module ENC_SDES(
	
	input						clk,	
	input						rstn,	
	input						en,	
	input			[7:0]		pln_txt,	
	input			[7:0]		k1,	
	input			[7:0]		k2,	
	output	reg		[7:0]		cipher_text	
	
	);
			
//	ENCYRPTING THE PLAIN TEXT INTO CIPHER TEXT 
//**********************************WITH THE FIRST KEY**********************************
reg		[7:0]	ip;
reg		[7:0]	expand;
reg		[7:0]	xor_o;
reg		[3:0]	xor_o_lhf,xor_o_rhf;


always @(*)
	begin 
				ip = {pln_txt[6],pln_txt[2],pln_txt[5],pln_txt[7]
					,pln_txt[4],pln_txt[0],pln_txt[3],pln_txt[1]};
				
				expand = {ip[0],ip[3],ip[2],ip[1],ip[2],ip[1],ip[0],ip[3]};
				xor_o = expand ^ k1;
				xor_o_lhf = xor_o[7:4];
				xor_o_rhf = xor_o[3:0];
	end 

		// Getting output from S_BOXES decoders
wire	[1:0]	s0,s1;
reg		[3:0]	s0s1,p_s0s1,xor_o2;
reg 	[7:0]	comb_tmp,swap_tmp;


S0 U1 (.xor_o_lhf(xor_o_lhf),.en(en),.out(s0));
S1 U2 (.xor_o_rhf(xor_o_rhf),.en(en),.out(s1));

always @ (*)
	begin 
		s0s1 = {s0,s1};
		p_s0s1 = {s0s1[2],s0s1[0],s0s1[1],s0s1[3]};
		xor_o2 = p_s0s1 ^ ip[7:4];
		comb_tmp = {xor_o2,ip[3:0]};
		swap_tmp = {comb_tmp[3:0],comb_tmp[7:4]};
	end 

//**********************************WITH THE SECOND KEY**********************************
reg		[7:0]	expand_2;
reg		[7:0]	xor_o_2;
reg		[3:0]	xor_o_lhf_2,xor_o_rhf_2;


always @(*)
	begin 
				expand_2 = {swap_tmp[0],swap_tmp[3],swap_tmp[2],swap_tmp[1],swap_tmp[2],swap_tmp[1],swap_tmp[0],swap_tmp[3]};
				xor_o_2 = expand_2 ^ k2;
				xor_o_lhf_2 = xor_o_2[7:4];
				xor_o_rhf_2 = xor_o_2[3:0];
			
	end 

// Getting output from S_BOXES decoders
wire	[1:0]	s0_2,s1_2;
reg		[3:0]	s0s1_2,p_s0s1_2,xor_o2_2;
reg 	[7:0]	comb_tmp_2;
reg 	[7:0]	inv_ip; //inverse initial permutation 


S0 U3 (.xor_o_lhf(xor_o_lhf_2),.en(en),.out(s0_2));
S1 U4 (.xor_o_rhf(xor_o_rhf_2),.en(en),.out(s1_2));

always @ (*)
	begin 
		s0s1_2 = {s0_2,s1_2};
		p_s0s1_2 = {s0s1_2[2],s0s1_2[0],s0s1_2[1],s0s1_2[3]};
		xor_o2_2 = p_s0s1_2 ^ swap_tmp[7:4];
		comb_tmp_2 = {xor_o2_2,swap_tmp[3:0]};
		inv_ip	= {comb_tmp_2[4],comb_tmp_2[7],comb_tmp_2[5],comb_tmp_2[3],comb_tmp_2[1]
				 ,comb_tmp_2[6],comb_tmp_2[0],comb_tmp_2[2]};
	end 
				
				
// final result 

always @ (posedge clk or negedge rstn)
	begin 
		if (!rstn)
			cipher_text <=0;
		else if (en)
			cipher_text <= inv_ip;
	end 

endmodule 
	
			
			




