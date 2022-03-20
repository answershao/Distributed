function [L1] = find_L1(GlobalSourceRequest)
%UNTITLED7 此处显示有关此函数的摘要
%   此处显示详细说明
count =1;
L1 = cell(1,1);
for i=1:size(GlobalSourceRequest,1)
    for j=1:size(GlobalSourceRequest,2)
        if GlobalSourceRequest(i,j) ~=0
            L1{1,count} = [i,j];
            count = count + 1;
        end
    end
end
end

