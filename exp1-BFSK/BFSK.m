clear;
clc;
close;
M = 2;         % Modulation order
k = log2(M);   % Bits per symbol
Fs = 16;       % Sample rate (Hz)
nsamp = 8;     % Number of samples per symbol
freqsep = 10;  % Frequency separation (Hz)
EbNo = (0:20);
BER = zeros(21,1);
BER_theory = zeros(21,1);

for i = 1:21
    data = randi([0 M-1],5000,1);
    txsig = fskmod(data,M,freqsep,nsamp,Fs);
    rxSig  = awgn(txsig,EbNo(i)+10*log10(k)-10*log10(nsamp),...
    'measured',[],'dB');
    dataOut = fskdemod(rxSig,M,freqsep,nsamp,Fs);
    [num,BER(i)] = biterr(data,dataOut);
    BER_theory(i) = berawgn(EbNo(i),'fsk',M,'noncoherent');
end
[BER,BER_theory] % 输出结果
figure % opens new figure window
plot(EbNo,BER,'b--o',EbNo,BER_theory,'r');
xlabel('EbNo')
ylabel('BER')
legend('实际BER','理论BER')