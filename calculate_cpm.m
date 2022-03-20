function [CPM, cpm_start_time, cpm_end_time, original_local_start_times, original_local_end_times, UF, original_total_duration] = calculate_cpm(activity_rules, statistic_CD, d, E, L, R, r,num_j, ad, skill_count,skill_cate,GlobalSourceRequest,Lgs,forestset)
%CALCULATE_CPM 此处显示有关此函数的摘要

global resource_cate
% 2.3 计算关键路径工期CPM，后续求项目延期使用
% CPM                       关键路径工期              1 * L
% cpm_start_time            活动开始时间              L * num_j
% cpm_end_time              活动结束时间              L * num_j
if activity_rules == 'lst1'
    [CPM, cpm_start_time, cpm_end_time, original_local_start_times, original_local_end_times, UF, original_total_duration] =   cpm_lst(statistic_CD, d, E, L, R, r,num_j, ad, skill_count,skill_cate,GlobalSourceRequest,Lgs,resource_cate,forestset);
elseif  activity_rules == 'slft'
    [CPM, cpm_start_time, cpm_end_time, original_local_start_times, original_local_end_times, UF, original_total_duration] =  cpm_slft(statistic_CD,d, E, L, R, r,num_j, ad, skill_count,skill_cate,GlobalSourceRequest,Lgs,resource_cate,forestset);
elseif  activity_rules == 'slst'
    [CPM, cpm_start_time, cpm_end_time, original_local_start_times, original_local_end_times, UF, original_total_duration] =  cpm_slst(statistic_CD,d, E, L, R, r,num_j, ad, skill_count,skill_cate,GlobalSourceRequest,Lgs,resource_cate,forestset);
end
end

