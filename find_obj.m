function[S_obj,results,Real_Available_skill_cates,temp_Lgs_s,temp_d2,later_start_times,later_end_times,temp_RN_s,later_local_duration,finally_total_duration] = find_obj(allocate_source_rules, S2,time,ad,delay,CPM,r,temp_R,forestset,skill_cate, GlobalSourceRequest, iter_Lgs, iter_skill_num, iter_d,iter_d2, iter_local_start_times, iter_local_end_times,iter_RN)
temp_RN_s = [];results = {};temp_Lgs_s=[];Real_Available_skill_cates=[];later_end_times = [];later_start_times = []; later_local_duration = [];S_obj = zeros(size(S2,1), 1); temp_RN_s = [];
L6 = S2;
L6(cellfun(@isempty,L6)) = []; %���˵��յ�Ԫ������ �����շ��湤��Ϊ�ƻ��������ʵ�ʹ���

if allocate_source_rules == 'shsl'
    [result, temp_Lgs, temp_skill_num, temp_d2, temp_local_start_times, temp_local_end_times,temp_RN] = allocate_source_SHSL(time, L6, skill_cate, GlobalSourceRequest, iter_Lgs, iter_skill_num, iter_d,iter_d2, iter_local_start_times, iter_local_end_times,iter_RN);
elseif allocate_source_rules == 'mas1'
    [result, temp_Lgs, temp_skill_num, temp_d2, temp_local_start_times, temp_local_end_times,temp_RN] =  allocate_source_MAS(time, L6,skill_cate,GlobalSourceRequest,iter_Lgs,iter_skill_num,iter_d,iter_d2,iter_local_start_times,iter_local_end_times,iter_RN);
elseif allocate_source_rules == 'lcbr'
    [result, temp_Lgs, temp_skill_num, temp_d2, temp_local_start_times, temp_local_end_times,temp_RN] = allocate_source_LCBR(time, L6,skill_cate,GlobalSourceRequest,iter_Lgs,iter_skill_num,iter_d,iter_d2,iter_local_start_times,iter_local_end_times,iter_RN);
end
%temp_d = d;  %δ���ŵĻ�Ŀ�ʼʱ��Ϊ��������
%  update_clpex_option�Ѿ������˵Ļ�Ŀ�ʼʱ��+ʵ�ʹ��ڣ���ȷ�����˽���ʱ��
%һ��temp_d��statistic_d���ɹ�����so�����˵Ļ��ʵ�ʹ�����Ȼ�ı䣬δ���ŵĻ�Ժͷ��湤�ڱ���һ�¡�
[temp1_local_start_times, temp1_local_end_times] = step1(time, forestset, temp_d2, temp_local_start_times, temp_local_end_times);%ȷ��δ���Ż��ʼʱ��

%PA���¾ֲ�����ʱ����Ҫ���̶��õĿ�ʼʱ�䷶Χ�ڵĻ��������Դ�� if change
%һ���б��ÿ�ʼ�˵Ļ�Ĺ��ڸ���Ϊʵ�ʹ���temp_d(ȡ���֣�����δ��ʼ�Ļ�����Ա�����֮ǰ�������ڲ����d(ȡ���֣�
%Ȼ���ٴ��ݸ�temp_d2

%PA���¾ֲ�����
[temp2_local_start_times, temp2_local_end_times] = process1(time, r, temp_R, temp_d2, temp1_local_start_times, temp1_local_end_times);
temp_RN_s = [temp_RN_s; temp_RN];
results {1} = result;
temp_Lgs_s = [temp_Lgs_s;  temp_Lgs];
Real_Available_skill_cates = [Real_Available_skill_cates; temp_skill_num];  % ��¼����˳���Ӧ��iter_skill_num
% Ds(:,:,:,1) = temp_d2;%����˳���ʵ�ʹ��ڱ���
later_start_times = [later_start_times; temp2_local_start_times];%(u*2) * 12����˳��Ŀ�ʼʱ��
later_end_times = [later_end_times; temp2_local_end_times]; %(u*2) * 12����˳��Ľ���ʱ��
finally_start_times = temp2_local_start_times-1;
finally_end_times = temp2_local_end_times-1;
finally_total_duration = max(finally_end_times, [], 2);  % ������Ŀ���ڣ�ָ������Դ֮���
later_local_duration = [later_local_duration; finally_total_duration'];
S_obj(1) = delay*(finally_total_duration - ad'-CPM');%����˳��������ڳɱ�
% ����ȫ����