function [allocated_set,iter_Lgs, iter_skill_num] =Release(time,chosen_results,allocated_set,Lgs,iter_Lgs, iter_skill_num)
for i=1:length(chosen_results)   %当time为2时，开始从1,2遍历
    temp0 = chosen_results{i};
    for j=1:length(temp0)
        temp = temp0(j);
        if  ~isempty(temp{1})%里边只有一个
            temp1 = temp{1};
            % temp11 = temp1(1);  %skill_number
            temp12 = temp1(2);  %Resource_number
            temp13 = temp1(3);  % 活动序号
            temp14 = temp1(4);  % 释放时间
            if isempty(allocated_set)   %如果空集直接加入
                allocated_set = [allocated_set, temp13{1}];%找到这些活动的开始时间
            else
                count = 0;   %如果非空，判断是否已经存在，不存在就加入
                m = 1;
                len = length(allocated_set);
                while m <= len
                    xx = (temp13{1} == allocated_set{1,m});
                    if xx(1) ==1 && xx(2) == 1
                        break
                    else
                        count = count+1;
                        m = m+1;
                    end
                    if count == length(allocated_set)
                        allocated_set = [allocated_set, temp13{1}];
                    end
                end
            end
            if temp14{1}== time+1  % 如果释放时间等于当前时间
                iter_Lgs(:, temp12{1}) = Lgs(1:end,temp12{1});
                iter_skill_num(1,:) = (sum(iter_Lgs~=0,2))';
            end
        end
    end
end
end