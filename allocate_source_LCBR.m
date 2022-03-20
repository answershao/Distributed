function [result, temp_Lgs, temp_skill_num,temp_d2, temp_local_start_times, temp_local_end_times,temp_RN] = allocate_source_LCBR(time,Cur_Conflict,skill_cate,GlobalSourceRequest,iter_Lgs,iter_skill_num,iter_d,iter_d2,iter_local_start_times,iter_local_end_times,iter_RN)
% �������ܣ� 1��˳�����Դ����
% ���
% skill_number = [];%����ֵ
% Resource_number = [];%ִ�иû����Դ���
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
for v = 1:length(Cur_Conflict)  % ������ͻ�б���ÿ������
    i = Cur_Conflict{1,v}(1,1);
    j = Cur_Conflict{1,v}(1,2);
    if  GlobalSourceRequest(i,j) <= temp_skill_num(skill_cate(i,j))  % ����˳�����ȷ��似��ֵ�ߵ���Դ,��һ���ȼ�
        lgs_1= temp_Lgs(skill_cate(i,j),:);%�ü��ܵ���Դ����ֵ���������ֵ
        RC_g_b = zeros(1,people);
        for resource = 1:people
            skill_distribution(resource) = length(find(temp_Lgs(:,resource)~=0));%������
            box = [];%����һЩֵ
            for skill_kind = 1: size(temp_Lgs,1)
                if temp_Lgs(skill_kind,resource) ~=0    %ÿ����Դ��Ӧ�ļ���ֵ��0������߱���Ϊ1����Ϊ0������߱���Ϊ0��
                    y_skill_resource =1;   %��Դ�Ƿ����ռ��ܵľ��߱���
                else
                    y_skill_resource =0;
                    box(skill_kind) =  (1-temp_Lgs(skill_kind,resource))*y_skill_resource;
                end
            end
            RC_g_b(resource)= skill_distribution(resource)+ sum(box);%%%������Դ�ٽ���
            resource_serial(resource) = resource;%��Դ���
        end
        %%������Դ�ٽ��Ե͵�����
        %1.������ skill_distribution+��1-����ֵskill_number�� 
        A = [RC_g_b;resource_serial];%������Դ�ٽ��Եͣ�ʹ�ü���ֵ�ߵʹ���ƽ�֣��Ѿ�д�ڹ�ʽ���ˣ�����Դ��Ŵ���ƽ�� ������ָ��
        [B, indexb] = sortrows(A'); %����indexbָ������Ӧ����Դ���
        Maxres = B(:,2)';%��Դ��ţ������Ӧ����ֵ
        MMaxlgs =zeros(1,length(Maxres)); %���漼��ֵ��������Ϊ�����Ǽ���ֵ�����Ի��нϵ͵ļ���ֵ����ǰ�ߣ������Ϊ0 �������
        for re_num = 1:length(Maxres)
            %��Դ��Ŵ���Ա��-���ܾ������
            MMaxlgs(re_num) = temp_Lgs(skill_cate(i,j),Maxres(re_num));
        end

        %%�һ�����Դ�ٽ��Ե͵����ȣ���ǰ������ok   
        M_MMaxlgs = MMaxlgs(find(MMaxlgs~=0));
        skill_number    =   M_MMaxlgs(1,1:GlobalSourceRequest(i,j));  %��������ʱ��Ӧ��ǰ����ѡ�񼰴Ӹߵ���ѡ��
        %�ҵ�MMMaxlgs��Ϊ0�Ķ�Ӧ��λ�ã���Maxres�б�ǳ�����
        indexb_bb = Maxres(find(MMaxlgs~=0));%ȥ����Ϊ0 �����µ���Դ���
        Resource_number =    indexb_bb(1:GlobalSourceRequest(i,j));
        temp_d(j,1,i)   =   ceil(GlobalSourceRequest(i,j)*iter_d(j,1,i)/sum(skill_number));  %��û��ʵ�ʹ���
        temp_d2(j,1,i) = temp_d(j,1,i); 
        for k = 1:length(Resource_number)     %�Ѱ��ŵ���Դ�ҵ�
            temp_RN(Resource_number(k)) = temp_RN(Resource_number(k))+ temp_d2(j,1,i);%�ҵ�ÿ����Դ�����
            %ÿ����Դ�Ĺ���ʱ���ۼ�
        end
        temp_Lgs(:, Resource_number) = 0;                                          % �ѷ������Դ��Ӧ�����м���ֵ��Ϊ0
        temp_skill_num = (sum(temp_Lgs~=0,2))';                   % ÿһ�в�Ϊ0�ļ������  % ���ܿ��������� iter_skill_num  
        temp_local_end_times(i,j) = time + temp_d2(j,1,i);
        result{v} = {skill_number, Resource_number, [i,j], temp_local_end_times(i,j), temp_local_start_times(i,j)};  
    else
        temp_local_start_times(i,j) =temp_local_start_times(i,j)+1;
        temp_local_end_times(i,j) =temp_local_end_times(i,j)+1;
    end
end

