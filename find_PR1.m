function [local_start_time, local_end_time] = find_PR1(num_j,R, r, d, E, cpm_end_time,resource_cate)
%1.制定优先规则-活动执行顺序  (以LFT制定-期望工期）
%LST- 最晚开始时间，CPM的逆向调度的开始时间为最晚开始时间
%LFT-最晚结束时间，min{所有紧后活动中LST}
%LST(end)=EST(end）（因为终点一定在关键路径上，关键路径上的点最早开始时间等于最晚开始时间，不是关键路径上的点不一定）
%然后依次逆推，求最晚开始时间LST。

f=zeros(1,num_j+1);  %初始化gen
LST = zeros(1,num_j); %预生成各个活动的最晚开始时间
LFT = zeros(1,num_j); %预生成各个活动的最晚结束时间
act_number = []; %储存活动序号

local_start_time = zeros(1,num_j);
local_end_time = zeros(1,num_j);
T = 500;

%根据CPM得到的活动列表，开始逆向调度
for  act = 1: num_j
    act_number(act)= act;
end

AA= [-cpm_end_time(1,:);-act_number];
[BB,indexB] = sortrows(AA');   
BB(:,1:2) = - BB(:,1:2);

back_gen  = BB(:,2)';                %时间逆序的活动列表      如 32-29-27-30-31-28-。。。。。
%new_local_end_times(1,:) = BB(:,1)'; %逆序的列表对应的结束时间如 56-56-53-51-46-45-。。。。。

LST(32) = max(cpm_end_time(1,:));  %最后的虚拟活动的活动工期

for s=2:num_j %按照back_gen中的活动顺序列表确定LST
    activity_choose=back_gen(s);  %安排的活动为activity_choose=29
     sucdecessors=E(activity_choose,:,1);%%%补充所选活动的紧后活动集合
    sucdecessors(find(sucdecessors==0)) = [];
    if length(sucdecessors) ==1
    LST(activity_choose) = LST(sucdecessors) -d(activity_choose);
    else
        LST(activity_choose) = min{LST(sucdecessors)}-d(activity_choose);
    end
end 

LFT(activity_choose) = min(LST(1,back_gen(sucdecessors_index2)));



for s=2:num_j %按照back_gen中的活动顺序列表确定LST
    activity_choose=back_gen(s);  %安排的活动为activity_choose
    %        %% 补充紧后活动集合
    sucdecessors=E(activity_choose,:,1);%%%补充紧后活动集合
    sucdecessors(find(sucdecessors==0)) = [];
    [~,sucdecessors_index2]=ismember(sucdecessors,back_gen(1:num_j)); %判断活动的紧后活动是否属于back_gen里
    %
    LFT(s) = min(new_local_start_times(1,back_gen(sucdecessors_index2)));% 紧后活动的最早开始时间,这是已经按照LFT开始求啦？
end