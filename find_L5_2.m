function [satisfy_pro,iter_not] = find_L5_2(LP,GlobalSourceRequest,skill_cate,skill_count,iter_skill_num)
%global max_iteration
% yb = [3,4]
% order = [1: length(yb)];
% iterations = factorial(length(yb));%��Ŀ�Ľ׳�
% order = [1: length(yb)];
%L3 = perms(order);%���ݽ׳��ĺ�˳����
%if length(yb) >=1
B = sum(iter_skill_num);%��ǰʱ��ȫ����Դ��������iter_skill_num��Ӧ�������ܵĿ�����
all_perm = []; %�������ȫ���е���Ŀ����������ܼ�ȫ�ֵĿ�����-ȫ����
pre_perm = [];%���水�����ȹ������е���Ŀ����
satisfy_pro = cell(size(LP,1),length(LP));  %���治�Ƴ�����Ŀ
not_satisfy_pro= cell(size(LP,1),length(LP));%�������Ƴ�����Ŀ����ʱ�̽�������Ҫ�ټ���
count_1=0;
count_2=0;
iter_not = [];
for hang = 1:size(LP,1) %��
    count = 0;
    % A = [];%����ÿ����Ŀ������Դ֮��
    AC = [];%���浥��Ŀ��ÿ�����Ӧ�ļ���������
    SC = [];%���浥��Ŀ��ÿ�����Ҫ�ļ�������
    BC_s = [];%���浥��Ŀ�ڼ��������������������Ļ
    iter_SC = zeros(1,skill_count);%���浥��Ŀ�ڸ��ּ���������֮�ͣ�����s1,s2,s3,...,s7���ηֲ��ſ�
    for lie = 1:size(LP,2) %��
        if ~isempty(LP{hang,lie}) %����ǿ�
            % BC = [];
            count = count+1;
            pro = LP{hang,lie}(1);%��-��Ŀ��
            act = LP{hang,lie}(2);%��-���
            a = GlobalSourceRequest(pro,act);%ÿ�����Ӧ�ļ���������
            AC(count) = GlobalSourceRequest(pro,act); %ÿ�����Ӧ�ļ���������
            SC(count) = skill_cate(pro,act); %����û��Ҫ�ļ�������
            if AC(count) > iter_skill_num(SC(count))
                BC = LP(hang,lie);  %��¼���������Ļ
                BC_s = [BC_s,BC]; %����Ŀ����Щ���ǰ�����������
            end
        else   %˵������Ŀ�Ѿ��������
            break  %�����ֵ�һ���ռ�ʱ������������ѭ��
        end
    end
    %3.3���м��ܿ��������������ҷǿջ�����0����������һ��
    if length(BC_s) == count
        count_1= count_1+1;
        not_satisfy_pro(count_1,:) = LP(hang,:); %������Ҫɾ������Ŀ���,��ʱ�����пյ�Ԫ������{[5,8],[]}
    else
        count_2= count_2+1;
        satisfy_pro(count_2,:) = LP(hang,:);
    end
end
%% ��������Ŀ��С������Ŀ����ȥ����������
if count_1~=size(LP,1)  %��ǰ������Ŀ����ĳһ���ܿ�����
    while  size(satisfy_pro,1) ~= count_2
        satisfy_pro(count_2+1,:) = [];% ���satisfy_pro������С��LP����������ȥ���������������Ϊ���Ƕ��ǿո�
    end
%else
   % L4 = [];%ȫ����Ŀ�������㼼�ܿ�������������ѭ����L5Ϊ�գ�������һʱ��
end




% order_x = [1:size(satisfy_pro,1)];
% L4 = perms(order_x);
%% �Ѳ����ϵ���Ŀ������Ϊһ��
if count_1~=0       %~isempty (not_satisfy_pro)  %����ռ��޷���Ϊһ����
    %����not_satify_pro,���������Ŀ�������һ��
    while  size(not_satisfy_pro,1) ~= count_1 %ͬ�ϣ��Ѷ������Ŀ����Ϊ�յ�ȥ������Ȼ����L5�޷��ϲ�
        not_satisfy_pro(count_1+1,:) = [];% ���satisfy_pro������С��LP����������ȥ���������������Ϊ���Ƕ��ǿո�
    end
    iter_not = conbine_cell_to_row(not_satisfy_pro);
end
%%
% if ~isempty(L4) %���ܻ����count_1=0�������е���Ŀ����������һ�ּ��ܿ�����
%     L5 = cell(size(L4,1),size(LP,1)*length(LP));%������PA���û˳��������������ĸ�����Ŀ�ִ��˳��
%     
%     for hang = 1:size(L4,1)
%         for lie = 1: size(L4,2)
%             L5(hang,(lie-1)*length(satisfy_pro)+1:lie*length(satisfy_pro)) = satisfy_pro(L4(hang,lie),:);%1-6���ڶ������ķŵ�7-12,13-18
%         end
%         if count_1~=0
%             L5(hang, size(satisfy_pro,1)*length(satisfy_pro)+1:size(LP,1)*length(LP)) =   iter_not(1,:);%�Ѳ����ܷ������Ŀͳһ�ŵ��л���������Ŀ֮��Ϊ��start&end+1
%         end
%     end
%     %���ۺ�ʱ�� not_satisfy_pro�����Ŀδ������Ķ�Ӧ�ÿ�ʼʱ��ͽ���ʱ��+1
% else
%     L5 = iter_not;%ֻ��һ�У��������еĵ�ǰ���ܷ���ķ���һ�𣬷���allocate_source,���л��start&endʱ�䶼��1
% end

