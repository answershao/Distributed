function [people] = process_rcp0( FileName,L)
fid = fopen(FileName(L+1,:)); %���ı��ļ�
str=fgetl(fid);
people = str2num(str);
end
