function[iter_local_start_times,iter_local_end_times] = find_act_not(L5,time,r,temp_R,temp_d,forestset, iter_local_start_times, iter_local_end_times)
%% 1.L5�ռ�����L5�Ļ+1
L5(cellfun(@isempty,L5)) = []; %���˵��յ�Ԫ������ ��L5ֻ��1�У���Щ���ǵ�ǰʱ�̲��ɷ���Ļ��
temp_local_start_times =  iter_local_start_times;
temp_local_end_times =   iter_local_end_times;
for lie = 1: size(L5,2)
    i = L5{1,lie}(1);%��Ŀ��
    j = L5{1,lie}(2);%���
    temp_local_start_times(i,j) = temp_local_start_times(i,j)+1;%���ɷ���Ļʱ��+1
    temp_local_end_times(i,j) = temp_local_end_times(i,j)+1;
end
%% 2. ����Լ����ϵ+1
[temp1_local_start_times, temp1_local_end_times] = step1(time, forestset, temp_d, temp_local_start_times, temp_local_end_times);%ȷ��δ���Ż��ʼʱ��
%% 3.  ���¾ֲ�����+1
[temp2_local_start_times, temp2_local_end_times] = process1(time, r, temp_R, temp_d, temp1_local_start_times, temp1_local_end_times);
iter_local_start_times  = temp2_local_start_times;   %���¿�ʼʱ��
iter_local_end_times    = temp2_local_end_times;     %���½���ʱ��