% else
% end
%% ��Ŀ��С��2�ģ�ֻ��һ����Ŀ����������
% LP ��������ǰֻ��һ����Ŀ������Ƿ�����������������L4���ǿռ��������ٷ���L5��
%
%
%         count = 0;
%         for lie = 1:size(LP,2) %��
%            pro = LP{hang,lie}(1);%��-��Ŀ��
%                 act = LP{hang,lie}(2);%��-���
%                 a = GlobalSourceRequest(pro,act);%ÿ�����Ӧ�ļ���������
%
%         end
%
%     end



%     L4 = L3;%LPҲ����
%     L5 = cell(size(L4,1),size(LP,1)*length(LP));%������PA���û˳��������������ĸ�����Ŀ�ִ��˳��
%
%
%     for hang = 1:size(L4,1)
%         for lie = 1: size(L4,2)
%             L5(hang,(lie-1)*length(LP)+1:lie*length(LP)) = LP(L4(hang,lie),:);%1-6���ڶ������ķŵ�7-12,13-18
%         end
%     end



%             A(pro) = sum(AC);%ÿ����Ŀ����������֮��
%         end
%                 for i1 = 1:skill_count
%                     [m1,n1] = find(SC == i1);%�ҵ�SC�м��ֱܷ�Ϊ1��2��3����¼λ�ã�n-��λ��
%                     if ~isempty(n1)  %���n�ǿգ�˵��SC�����������
%                         iter_SC(i1) = sum(AC(n1));% ��ü���������֮�ͷ��ڶ�Ӧ�ļ���λ��
%                     else  %����Ϊ�գ���SC��û���������
%                         iter_SC(i1) = 0; %��ü���������֮��Ϊ0
%                     end
%                 end



%   if count_2 < size(LP,1)%���satisfy_pro������С��LP����������ȥ���������������Ϊ���Ƕ��ǿո�
%         while  size(satisfy_pro,1) ~= count_2
%              satisfy_pro(count_2+1,:) = [];
%         end
%
%         for count_3 = count_2+1:size(LP,1)
%             satisfy_pro(count_3,:) = [];%ȥ���󣬷����������L4����ֹ���ֵ�ɾ��
%         end
%     end


%     LP = iter_LP;

%         if any(iter_SC > iter_skill_num)==1 %3.3���м��ܿ�������������
%                 LP(hang,:) = []; %remove��Ŀ��������Ŀ����LP����L2?�ȷ�L2������뺯��LP
%                  [LP,yb,box_pro] = find_LP(L2); %
%         end
%         if all(inter_SC <= iter_skill_num)==1 &&  A(hang)<=B %3.1�Ƚ϶�Ӧλ��ֵ��С��(ÿ�ּ��ܵ�������֮����ÿ�ֿ������Ƚ� && all������֮����all������֮�ͣ�
%             all_perm(hang) = pro; %��¼����Ŀ���ȴ�ȫ����
%             C1=1;
%             continue
%         else
%             if any(inter_SC > iter_skill_num)==1 %3.3���м��ܿ�������������
%                 LP{hang,:} = []; %remove��Ŀ��������Ŀ����
%                 C2=1;
%             else
%                 %if any(inter_SC <= iter_skill_num)~=1  %3.2�������м��ܿ�����������
%                % pre_perm(hang) = length(inter_SC <= inter_skill_num);  %recordÿһ�е�����������ĸ�����later����
%                pre_perm(hang) = pro;%�������м��ܿ�����������ʱ���������棬
%                 C3=1;
%             end
%         end

%�Ƴ���ֻ����ȫ���еĺ��ˣ�Ȼ��ʹ�ñ��������θ�ȫ���еõ���˳����жԱ�

% if C1==1  %����ÿ�������Ӧ����Ŀ���Ƴ���ô�Ƴ�������LP����ηŻ�main�
% end
% if C2==1
% end
% if C3==1
% end

% iter_L3 = L3;%������L3��ȫ���У�1��2��3��
% L4 = iter_L3;%�������4��-�Ƴ���5���Ƴ�������;


% Global_PRO = A(find(A~=0));%ȥ��Ϊ0������������Ŀ������֮��
% N_max = sum(Global_PRO);%�����Ҫ������������Ŀ��Ҫ�������ۼӺ�
% N_min = min(Global_PRO);%��С��Ҫ������ÿ����Ŀ��Ҫ����֮�͵���Сֵ
% cover_pro = ceil(people*length(yb)/(N_max-N_min));%��������֧�ŵ���Ŀ��
%%
% new_iteration = cover_pro*combntns(length(yb),cover_pro);%ȷ�����д���?������ȡ��ֵ��
% L4 = L3(1:min(iterations,new_iteration),:);%ȡ���׳˺�Ԥ��̸����С����Ϊ����̸�д���

%
% L5 = cell(size(L4,1),size(L4,1)*length(LP));%������PA���û˳��������������ĸ�����Ŀ�ִ��˳��
% for hang = 1:size(L4,1)
%     for lie = 1: size(L4,2)
%         L5(hang,(lie-1)*length(LP)+1:lie*length(LP)) =LP(L4(hang,lie),:);%1-6���ڶ������ķŵ�7-12,13-18
%     end
% end


