function [UF] = find_UF( GCPD,d, skill_count,skill_cate,GlobalSourceRequest,Lgs)
%   求多项目资源利用系数 UF
%   输入    CPM
%           GlobalSourceRequest
%           EveryTime_GS
%   输出      UF
% L = length(CPM);  % 项目数
%% 分母
%GCPD = max(GCPD);% 输入CPM最大值,全局关键路径工期
%全局资源需求量矩阵里所有元素的最大值
%取出每个时段全局需求量之和的最大值
% GlobalSourceTotal =randi([max(max(GlobalSourceRequest)),max(EveryTime_GS)],1,1) ;%全局资源可用量（总人数）,从a到b 中随机选取一个整数即可
%% 分子
only_skill_num = [];%只有一种技能的数量
all_skill_num = [];%%多项目对每种技能需求量之和
%判断skill_count的数，找到skill_cate中相同数字所在的位置index1
for i = 1:skill_count
    [a,index1] = find(skill_cate ==i);%a表示项目号，index1表示活动号
    for  i1 =1:length(a)   %找到GlobalSourceRequest中该位置index1的数字,与该活动工期相乘，作为多项目该技能在该工期内的需求量
        only_skill_num(i1) = (GlobalSourceRequest(a(i1),index1(i1))).*( d(index1(i1),:,a(i1)));
    end
    all_skill_num(i) = sum(only_skill_num);%多项目对每种技能在整个工期内的需求量之和
end

%% AUF
UF = [];
UF_s = [];
EverySkill(1,:) =(sum(Lgs~=0,2))';%每种技能可用量
for j = 1:length(EverySkill)
    UF(j)= double(all_skill_num(1,j))/(EverySkill(1,j)*GCPD);
    UF_s =[UF_s ;UF(j)];
end
UF = max(UF_s);
end