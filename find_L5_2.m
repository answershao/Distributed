function [satisfy_pro,iter_not] = find_L5_2(LP,GlobalSourceRequest,skill_cate,skill_count,iter_skill_num)
%global max_iteration
% yb = [3,4]
% order = [1: length(yb)];
% iterations = factorial(length(yb));%项目的阶乘
% order = [1: length(yb)];
%L3 = perms(order);%根据阶乘拍好顺序了
%if length(yb) >=1
B = sum(iter_skill_num);%当前时刻全局资源总人数，iter_skill_num对应各个技能的可用量
all_perm = []; %储存可以全排列的项目，满足各技能及全局的可用量-全排列
pre_perm = [];%储存按照优先规则排列的项目数，
satisfy_pro = cell(size(LP,1),length(LP));  %储存不移除的项目
not_satisfy_pro= cell(size(LP,1),length(LP));%储存所移除的项目，该时刻结束后需要再加上
count_1=0;
count_2=0;
iter_not = [];
for hang = 1:size(LP,1) %行
    count = 0;
    % A = [];%储存每个项目所需资源之和
    AC = [];%储存单项目内每个活动对应的技能需求量
    SC = [];%储存单项目内每个活动需要的技能种类
    BC_s = [];%储存单项目内技能需求量超过可用量的活动
    iter_SC = zeros(1,skill_count);%储存单项目内各种技能需求量之和，技能s1,s2,s3,...,s7依次分布排开
    for lie = 1:size(LP,2) %列
        if ~isempty(LP{hang,lie}) %如果非空
            % BC = [];
            count = count+1;
            pro = LP{hang,lie}(1);%行-项目数
            act = LP{hang,lie}(2);%列-活动数
            a = GlobalSourceRequest(pro,act);%每个活动对应的技能需求量
            AC(count) = GlobalSourceRequest(pro,act); %每个活动对应的技能需求量
            SC(count) = skill_cate(pro,act); %储存该活动需要的技能种类
            if AC(count) > iter_skill_num(SC(count))
                BC = LP(hang,lie);  %记录这个不满足的活动
                BC_s = [BC_s,BC]; %该项目内这些活动当前不满足可用量
            end
        else   %说明该项目已经分配完毕
            break  %当出现第一个空集时，即可跳出列循环
        end
    end
    %3.3所有技能可用量都不满足且非空活动数与非0技能数保持一致
    if length(BC_s) == count
        count_1= count_1+1;
        not_satisfy_pro(count_1,:) = LP(hang,:); %储存所要删除的项目及活动,此时还带有空的元胞数组{[5,8],[]}
    else
        count_2= count_2+1;
        satisfy_pro(count_2,:) = LP(hang,:);
    end
end
%% 给符合项目数小于总项目数的去掉多余行数
if count_1~=size(LP,1)  %当前存在项目满足某一技能可用量
    while  size(satisfy_pro,1) ~= count_2
        satisfy_pro(count_2+1,:) = [];% 如果satisfy_pro的行数小于LP总行数，则去掉多余的行数，因为他们都是空格
    end
%else
   % L4 = [];%全部项目都不满足技能可用量，跳出该循环，L5为空，进入下一时刻
end




% order_x = [1:size(satisfy_pro,1)];
% L4 = perms(order_x);
%% 把不符合的项目都调整为一行
if count_1~=0       %~isempty (not_satisfy_pro)  %如果空集无法缩为一行了
    %处理not_satify_pro,不满足的项目活动都放在一行
    while  size(not_satisfy_pro,1) ~= count_1 %同上，把多余的项目行数为空的去掉，不然后续L5无法合并
        not_satisfy_pro(count_1+1,:) = [];% 如果satisfy_pro的行数小于LP总行数，则去掉多余的行数，因为他们都是空格
    end
    iter_not = conbine_cell_to_row(not_satisfy_pro);
end
%%
% if ~isempty(L4) %可能会出现count_1=0，即所有的项目都至少满足一种技能可用量
%     L5 = cell(size(L4,1),size(LP,1)*length(LP));%当各个PA定好活动顺序后，用来储存具体的各个项目活动执行顺序
%     
%     for hang = 1:size(L4,1)
%         for lie = 1: size(L4,2)
%             L5(hang,(lie-1)*length(satisfy_pro)+1:lie*length(satisfy_pro)) = satisfy_pro(L4(hang,lie),:);%1-6，第二个来的放到7-12,13-18
%         end
%         if count_1~=0
%             L5(hang, size(satisfy_pro,1)*length(satisfy_pro)+1:size(LP,1)*length(LP)) =   iter_not(1,:);%把不可能分配的项目统一放到有机会分配的项目之后，为了start&end+1
%         end
%     end
%     %无论何时， not_satisfy_pro里的项目未被分配的都应该开始时间和结束时间+1
% else
%     L5 = iter_not;%只有一行，即把所有的当前不能分配的放在一起，方便allocate_source,所有活动的start&end时间都＋1
% end

