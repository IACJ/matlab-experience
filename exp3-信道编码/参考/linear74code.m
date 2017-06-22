clear;clc
G=[1 0 0 0 1 0 1
   0 1 0 0 1 1 1
   0 0 1 0 1 1 0
   0 0 0 1 0 1 1];
H=[G(:,5:7)', eye(3)];
E=[1 0 0 0 0 0 0
   0 1 0 0 0 0 0
   0 0 1 0 0 0 0
   0 0 0 1 0 0 0
   0 0 0 0 1 0 0
   0 0 0 0 0 1 0
   0 0 0 0 0 0 1];
K=size(E,1);
Syndrome=mod(mtimes(E,H'),2);
r=[1 0 1 0 1 1 1];
display('Symdrome','Error pattern')
display(num2str([Syndrome E]))
x=mod(r*H',2);
for kk=1:K
    if Syndrome(kk,:)==x
        idex=kk
    end
end
Syndrome=Syndrome(idex,:)
error=E(idex,:)
cword=xor(r,error)
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
C_total=mod(d*G,2)