function [forestset] = find_forestset(E, num_j)
%find_forestset 
% 输入 紧后集合
% 输出 紧前集合

forestset = double(zeros(length(E), 30));  %  修改5 为列数
for i = 1:num_j
    count = 1;
    for row = 1:length(E)
        for col = 1:length(E(1,:))
            if E(row, col) == i
                forestset(i, count) = row;
                count = count + 1; 
            end    
        end
    end   
end
end

