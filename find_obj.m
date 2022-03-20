function[S_obj,results,Real_Available_skill_cates,temp_Lgs_s,temp_d2,later_start_times,later_end_times,temp_RN_s,later_local_duration,finally_total_duration] = find_obj(allocate_source_rules, S2,time,ad,delay,CPM,r,temp_R,forestset,skill_cate, GlobalSourceRequest, iter_Lgs, iter_skill_num, iter_d,iter_d2, iter_local_start_times, iter_local_end_times,iter_RN)
temp_RN_s = [];results = {};temp_Lgs_s=[];Real_Available_skill_cates=[];later_end_times = [];later_start_times = []; later_local_duration = [];S_obj = zeros(size(S2,1), 1); temp_RN_s = [];
L6 = S2;
L6(cellfun(@isempty,L6)) = []; %过滤掉空的元胞数组 ，按照仿真工期为计划工期求得实际工期

if allocate_source_rules == 'shsl'
    [result, temp_Lgs, temp_skill_num, temp_d2, temp_local_start_times, temp_local_end_times,temp_RN] = allocate_source_SHSL(time, L6, skill_cate, GlobalSourceRequest, iter_Lgs, iter_skill_num, iter_d,iter_d2, iter_local_start_times, iter_local_end_times,iter_RN);
elseif allocate_source_rules == 'mas1'
    [result, temp_Lgs, temp_skill_num, temp_d2, temp_local_start_times, temp_local_end_times,temp_RN] =  allocate_source_MAS(time, L6,skill_cate,GlobalSourceRequest,iter_Lgs,iter_skill_num,iter_d,iter_d2,iter_local_start_times,iter_local_end_times,iter_RN);
elseif allocate_source_rules == 'lcbr'
    [result, temp_Lgs, temp_skill_num, temp_d2, temp_local_start_times, temp_local_end_times,temp_RN] = allocate_source_LCBR(time, L6,skill_cate,GlobalSourceRequest,iter_Lgs,iter_skill_num,iter_d,iter_d2,iter_local_start_times,iter_local_end_times,iter_RN);
end
%temp_d = d;  %未安排的活动的开始时间为期望工期
%  update_clpex_option已经安排了的活动的开始时间+实际工期，则确定好了结束时间
%一个temp_d由statistic_d过渡过来，so安排了的活动，实际工期自然改变，未安排的活动仍和仿真工期保持一致。
[temp1_local_start_times, temp1_local_end_times] = step1(time, forestset, temp_d2, temp_local_start_times, temp_local_end_times);%确定未安排活动开始时间

%PA更新局部调度时，需要给固定好的开始时间范围内的活动，安排资源， if change
%一个列表，让开始了的活动的工期更改为实际工期temp_d(取部分），而未开始的活动工期仍保持与之前期望工期不变的d(取部分）
%然后再传递给temp_d2

%PA更新局部调度
[temp2_local_start_times, temp2_local_end_times] = process1(time, r, temp_R, temp_d2, temp1_local_start_times, temp1_local_end_times);
temp_RN_s = [temp_RN_s; temp_RN];
results {1} = result;
temp_Lgs_s = [temp_Lgs_s;  temp_Lgs];
Real_Available_skill_cates = [Real_Available_skill_cates; temp_skill_num];  % 记录所有顺序对应的iter_skill_num
% Ds(:,:,:,1) = temp_d2;%所有顺序的实际工期保存
later_start_times = [later_start_times; temp2_local_start_times];%(u*2) * 12所有顺序的开始时间
later_end_times = [later_end_times; temp2_local_end_times]; %(u*2) * 12所有顺序的结束时间
finally_start_times = temp2_local_start_times-1;
finally_end_times = temp2_local_end_times-1;
finally_total_duration = max(finally_end_times, [], 2);  % 所有项目工期；指派完资源之后的
later_local_duration = [later_local_duration; finally_total_duration'];
S_obj(1) = delay*(finally_total_duration - ad'-CPM');%所有顺序的总延期成本
% 结束全排列