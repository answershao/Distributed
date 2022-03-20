function [skill_cate,GlobalSourceRequest,Lgs,original_skill_num] = generate_global_info(L, num_j,r, people, skill_count)
%UNTITLED 此处显示有关此函数的摘要
% 三.CA全局协调决策准备

%3.1 随机生成1、2  GlobalSourceRequest，skill_cate
% GlobalSourceRequest---全局资源需求量  L * num_j
% skill_cate--每个活动需要的技能种类   L * num_j（本文假设每个活动需要1种技能，多人完成）
rand('seed', 1);
GlobalSourceRequest =  round(rand(L, size(r,1))*3);%全局资源需求量[1,3]随机选取，rand(L, size(r,1))矩阵维度
GlobalSourceRequest(:,1) = 0; 
GlobalSourceRequest(:,num_j) = 0;%保证虚活动需求量均为0
%GlobalSourceRequest = ceil(3 * rand(L,
%size(r,1)));%全局资源需求量[1,3]随机选取，rand(L, size(r,1))矩阵维度
rand('seed', 2);
skill_cate = ceil( skill_count * rand(L, size(r,1)));%活动需要的技能种类[1,5]随机选取
for i= 1:L
    for j= 1:size(r, 1)
        if GlobalSourceRequest(i,j) %若GlobalSourceRequest有数值，即该活动需要全局资源,即需要技能
            continue
        else
            skill_cate(i,j) = 0;
        end
    end
end

%3.2 随机生成3、4   Lgs技能资源矩阵
a = [0.6 0.8 1.0];
rand('seed', 3);
Lgs = a(unidrnd(length(a), skill_count, people));
for  j = 1:size(Lgs,2)
    a = [skill_count-3,skill_count-2];   %非零的个数，要么2要么3
    b = randperm(length(a));   %把 1,2随机，只选择第一个，因为有了随机性
    if a(b(1)) ~= 0
        c = randperm(skill_count,a(b(1)));
        for jj = 1:length(c)
            Lgs(c(jj),j) = 0;
        end
    end
    original_skill_num =  sum(Lgs~=0,2)';
end

end
