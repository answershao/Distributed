function [temp1_local_start_times, temp1_local_end_times] = step1(time, forestset, temp_d, temp_local_start_times, temp_local_end_times)
% 活动的开始时间结束时间
temp1_local_start_times = temp_local_start_times;
temp1_local_end_times = temp_local_end_times;
[L, num_j]= size(temp1_local_end_times);

for i=1:L
    temp = temp1_local_start_times(i,:);  % 确定每一个活动的顺序
    [value,index] = sort(temp);%升序排序
    for act =1:length(value)
        if value(act) >= time
            pro = forestset(index(act), : ,i);              % 求解pro对应的最大值，找该活动的紧前活动
            pro(find(pro==0)) = [];                         % 去除为0的元素,留下紧前活动
            if ~isempty(pro)
                time1 =  max(temp1_local_end_times(i, pro));     %寻找紧前活动最大的时间     
                temp1_local_start_times(i, index(act)) = max(time1, temp1_local_start_times(i, index(act)));  %将紧前活动最大时间与当前时刻相比，确定最大的
                temp1_local_end_times(i, index(act)) = temp1_local_start_times(i, index(act)) + temp_d(index(act), 1, i);
            end
        end
    end
end

end