function [UF] = find_UF( GCPD,d, skill_count,skill_cate,GlobalSourceRequest,Lgs)
%   �����Ŀ��Դ����ϵ�� UF
%   ����    CPM
%           GlobalSourceRequest
%           EveryTime_GS
%   ���      UF
% L = length(CPM);  % ��Ŀ��
%% ��ĸ
%GCPD = max(GCPD);% ����CPM���ֵ,ȫ�ֹؼ�·������
%ȫ����Դ����������������Ԫ�ص����ֵ
%ȡ��ÿ��ʱ��ȫ��������֮�͵����ֵ
% GlobalSourceTotal =randi([max(max(GlobalSourceRequest)),max(EveryTime_GS)],1,1) ;%ȫ����Դ����������������,��a��b �����ѡȡһ����������
%% ����
only_skill_num = [];%ֻ��һ�ּ��ܵ�����
all_skill_num = [];%%����Ŀ��ÿ�ּ���������֮��
%�ж�skill_count�������ҵ�skill_cate����ͬ�������ڵ�λ��index1
for i = 1:skill_count
    [a,index1] = find(skill_cate ==i);%a��ʾ��Ŀ�ţ�index1��ʾ���
    for  i1 =1:length(a)   %�ҵ�GlobalSourceRequest�и�λ��index1������,��û������ˣ���Ϊ����Ŀ�ü����ڸù����ڵ�������
        only_skill_num(i1) = (GlobalSourceRequest(a(i1),index1(i1))).*( d(index1(i1),:,a(i1)));
    end
    all_skill_num(i) = sum(only_skill_num);%����Ŀ��ÿ�ּ��������������ڵ�������֮��
end

%% AUF
UF = [];
UF_s = [];
EverySkill(1,:) =(sum(Lgs~=0,2))';%ÿ�ּ��ܿ�����
for j = 1:length(EverySkill)
    UF(j)= double(all_skill_num(1,j))/(EverySkill(1,j)*GCPD);
    UF_s =[UF_s ;UF(j)];
end
UF = max(UF_s);
end