function L2 = find_L2(L1, local_start_times, time, allocated_set)
% 寻找L2
st = zeros(1,length(L1));
for x = 1:length(L1)%遍历L1中每个数组
    i = L1{1,x}(1,1);%取出L1中第x个数组的行作为项目数，
    j = L1{1,x}(1,2);%取出L1中第x个数组的列作为活动数，
    % st(x)= local_start_times(i,j);%找到这些活动的开始时间
    if isempty(allocated_set)
        st(x)= local_start_times(i,j);%找到这些活动的开始时间
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
                st(x)= local_start_times(i,j);%找到这些活动的开始时间
            end
        end
        
    end
    
end

if ismember(time, st)
    [m,n]=find(st==time); %找到time 值对应的st中的位置
    L2 = cell(1,length(n));
    for y = 1:length(n)
        L2{1,y} = L1{1,n(1,y)};
    end
else
    L2  = [];
end

end



