function [people] = process_rcp0( FileName,L)
fid = fopen(FileName(L+1,:)); %打开文本文件
str=fgetl(fid);
people = str2num(str);
end