% else
% end
%% 项目数小于2的，只有一个项目，单独分配
% LP 遍历，当前只有一个项目活动，看是否满足人数，不满足L4就是空集，满足再放入L5中
%
%
%         count = 0;
%         for lie = 1:size(LP,2) %列
%            pro = LP{hang,lie}(1);%行-项目数
%                 act = LP{hang,lie}(2);%列-活动数
%                 a = GlobalSourceRequest(pro,act);%每个活动对应的技能需求量
%
%         end
%
%     end



%     L4 = L3;%LP也不变
%     L5 = cell(size(L4,1),size(LP,1)*length(LP));%当各个PA定好活动顺序后，用来储存具体的各个项目活动执行顺序
%
%
%     for hang = 1:size(L4,1)
%         for lie = 1: size(L4,2)
%             L5(hang,(lie-1)*length(LP)+1:lie*length(LP)) = LP(L4(hang,lie),:);%1-6，第二个来的放到7-12,13-18
%         end
%     end



%             A(pro) = sum(AC);%每个项目所有需求量之和
%         end
%                 for i1 = 1:skill_count
%                     [m1,n1] = find(SC == i1);%找到SC中技能分别为1，2，3，记录位置，n-列位置
%                     if ~isempty(n1)  %如果n非空，说明SC里有这个技能
%                         iter_SC(i1) = sum(AC(n1));% 则该技能需求量之和放在对应的技能位置
%                     else  %否则为空，则SC里没有这个技能
%                         iter_SC(i1) = 0; %则该技能需求量之和为0
%                     end
%                 end



%   if count_2 < size(LP,1)%如果satisfy_pro的行数小于LP总行数，则去掉多余的行数，因为他们都是空格
%         while  size(satisfy_pro,1) ~= count_2
%              satisfy_pro(count_2+1,:) = [];
%         end
%
%         for count_3 = count_2+1:size(LP,1)
%             satisfy_pro(count_3,:) = [];%去掉后，方便后续排序L4，防止出现当删掉
%         end
%     end


%     LP = iter_LP;

%         if any(iter_SC > iter_skill_num)==1 %3.3所有技能可用量都不满足
%                 LP(hang,:) = []; %remove项目，减少项目个数LP还是L2?先放L2里，再引入函数LP
%                  [LP,yb,box_pro] = find_LP(L2); %
%         end
%         if all(inter_SC <= iter_skill_num)==1 &&  A(hang)<=B %3.1比较对应位置值大小，(每种技能的需求量之和与每种可用量比较 && all需求量之和与all可用量之和）
%             all_perm(hang) = pro; %记录该项目，等待全排列
%             C1=1;
%             continue
%         else
%             if any(inter_SC > iter_skill_num)==1 %3.3所有技能可用量都不满足
%                 LP{hang,:} = []; %remove项目，减少项目个数
%                 C2=1;
%             else
%                 %if any(inter_SC <= iter_skill_num)~=1  %3.2并非所有技能可用量都满足
%                % pre_perm(hang) = length(inter_SC <= inter_skill_num);  %record每一行的满足可用量的个数，later排序
%                pre_perm(hang) = pro;%并非所有技能可用量都满足时候就随机储存，
%                 C3=1;
%             end
%         end

%移除后只负责全排列的好了，然后使用变邻域，依次跟全排列得到的顺序进行对比

% if C1==1  %处理每种情况对应的项目，移除怎么移除，放在LP？如何放回main里？
% end
% if C2==1
% end
% if C3==1
% end

% iter_L3 = L3;%建立起L3的全排列（1，2，3）
% L4 = iter_L3;%—随机（4）-移除（5）移除后放哪里？;


% Global_PRO = A(find(A~=0));%去掉为0的数，所有项目需求量之和
% N_max = sum(Global_PRO);%最大需要人数，所有项目需要人数的累加和
% N_min = min(Global_PRO);%最小需要人数，每个项目需要人数之和的最小值
% cover_pro = ceil(people*length(yb)/(N_max-N_min));%可用量可支撑的项目数
%%
% new_iteration = cover_pro*combntns(length(yb),cover_pro);%确定排列次数?如何组合取数值？
% L4 = L3(1:min(iterations,new_iteration),:);%取出阶乘和预设谈判最小的作为本次谈判次数

%
% L5 = cell(size(L4,1),size(L4,1)*length(LP));%当各个PA定好活动顺序后，用来储存具体的各个项目活动执行顺序
% for hang = 1:size(L4,1)
%     for lie = 1: size(L4,2)
%         L5(hang,(lie-1)*length(LP)+1:lie*length(LP)) =LP(L4(hang,lie),:);%1-6，第二个来的放到7-12,13-18
%     end
% end


