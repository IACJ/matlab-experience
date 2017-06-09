%% created by ACJ
close;clc;clear;
%% read letters from a file
txt = '';
fileID = fopen('Youth.txt');
if (fileID==-1)
    disp('�ļ���ȡʧ�ܣ�����');
    return ;
end
txt = textscan(fileID,'%c');
fclose(fileID);
txt = txt{1};
txt = txt(isletter(txt));
txt = lower(txt)'

%% Statistical letters
tabulate(txt(:))
table=tabulate(txt(:));
symbols = table(:,1);
p = cell2mat(table(:,3)) /100;

%% huff code
[dict,huffman_avglen] = huffmandict(symbols,p)
comp = huffmanenco(symbols,dict);

%% equal_length code
equal_length_code_avelen = 5 %  2^4= 16 < 26 <32 = 2^5

%% output
fprintf(['����������\n����������ƽ���볤 : ',num2str(huffman_avglen),'\n�ȳ�����ƽ���볤 : ',num2str(equal_length_code_avelen),'\n']);