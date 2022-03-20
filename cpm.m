function [CPM, cpm_start_time, cpm_end_time] = cpm(d, E)
%mΪ���
%LΪ��Ŀ��
%RΪ�ֲ���Դ��������
%������succeedset
%��ǰ���foreset
m = length(d);
L = 1;  % ֻ����һ����Ŀ�Ĺؼ�·��
foreset = find_forestset(E,m);
cpm_start_time=zeros(L,m);
cpm_end_time=zeros(L,m);%��ʼ����ʼʱ�������ʱ��
%��CPM����
for i=2:m
    predecessors=foreset(i,:);  % activity�Ľ�ǰ� [1 0 0 0 0]
    max_endtime = 0;
    for x = 1:length(predecessors)  % Ѱ�ҽ�ǰ�������endtime
        if (predecessors(x) ~= 0 && cpm_end_time(predecessors(x))>max_endtime)
            max_endtime = cpm_end_time(predecessors(x));
        end
    end
    cpm_start_time(i)=max_endtime;  %��ǰ�������깤ʱ��
    cpm_end_time(i)=cpm_start_time(i)+d(i);
end  
CPM = max(cpm_end_time);
end
