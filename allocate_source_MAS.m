function [result, temp_Lgs, temp_skill_num,temp_d2, temp_local_start_times, temp_local_end_times,temp_RN] = allocate_source_MAS(time,Cur_Conflict,skill_cate,GlobalSourceRequest,iter_Lgs,iter_skill_num,iter_d,iter_d2,iter_local_start_times,iter_local_end_times,iter_RN)
% 函数功能， 1种顺序的资源分配
% 输出
% skill_number = [];%技能值
% Resource_number = [];%执行该活动的资源序号

people = length(iter_RN);
temp_Lgs = iter_Lgs;
temp_skill_num = iter_skill_num;
% temp_R = iter_R;
temp_d = iter_d;
temp_d2 = iter_d2;
temp_local_start_times = iter_local_start_times;
temp_local_end_times = iter_local_end_times;

temp_RN = iter_RN;
result = {};
skill_distribution = [];
resource_serial = [];

for v = 1:length(Cur_Conflict)  % 遍历冲突列表中每个数组
    i = Cur_Conflict{1,v}(1,1);
    j = Cur_Conflict{1,v}(1,2);
    if  GlobalSourceRequest(i,j) <= temp_skill_num(skill_cate(i,j))  % 按照顺序优先分配技能值高的资源,第一优先级
        lgs_1= temp_Lgs(skill_cate(i,j),:);%该技能的资源掌握值情况，技能值
        for resource = 1:people
            skill_distribution(resource) = length(find(temp_Lgs(:,resource)~=0));%技能数
            resource_serial(resource) = resource;%资源序号
        end
        AVE_Lgs = size(temp_Lgs,2);%储存资源掌握技能的均值
        for in = 1:AVE_Lgs
            AVE_Lgs(in) =  sum(temp_Lgs(:,in))/size(temp_Lgs ,1);
        end
        %% 找技能均值高的元素
        A = [AVE_Lgs;-resource_serial];%资源掌握技能的均值低、资源序号打破平局 优先指派，应该问题出在resource序号上，万一有的资源没有掌握该技能怎么办
        [B, indexb] = sortrows(A'); %升序indexb指排序后对应的资源序号,从低到高
        B(:,2) = -B(:,2);%把该位置上的技能值、资源序号从低到高排,加负值
        Maxres = B(:,2)';%资源序号，下求对应技能值
        MMaxlgs =zeros(1,length(Maxres)); %储存技能值
        for re_num = 1:length(Maxres)
            %资源序号代表员工-技能矩阵的列
            MMaxlgs(re_num) = temp_Lgs(skill_cate(i,j),Maxres(re_num));
        end
        %找技能均值高的元素
        M_MMaxlgs = MMaxlgs(find(MMaxlgs~=0));
        skill_number    =   M_MMaxlgs(1,length(M_MMaxlgs)-GlobalSourceRequest(i,j)+1:end);  %技能数少时，应从前往后选择及从高到低选择
        %找到MMMaxlgs中为0的对应的位置，在Maxres中标记出来，
        indexb_bb = Maxres(find(MMaxlgs~=0));%去掉不为0 后留下的资源序号
        Resource_number =    indexb_bb(length(M_MMaxlgs)-GlobalSourceRequest(i,j)+1:end); %均值高应该从后往前数
        
        temp_d(j,1,i)   =   ceil(GlobalSourceRequest(i,j)*iter_d(j,1,i)/sum(skill_number));  %求该活动的实际工期
        temp_d2(j,1,i) = temp_d(j,1,i);
        
        for k = 1:length(Resource_number)     %把安排的资源找到
            temp_RN(Resource_number(k)) = temp_RN(Resource_number(k))+ temp_d2(j,1,i);%找到每个资源的序号
            %每个资源的工作时长累加
        end
        temp_Lgs(:, Resource_number) = 0;                                          % 已分配的资源对应的所有技能值都为0
        temp_skill_num = (sum(temp_Lgs~=0,2))';                   % 每一行不为0的计算个数  % 技能可用量更新 iter_skill_num 
        temp_local_end_times(i,j) = time + temp_d2(j,1,i);
        result{v} = {skill_number, Resource_number, [i,j], temp_local_end_times(i,j), temp_local_start_times(i,j)}; 
    else
        temp_local_start_times(i,j) =temp_local_start_times(i,j)+1;
        temp_local_end_times(i,j) =temp_local_end_times(i,j)+1;
    end
end