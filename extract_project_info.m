function [R, r, d, E, delay, ad, people, forestset] = extract_project_info(file, L, num_j)

global resource_cate
FolderPath = strcat('F:\Distributed\QuestionSet-mpsplip\','UncertatintyCase\');
FileName = read_folder(FolderPath); % ���
people = process_rcp0(FileName,L);
%1.4 ��ȡ����Ŀ����
delay = zeros(1,L);
ad = zeros(1,L);
R = zeros(1,resource_cate,L);   %�ֲ���Դ������
r = zeros(num_j, resource_cate, L);  %�ֲ���Դ������
d = zeros(num_j, 1, L);       %��������-���⼯�и�����
E = zeros(num_j, num_j-2, L);   %��������
for i=1:L
    [R1, r1, d1, E1] = process_rcp(FileName(i,:), resource_cate, num_j);  %ʹ�����������ʱ��������ȡ��Ҫ����
    R(:,:,i) = R1;  % ������ά�ȱ�ʾ��Ŀ��
    r(:,:,i) = r1;  % ������ά�ȱ�ʾ��Ŀ��
    d(:,:,i) = d1;  % ������ά�ȱ�ʾ��Ŀ��
    E(:,:,i) = E1;
end

ad = [0,2,0,2,0];
delay = [2,1,3,2,2];

% ˽���޸�����R��r
for i = 1: size(r,3)    % i���
    r(:,4,i) = 0;       %ʹ�� r�ĵ����о�Ϊ0 �������һ�У�
    R(1,4,i) = 0;       %ʹ��R�ĵ�����Ϊ0������Ҫ������ֲ���Դ����Ϊ������Ҫ�ѵ�����ֲ���Դ��Ϊ��Ҫȫ����Դ
end


% �����ǰ� forestset
for i=1:L
    forestset(:,:,i) = find_forestset(E(:,:,i), num_j);
end
end

