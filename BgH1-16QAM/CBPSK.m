 %BPSK Communication System
clear;
%参数设置
r=0.5;%滚降系数
delay=6;%边瓣长度为5
sample=8;%采样速率为8
N=1000;%都用一样的序列长度

Eb2N0=[-9,-8,-7,-6,-5,-4,-3,-2,-1,0,1,2,3,4,5,6,7,8,9];%信噪比序列，并转化成delta
for i=1:1:length(Eb2N0)
    sigma(i)=(0.5^0.5)* 10^(-Eb2N0(i)/20);
end;

src=randsrc(1,N,[0,1;0.5,0.5]);%产生0，1随机信号，概率各为0.5

for i=1:1:N%进行调制，对于BPSK调制即为将0变为+1，1变为-1
    if src(i)==1
       srcmodu(i)=-1;
   else srcmodu(i)=1;
   end
end

srcup=upsample(srcmodu,sample);%sample倍上采样

sqrfilter=rcosine(1,sample,'sqrt',r,delay);%生成平方根升余弦时域序列

srcfilter=conv(srcup,sqrfilter);%平方根升余弦滤波/成型滤波

srccut=srcfilter(sample*delay+1:(length(srcfilter)-sample*delay));%将滤波之后序
%列前后sample*delay长的两段截取

for k=1:1:length(sigma)%对于信噪比进行遍历
    trans=srccut+sigma(k)*randn(1,length(srccut));%加入不同的噪声
    recfilter=conv(trans,sqrfilter);%接收机进行匹配滤波
    reccut=recfilter(sample*delay+1:(length(recfilter)-sample*delay));%将滤波之
 %后序列前后sample*delay长的两段截取

    for i=1:sample:length(reccut)%下采样
        recdown(floor(i/sample)+1)=reccut(i);
    end;
    
    for i=1:1:length(recdown)%判决，门限为0
        if recdown(i)>0
            recdemo(i)=1;
        else
            recdemo(i)=-1;
        end
    end;
    
    for i=1:1:length(recdemo)%解调
        if recdemo(i)==1;
            rec(i)=0;
        else
            rec(i)=1;
        end
    end;
    correct=0;%计算信源和信宿bit序列正确的个数
    for i=1:1:length(src)
        if src(i)==rec(i)
            correct=correct+1;
        end
    end;
    error(k)=(length(src)-correct)/length(src);%算出误码率
end;
   
    for i=1:1:length(Eb2N0) %计算理论误码率曲线
        y(i)=0.5*erfc((10^(Eb2N0(i)/10))^0.5);
    end;
    
semilogy(Eb2N0,error,'go-');%画图
hold on;   
semilogy(Eb2N0,y,'rx-');
xlabel('Eb2N0/dB');
ylabel('Pe');
title(['BER for BPSK,N=',int2str(N)]);
axis([-9,9,10^(-5),1]);
grid on;
legend('experimental','theoretical');