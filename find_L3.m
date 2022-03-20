function [L3] = find_L3(L2)
A = perms(L2); % 冲突活动全排列-----------?
temp_seq = 1:1:length(L2);
sum1 = cumsum(temp_seq);    % 求一个 length(L2) 累加和
theory_value = 2*sum1(end);
if size(A,1) > theory_value
    sequence = ceil(linspace(1, size(A, 1), theory_value));  % 等间隔选取
    L3 = A(sequence,:);
else
    L3 = A;
end
end
% length(L2);
% index(L2);%给L2中每个活动标记的位置，几个位置序号就几个活动
% randperm(length(L2));%这几个位置不重复排列一次
% 要取 10000次，并且每次都不重复 