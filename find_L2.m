function L2 = find_L2(L1, local_start_times, time, allocated_set)
% Ѱ��L2
st = zeros(1,length(L1));
for x = 1:length(L1)%����L1��ÿ������
    i = L1{1,x}(1,1);%ȡ��L1�е�x�����������Ϊ��Ŀ����
    j = L1{1,x}(1,2);%ȡ��L1�е�x�����������Ϊ�����
    % st(x)= local_start_times(i,j);%�ҵ���Щ��Ŀ�ʼʱ��
    if isempty(allocated_set)
        st(x)= local_start_times(i,j);%�ҵ���Щ��Ŀ�ʼʱ��
    else
        count = 0;
        m = 1;
        while m <= length(allocated_set)
            xx = ([i,j] == allocated_set{1,m});
            if xx(1) ==1 && xx(2) == 1
                break
            else
                count = count+1;
                m = m+1;
            end
            if count == length(allocated_set)
                st(x)= local_start_times(i,j);%�ҵ���Щ��Ŀ�ʼʱ��
            end
        end
        
    end
    
end

if ismember(time, st)
    [m,n]=find(st==time); %�ҵ�time ֵ��Ӧ��st�е�λ��
    L2 = cell(1,length(n));
    for y = 1:length(n)
        L2{1,y} = L1{1,n(1,y)};
    end
else
    L2  = [];
end

end



