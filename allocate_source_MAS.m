function [result, temp_Lgs, temp_skill_num,temp_d2, temp_local_start_times, temp_local_end_times,temp_RN] = allocate_source_MAS(time,Cur_Conflict,skill_cate,GlobalSourceRequest,iter_Lgs,iter_skill_num,iter_d,iter_d2,iter_local_start_times,iter_local_end_times,iter_RN)
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
        for resource = 1:people
            skill_distribution(resource) = length(find(temp_Lgs(:,resource)~=0));%������
            resource_serial(resource) = resource;%��Դ���
        end
        AVE_Lgs = size(temp_Lgs,2);%������Դ���ռ��ܵľ�ֵ
        for in = 1:AVE_Lgs
            AVE_Lgs(in) =  sum(temp_Lgs(:,in))/size(temp_Lgs ,1);
        end
        %% �Ҽ��ܾ�ֵ�ߵ�Ԫ��
        A = [AVE_Lgs;-resource_serial];%��Դ���ռ��ܵľ�ֵ�͡���Դ��Ŵ���ƽ�� ����ָ�ɣ�Ӧ���������resource����ϣ���һ�е���Դû�����ոü�����ô��
        [B, indexb] = sortrows(A'); %����indexbָ������Ӧ����Դ���,�ӵ͵���
        B(:,2) = -B(:,2);%�Ѹ�λ���ϵļ���ֵ����Դ��Ŵӵ͵�����,�Ӹ�ֵ
        Maxres = B(:,2)';%��Դ��ţ������Ӧ����ֵ
        MMaxlgs =zeros(1,length(Maxres)); %���漼��ֵ
        for re_num = 1:length(Maxres)
            %��Դ��Ŵ���Ա��-���ܾ������
            MMaxlgs(re_num) = temp_Lgs(skill_cate(i,j),Maxres(re_num));
        end
        %�Ҽ��ܾ�ֵ�ߵ�Ԫ��
        M_MMaxlgs = MMaxlgs(find(MMaxlgs~=0));
        skill_number    =   M_MMaxlgs(1,length(M_MMaxlgs)-GlobalSourceRequest(i,j)+1:end);  %��������ʱ��Ӧ��ǰ����ѡ�񼰴Ӹߵ���ѡ��
        %�ҵ�MMMaxlgs��Ϊ0�Ķ�Ӧ��λ�ã���Maxres�б�ǳ�����
        indexb_bb = Maxres(find(MMaxlgs~=0));%ȥ����Ϊ0 �����µ���Դ���
        Resource_number =    indexb_bb(length(M_MMaxlgs)-GlobalSourceRequest(i,j)+1:end); %��ֵ��Ӧ�ôӺ���ǰ��
        
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