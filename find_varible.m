
function [best_order] = find_varible(L5,L4)
%��ռ䣺L5     ��Ŀ������L4
num=randperm(size(L5,1),1);%��1-L5�����������ȡһ������    L4 = [1,2��3;3��2,1��312��������];L5��Ϊ��ռ�
S1 = L4(num,:); %ѡ��һ����Ŀ������Ϊ��ʼ��Ŀ˳��        S1= 1 2 3
S2 = L5(num,:); %ѡ���Ӧ����Ŀ���Ϊ��ʼ��Ŀ�˳��  S2 = {[1,2],[1,3],[2,3],..[]}
S_obj = 8;%��ʼ��Ŀ˳���Ӧ�ĳ�ʼ����main�й�
allocate_pro = size(L4,1); %�жϿ��Է������Ŀ������5����Ŀ��ֻ��3�����Ա����䣬���������±任������
i = 1;%��һ��λ�õ���Ŀ
count = 0;%���ڼ�¼ѭ�����ο��Եó������ʼ��Ľ�
%% ����˳��
while i <= allocate_pro
    count = count + 1;
    a = S1(1,i);  %a = 1
    S1(1,i) = S1(1,i+1); %b = 2
    S1(1,i+1) = a; %iter_S1 = [2 1 3],Note:���ҵ��Ľⶼ��L4/L5��ռ���Ľ�
    iter_S1= S1;  %iter_S1�ǽ���֮��Ľ�˳�� 
    [lia,loc] = ismember(iter_S1,L5(:,1:length(S1)),'rows'); %loc:iter_S1��L5�е�����
    iter_S2 = L5(loc,:); %ѡ�����ж�Ӧ����Ŀ�˳��
    
    
    % ��� S_cur
    if  S_cur > S_obj
        i = i + 1;
    else
        S_obj = S_cur;
        i = 1;
    end
end
% printf('', count)