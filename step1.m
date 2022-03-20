function [temp1_local_start_times, temp1_local_end_times] = step1(time, forestset, temp_d, temp_local_start_times, temp_local_end_times)
% ��Ŀ�ʼʱ�����ʱ��
temp1_local_start_times = temp_local_start_times;
temp1_local_end_times = temp_local_end_times;
[L, num_j]= size(temp1_local_end_times);

for i=1:L
    temp = temp1_local_start_times(i,:);  % ȷ��ÿһ�����˳��
    [value,index] = sort(temp);%��������
    for act =1:length(value)
        if value(act) >= time
            pro = forestset(index(act), : ,i);              % ���pro��Ӧ�����ֵ���Ҹû�Ľ�ǰ�
            pro(find(pro==0)) = [];                         % ȥ��Ϊ0��Ԫ��,���½�ǰ�
            if ~isempty(pro)
                time1 =  max(temp1_local_end_times(i, pro));     %Ѱ�ҽ�ǰ�����ʱ��     
                temp1_local_start_times(i, index(act)) = max(time1, temp1_local_start_times(i, index(act)));  %����ǰ����ʱ���뵱ǰʱ����ȣ�ȷ������
                temp1_local_end_times(i, index(act)) = temp1_local_start_times(i, index(act)) + temp_d(index(act), 1, i);
            end
        end
    end
end

end