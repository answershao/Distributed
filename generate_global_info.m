function [skill_cate,GlobalSourceRequest,Lgs,original_skill_num] = generate_global_info(L, num_j,r, people, skill_count)
%UNTITLED �˴���ʾ�йش˺�����ժҪ
% ��.CAȫ��Э������׼��

%3.1 �������1��2  GlobalSourceRequest��skill_cate
% GlobalSourceRequest---ȫ����Դ������  L * num_j
% skill_cate--ÿ�����Ҫ�ļ�������   L * num_j�����ļ���ÿ�����Ҫ1�ּ��ܣ�������ɣ�
rand('seed', 1);
GlobalSourceRequest =  round(rand(L, size(r,1))*3);%ȫ����Դ������[1,3]���ѡȡ��rand(L, size(r,1))����ά��
GlobalSourceRequest(:,1) = 0; 
GlobalSourceRequest(:,num_j) = 0;%��֤����������Ϊ0
%GlobalSourceRequest = ceil(3 * rand(L,
%size(r,1)));%ȫ����Դ������[1,3]���ѡȡ��rand(L, size(r,1))����ά��
rand('seed', 2);
skill_cate = ceil( skill_count * rand(L, size(r,1)));%���Ҫ�ļ�������[1,5]���ѡȡ
for i= 1:L
    for j= 1:size(r, 1)
        if GlobalSourceRequest(i,j) %��GlobalSourceRequest����ֵ�����û��Ҫȫ����Դ,����Ҫ����
            continue
        else
            skill_cate(i,j) = 0;
        end
    end
end

%3.2 �������3��4   Lgs������Դ����
a = [0.6 0.8 1.0];
rand('seed', 3);
Lgs = a(unidrnd(length(a), skill_count, people));
for  j = 1:size(Lgs,2)
    a = [skill_count-3,skill_count-2];   %����ĸ�����Ҫô2Ҫô3
    b = randperm(length(a));   %�� 1,2�����ֻѡ���һ������Ϊ���������
    if a(b(1)) ~= 0
        c = randperm(skill_count,a(b(1)));
        for jj = 1:length(c)
            Lgs(c(jj),j) = 0;
        end
    end
    original_skill_num =  sum(Lgs~=0,2)';
end

end
