%% created by ACJ
close;clc;clear;
%% read letters from a file
txt = '';
fileID = fopen('Youth.txt');
if (fileID==-1)
    disp('文件读取失败！！！');
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
fprintf(['综上所述，\n哈夫曼编码平均码长 : ',num2str(huffman_avglen),'\n等长编码平均码长 : ',num2str(equal_length_code_avelen),'\n']);