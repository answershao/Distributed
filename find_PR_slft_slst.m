function [lst, lft] = find_PR_slft(num_j, statistic_CD, E, cpm_end_time)
%1.制定优先规则-活动执行顺序  (以LFT制定-期望工期）
%LST- 最晚开始时间，CPM的逆向调度的开始时间为最晚开始时间
%LFT-最晚结束时间，min{所有紧后活动中LST}
%LST(end)=EST(end）（因为终点一定在关键路径上，关键路径上的点最早开始时间等于最晚开始时间，不是关键路径上的点不一定）
%然后依次逆推，求最晚开始时间LST。

f = zeros(1, num_j + 1); %间接储存original_local_start_time
lst = zeros(1, num_j); %预生成各个活动的最晚开始时间
lft = zeros(1, num_j); %预生成各个活动的最晚结束时间
act_number = []; %储存活动序号

%根据CPM得到的活动列表，开始逆向调度
%  [new_local_end_times(1,:),index] = sort(cpm_end_time(1,:),'descend');
for act = 1:num_j
    act_number(act) = act;
end

AA = [-cpm_end_time(1, :); -act_number];
[BB, indexB] = sortrows(AA');
BB(:, 1:2) =- BB(:, 1:2);

back_gen = BB(:, 2)';
% new_local_end_times(1,:) = BB(:,1)';
% %把时间顺序上对应的活动标注出来-新的活动列表，位置号即活动号

lst(num_j) = max(cpm_end_time(1, :)); %最后的虚拟活动的活动工期,改
lft(num_j) = max(cpm_end_time(1, :)); %最后的虚拟活动的活动工期

for s = 2:num_j %按照back_gen中的活动顺序列表确定lst
    activity_choose = back_gen(s); %安排的活动为activity_choose=29
    sucdecessors = E(activity_choose, :, 1); % % %补充所选活动的紧后活动集合
    sucdecessors(find(sucdecessors == 0)) = [];
    
    if length(sucdecessors) == 1
        lst(activity_choose) = lst(sucdecessors) -statistic_CD(activity_choose);
    else
        lst(activity_choose) = min(lst(sucdecessors) - statistic_CD (activity_choose));
    end
    
    lft(activity_choose) = min(lst(sucdecessors));
end

%储存多次仿真的LST,LFT,取均值，取最小随机的SLFT确定本次的活动顺序
end
