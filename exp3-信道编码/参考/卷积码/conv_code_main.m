clc
clear all
global prev_state;
global prev_state_outbits;
ConvCodeGenPoly = [1 0 1;1 1 1];
Contraint_Length = size(ConvCodeGenPoly,2);
State_Num = 2^(Contraint_Length-1);
prev_state = zeros(State_Num, 2);
prev_state_outbits = zeros(State_Num, 2, 2);
for state = 0:State_Num-1
   state_bits = (fliplr(kron(dec2bin(state,Contraint_Length - 1),1))~=48);
   input_bit = state_bits(1);
   for transition = 0:1
      prev_state_bits = [state_bits(2:Contraint_Length - 1) transition];
      prev_state(state+1, transition+1) = base2dec(fliplr(prev_state_bits)+48,2);
      
      prev_state_outbits(state+1, transition+1, 1) = 2*(rem(sum(ConvCodeGenPoly(1,:).* ...
         [input_bit prev_state_bits]),2)) - 1;
      prev_state_outbits(state+1, transition+1, 2) = 2*(rem(sum(ConvCodeGenPoly(2,:).* ...
         [input_bit prev_state_bits]),2)) - 1;
   end
end
Ebn0_dB = -10:0;
BER_Soft = zeros(1,length(Ebn0_dB));
loop = 0;
Num_Bits_Sim = 1E4;
for snr = 10.^(Ebn0_dB/10)
    N0 = 1/snr;
    loop = loop + 1;
    inf_bits = randi([0,1],1, Num_Bits_Sim);
    number_rows = size(ConvCodeGenPoly, 1);
    number_bits = size(ConvCodeGenPoly,2) + length(inf_bits) - 1;
    uncoded_bits = zeros(number_rows, number_bits);
    for row=1:number_rows
       uncoded_bits(row,1:number_bits) = rem(conv(inf_bits, ConvCodeGenPoly(row,:)),2);
    end
    coded_bits = uncoded_bits(:);
    modu_sym = 2*coded_bits - 1;
    rec_signal = modu_sym + sqrt(N0/2)*randn(length(modu_sym),1); 
    softdec_bits = viterbi_decode(rec_signal);
    BER_Soft(loop) = symerr(inf_bits,softdec_bits(1:Num_Bits_Sim))/Num_Bits_Sim;
end
semilogy(Ebn0_dB,BER_Soft)
xlabel('Eb/N0')
ylabel('BER')