function [original_local_start_time,original_local_end_time] = locals_slst(num_j,R, r,d,LST, LFT,forestset,ad)
global Simul_Num resource_cate T
LLST = zeros(1,num_j);
for lie = 1:num_j
    LLST(1,lie) = ceil(sum(LST(:,lie))/Simul_Num);  %取每一列的均值
end
%当LFT一样时，按照min（LFT）为活动分配资源
[A,index] = sort(LLST);  %LFT升序排序 index指对应的活动序号,
%通过LFT，确定活动执行的列表index，最大完工时间最小的先执行，所以升序

%2.为安排好的活动分配局部资源
for local_resource=1:resource_cate   %资源种类,只有前三种是局部资源,但是为了保证后续矩阵一致所以最后一种资源为0即可，无需管！
    remaining_resource(local_resource,:) = ones(1,T)*R(1,local_resource,1);
end % 初始化项目工期内的局部可更新资源可用量

original_local_end_time = LFT;
% original_local_end_time = new_local_end_times(1,:);%传递作用，time1=1就赋值？也不对，会出现

%开始分配资源
for y = 2: num_j
    activity = index(y);
    predecessors=forestset(activity,:,1);  %activity的紧前活动，predecessors_index1表示行数，因为gen只有一行，所以结果肯定都是1111
    predecessors(find(predecessors==0)) = [];
    %[~,predecessors_index2]=ismember(predecessors,index(1:y)); %ismember判断紧前活动中元素属于gen，就为1，不属于则为0
    [~,predecessors_index2]=ismember(predecessors,index); %ismember判断紧前活动中元素属于gen，就为1，不属于则为0
    time1=max(original_local_end_time(1,index(predecessors_index2)));  %紧前活动的最大完工时间?
    
    for time2 = time1+1 : T
        %for time2 = time11 : T                       %POP0(np,predecessors_index2)该位置上的活动数，找紧前活动完成时间最大的那个
        %判断在time2到time2+d(activity,:,q)-1的时间段内资源约束是否满足
        for time3 = time2 : (time2+d(activity,:,1)-1)
            % for time3 = time2 : (time2+d(activity,:,1))%从该活动的开始时间1到结束时间5的整个执行期间内，局部资源均满足
            if all(remaining_resource(:,time3)>=r(activity,:,1)')%每个time3表示CPM里的一个时段，即资源矩阵的列数
                A=1;   %若该时刻所有种类的局部资源剩余量均大于该活动对所有种类资源的需求量，则A = 1
                continue
            else
                A=0;
                break
            end
        end
        if A==1      %判断A是否为1，即当前时刻，可否给该活动分配局部资源
            original_local_start_time(1,activity)=time2-1;
            original_local_end_time(1,activity) = original_local_start_time(1,activity)+d(activity,:,1);
            % original_local_end_times(1,activity)=original_local_start_times(1,activity)+d(activity,:,1);%活动j的结束时间？还是活动activity
            %f(1+activity) = original_local_start_time(1,activity);
            for time=original_local_start_time(1,activity)+1:original_local_end_time(1,activity)
                remaining_resource(:,time)=remaining_resource(:,time)-r(activity,:,1)';  %更新局部资源的剩余可用量
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
