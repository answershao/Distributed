function [forestset] = find_forestset(E, num_j)
%find_forestset 
% ���� ���󼯺�
% ��� ��ǰ����

forestset = double(zeros(length(E), 30));  %  �޸�5 Ϊ����
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

