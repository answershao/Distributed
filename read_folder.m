function [FileName] = read_folder(FolderPath)
%read_folder �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
% ��� FileName ���� ����ļ�����ַ
FolderPath1 = strcat(FolderPath, '\\*.sm');
Content=dir(FolderPath1);
NumOfFile=size(Content,1);
FileName = [];
for i=1:NumOfFile
    str=strcat(FolderPath,'\\',Content(i).name);
    FileName = [FileName; str];
end
end
