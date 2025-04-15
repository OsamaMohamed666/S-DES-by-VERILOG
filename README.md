# S-DES (Simplified-Data Encryption standard) -by-VERILOG 

## The S-DES encryption algorithm: 
1) 8-bit block of plaintext 
2) 10-bit key as input  
3) Produces an 8-bit block of ciphertext as output


## The Encryption algorithm involves five functions: 
1) An initial permutation (IP); 
2) A complex function labeled fK, which involves both permutation and substitution operations and depends on a key input. 
3) A simple permutation function that switches (SW) the two halves of the data; 
4) The function fK again. 
5) A permutation function that is the inverse of the initial permutation (IP–1).


## Block Diagram 
##### Decryption is the inverse, as shown in the next figure.
![image](https://github.com/user-attachments/assets/83ce7ba1-feed-476e-84dc-a6efbdcb393f)


## A Simple Testbench to Verify That Encryption and Decryption Operations Are Functionally Complementary    

  ### Simulation on Questa-sim
  ##### LOG 
  ![image](https://github.com/user-attachments/assets/4c10922a-5468-49e6-92cf-ebef5ee6e3c8)

  ##### WAVEFORM
  ![image](https://github.com/user-attachments/assets/87f15eef-121d-4dc9-91bb-3ada300f5134)



