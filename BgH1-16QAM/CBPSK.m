 %BPSK Communication System
clear;
%��������
r=0.5;%����ϵ��
delay=6;%�߰곤��Ϊ5
sample=8;%��������Ϊ8
N=1000;%����һ�������г���

Eb2N0=[-9,-8,-7,-6,-5,-4,-3,-2,-1,0,1,2,3,4,5,6,7,8,9];%��������У���ת����delta
for i=1:1:length(Eb2N0)
    sigma(i)=(0.5^0.5)* 10^(-Eb2N0(i)/20);
end;

src=randsrc(1,N,[0,1;0.5,0.5]);%����0��1����źţ����ʸ�Ϊ0.5

for i=1:1:N%���е��ƣ�����BPSK���Ƽ�Ϊ��0��Ϊ+1��1��Ϊ-1
    if src(i)==1
       srcmodu(i)=-1;
   else srcmodu(i)=1;
   end
end

srcup=upsample(srcmodu,sample);%sample���ϲ���

sqrfilter=rcosine(1,sample,'sqrt',r,delay);%����ƽ����������ʱ������

srcfilter=conv(srcup,sqrfilter);%ƽ�����������˲�/�����˲�

srccut=srcfilter(sample*delay+1:(length(srcfilter)-sample*delay));%���˲�֮����
%��ǰ��sample*delay�������ν�ȡ

for k=1:1:length(sigma)%��������Ƚ��б���
    trans=srccut+sigma(k)*randn(1,length(srccut));%���벻ͬ������
    recfilter=conv(trans,sqrfilter);%���ջ�����ƥ���˲�
    reccut=recfilter(sample*delay+1:(length(recfilter)-sample*delay));%���˲�֮
 %������ǰ��sample*delay�������ν�ȡ

    for i=1:sample:length(reccut)%�²���
        recdown(floor(i/sample)+1)=reccut(i);
    end;
    
    for i=1:1:length(recdown)%�о�������Ϊ0
        if recdown(i)>0
            recdemo(i)=1;
        else
            recdemo(i)=-1;
        end
    end;
    
    for i=1:1:length(recdemo)%���
        if recdemo(i)==1;
            rec(i)=0;
        else
            rec(i)=1;
        end
    end;
    correct=0;%������Դ������bit������ȷ�ĸ���
    for i=1:1:length(src)
        if src(i)==rec(i)
            correct=correct+1;
        end
    end;
    error(k)=(length(src)-correct)/length(src);%���������
end;
   
    for i=1:1:length(Eb2N0) %������������������
        y(i)=0.5*erfc((10^(Eb2N0(i)/10))^0.5);
    end;
    
semilogy(Eb2N0,error,'go-');%��ͼ
hold on;   
semilogy(Eb2N0,y,'rx-');
xlabel('Eb2N0/dB');
ylabel('Pe');
title(['BER for BPSK,N=',int2str(N)]);
axis([-9,9,10^(-5),1]);
grid on;
legend('experimental','theoretical');