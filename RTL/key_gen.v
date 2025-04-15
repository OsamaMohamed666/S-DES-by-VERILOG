module key_gen(
	input		[9:0]	i_key,
	output	reg	[7:0]	k1,
	output	reg	[7:0]	k2
	);

//some temps
reg		[9:0]	p_key;
reg		[4:0]	r_hf11,r_hf12; //2 left shift rounded halves of permuted key for 1st key
reg		[4:0]	r_hf21,r_hf22; //2 left shift rounded halves of permuted key for 2nd key
reg		[9:0]	two_h1; // two halves
reg		[9:0]	two_h2; // two halves

// GENERATING TWO KEY
always @(*)
	begin 
				p_key = {i_key[7],i_key[5],i_key[8],i_key[3],i_key[6],i_key[0]
						,i_key[9],i_key[1],i_key[2],i_key[4]};
				//GENERATION OF KEY 1 		
				r_hf11 = {p_key[8:5],p_key[9]};
				r_hf12 = {p_key[3:0],p_key[4]};
				two_h1 = {r_hf11,r_hf12};
				k1 = {two_h1[4],two_h1[7],two_h1[3],two_h1[6],two_h1[2]
					,two_h1[5],two_h1[0],two_h1[1]};
				//GENERATION OF KEY 2
				r_hf21 = {r_hf11[2:0],r_hf11[4:3]};
				r_hf22 = {r_hf12[2:0],r_hf12[4:3]};
				two_h2 = {r_hf21,r_hf22};
				k2 = {two_h2[4],two_h2[7],two_h2[3],two_h2[6],two_h2[2]
					,two_h2[5],two_h2[0],two_h2[1]}; 
	end

endmodule