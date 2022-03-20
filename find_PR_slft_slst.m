function [lst, lft] = find_PR_slft(num_j, statistic_CD, E, cpm_end_time)
%1.�ƶ����ȹ���-�ִ��˳��  (��LFT�ƶ�-�������ڣ�
%LST- ����ʼʱ�䣬CPM��������ȵĿ�ʼʱ��Ϊ����ʼʱ��
%LFT-�������ʱ�䣬min{���н�����LST}
%LST(end)=EST(end������Ϊ�յ�һ���ڹؼ�·���ϣ��ؼ�·���ϵĵ����翪ʼʱ���������ʼʱ�䣬���ǹؼ�·���ϵĵ㲻һ����
%Ȼ���������ƣ�������ʼʱ��LST��

f = zeros(1, num_j + 1); %��Ӵ���original_local_start_time
lst = zeros(1, num_j); %Ԥ���ɸ����������ʼʱ��
lft = zeros(1, num_j); %Ԥ���ɸ�������������ʱ��
act_number = []; %�������

%����CPM�õ��Ļ�б���ʼ�������
%  [new_local_end_times(1,:),index] = sort(cpm_end_time(1,:),'descend');
for act = 1:num_j
    act_number(act) = act;
end

AA = [-cpm_end_time(1, :); -act_number];
[BB, indexB] = sortrows(AA');
BB(:, 1:2) =- BB(:, 1:2);

back_gen = BB(:, 2)';
% new_local_end_times(1,:) = BB(:,1)';
% %��ʱ��˳���϶�Ӧ�Ļ��ע����-�µĻ�б�λ�úż����

lst(num_j) = max(cpm_end_time(1, :)); %���������Ļ����,��
lft(num_j) = max(cpm_end_time(1, :)); %���������Ļ����

for s = 2:num_j %����back_gen�еĻ˳���б�ȷ��lst
    activity_choose = back_gen(s); %���ŵĻΪactivity_choose=29
    sucdecessors = E(activity_choose, :, 1); % % %������ѡ��Ľ�������
    sucdecessors(find(sucdecessors == 0)) = [];
    
    if length(sucdecessors) == 1
        lst(activity_choose) = lst(sucdecessors) -statistic_CD(activity_choose);
    else
        lst(activity_choose) = min(lst(sucdecessors) - statistic_CD (activity_choose));
    end
    
    lft(activity_choose) = min(lst(sucdecessors));
end

%�����η����LST,LFT,ȡ��ֵ��ȡ��С�����SLFTȷ�����εĻ˳��
end
