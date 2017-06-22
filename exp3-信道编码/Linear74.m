clear;clc;close;
%% 初始化
% 生成矩阵G:
G=[1 0 0 0 1 0 1
   0 1 0 0 1 1 1
   0 0 1 0 1 1 0
   0 0 0 1 0 1 1]
% 监督矩阵H:
H=[G(:,5:7)', eye(3)]
% 错误图案E:
E=[1 0 0 0 0 0 0
   0 1 0 0 0 0 0
   0 0 1 0 0 0 0
   0 0 0 1 0 0 0
   0 0 0 0 1 0 0
   0 0 0 0 0 1 0
   0 0 0 0 0 0 1]
% 接收到的r:
r=[1 0 1 0 1 1 1]
%% 纠错

Syndrome=mod(E*H',2);
x=mod(r*H',2);
K=size(E,1);
% 循环遍历，寻找E*H'中 匹配 r*H'的一行
for k=1:K
    if Syndrome(k,:)==x
        idex=k;
    end
end

thisSyndrome=Syndrome(idex,:);
error=E(idex,:)
c=xor(r,error)
%% 输出整个码组
d=[0 0 0 0
0 0 0 1
0 0 1 0
0 0 1 1
0 1 0 0
0 1 0 1
0 1 1 0
0 1 1 1
1 0 0 0
1 0 0 1
1 0 1 0
1 0 1 1
1 1 0 0
1 1 0 1
1 1 1 0
1 1 1 1];
V=mod(d*G,2)