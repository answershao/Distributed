function [local_start_time, local_end_time] = find_PR1(num_j,R, r, d, E, cpm_end_time,resource_cate)
%1.�ƶ����ȹ���-�ִ��˳��  (��LFT�ƶ�-�������ڣ�
%LST- ����ʼʱ�䣬CPM��������ȵĿ�ʼʱ��Ϊ����ʼʱ��
%LFT-�������ʱ�䣬min{���н�����LST}
%LST(end)=EST(end������Ϊ�յ�һ���ڹؼ�·���ϣ��ؼ�·���ϵĵ����翪ʼʱ���������ʼʱ�䣬���ǹؼ�·���ϵĵ㲻һ����
%Ȼ���������ƣ�������ʼʱ��LST��

f=zeros(1,num_j+1);  %��ʼ��gen
LST = zeros(1,num_j); %Ԥ���ɸ����������ʼʱ��
LFT = zeros(1,num_j); %Ԥ���ɸ�������������ʱ��
act_number = []; %�������

local_start_time = zeros(1,num_j);
local_end_time = zeros(1,num_j);
T = 500;

%����CPM�õ��Ļ�б���ʼ�������
for  act = 1: num_j
    act_number(act)= act;
end

AA= [-cpm_end_time(1,:);-act_number];
[BB,indexB] = sortrows(AA');   
BB(:,1:2) = - BB(:,1:2);

back_gen  = BB(:,2)';                %ʱ������Ļ�б�      �� 32-29-27-30-31-28-����������
%new_local_end_times(1,:) = BB(:,1)'; %������б��Ӧ�Ľ���ʱ���� 56-56-53-51-46-45-����������

LST(32) = max(cpm_end_time(1,:));  %���������Ļ����

for s=2:num_j %����back_gen�еĻ˳���б�ȷ��LST
    activity_choose=back_gen(s);  %���ŵĻΪactivity_choose=29
     sucdecessors=E(activity_choose,:,1);%%%������ѡ��Ľ�������
    sucdecessors(find(sucdecessors==0)) = [];
    if length(sucdecessors) ==1
    LST(activity_choose) = LST(sucdecessors) -d(activity_choose);
    else
        LST(activity_choose) = min{LST(sucdecessors)}-d(activity_choose);
    end
end 

LFT(activity_choose) = min(LST(1,back_gen(sucdecessors_index2)));



for s=2:num_j %����back_gen�еĻ˳���б�ȷ��LST
    activity_choose=back_gen(s);  %���ŵĻΪactivity_choose
    %        %% �����������
    sucdecessors=E(activity_choose,:,1);%%%�����������
    sucdecessors(find(sucdecessors==0)) = [];
    [~,sucdecessors_index2]=ismember(sucdecessors,back_gen(1:num_j)); %�жϻ�Ľ����Ƿ�����back_gen��
    %
    LFT(s) = min(new_local_start_times(1,back_gen(sucdecessors_index2)));% ���������翪ʼʱ��,�����Ѿ�����LFT��ʼ������
end