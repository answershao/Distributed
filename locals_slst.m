function [original_local_start_time,original_local_end_time] = locals_slst(num_j,R, r,d,LST, LFT,forestset,ad)
global Simul_Num resource_cate T
LLST = zeros(1,num_j);
for lie = 1:num_j
    LLST(1,lie) = ceil(sum(LST(:,lie))/Simul_Num);  %ȡÿһ�еľ�ֵ
end
%��LFTһ��ʱ������min��LFT��Ϊ�������Դ
[A,index] = sort(LLST);  %LFT�������� indexָ��Ӧ�Ļ���,
%ͨ��LFT��ȷ���ִ�е��б�index������깤ʱ����С����ִ�У���������

%2.Ϊ���źõĻ����ֲ���Դ
for local_resource=1:resource_cate   %��Դ����,ֻ��ǰ�����Ǿֲ���Դ,����Ϊ�˱�֤��������һ���������һ����ԴΪ0���ɣ�����ܣ�
    remaining_resource(local_resource,:) = ones(1,T)*R(1,local_resource,1);
end % ��ʼ����Ŀ�����ڵľֲ��ɸ�����Դ������

original_local_end_time = LFT;
% original_local_end_time = new_local_end_times(1,:);%�������ã�time1=1�͸�ֵ��Ҳ���ԣ������

%��ʼ������Դ
for y = 2: num_j
    activity = index(y);
    predecessors=forestset(activity,:,1);  %activity�Ľ�ǰ���predecessors_index1��ʾ��������Ϊgenֻ��һ�У����Խ���϶�����1111
    predecessors(find(predecessors==0)) = [];
    %[~,predecessors_index2]=ismember(predecessors,index(1:y)); %ismember�жϽ�ǰ���Ԫ������gen����Ϊ1����������Ϊ0
    [~,predecessors_index2]=ismember(predecessors,index); %ismember�жϽ�ǰ���Ԫ������gen����Ϊ1����������Ϊ0
    time1=max(original_local_end_time(1,index(predecessors_index2)));  %��ǰ�������깤ʱ��?
    
    for time2 = time1+1 : T
        %for time2 = time11 : T                       %POP0(np,predecessors_index2)��λ���ϵĻ�����ҽ�ǰ����ʱ�������Ǹ�
        %�ж���time2��time2+d(activity,:,q)-1��ʱ�������ԴԼ���Ƿ�����
        for time3 = time2 : (time2+d(activity,:,1)-1)
            % for time3 = time2 : (time2+d(activity,:,1))%�Ӹû�Ŀ�ʼʱ��1������ʱ��5������ִ���ڼ��ڣ��ֲ���Դ������
            if all(remaining_resource(:,time3)>=r(activity,:,1)')%ÿ��time3��ʾCPM���һ��ʱ�Σ�����Դ���������
                A=1;   %����ʱ����������ľֲ���Դʣ���������ڸû������������Դ������������A = 1
                continue
            else
                A=0;
                break
            end
        end
        if A==1      %�ж�A�Ƿ�Ϊ1������ǰʱ�̣��ɷ���û����ֲ���Դ
            original_local_start_time(1,activity)=time2-1;
            original_local_end_time(1,activity) = original_local_start_time(1,activity)+d(activity,:,1);
            % original_local_end_times(1,activity)=original_local_start_times(1,activity)+d(activity,:,1);%�j�Ľ���ʱ�䣿���ǻactivity
            %f(1+activity) = original_local_start_time(1,activity);
            for time=original_local_start_time(1,activity)+1:original_local_end_time(1,activity)
                remaining_resource(:,time)=remaining_resource(:,time)-r(activity,:,1)';  %���¾ֲ���Դ��ʣ�������
            end
            break
        else
            continue
        end
    end
    %new_local_end_times = original_local_end_time;
end

original_local_start_time = original_local_start_time +ad;
original_local_end_time = original_local_end_time + ad;
end
