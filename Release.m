function [allocated_set,iter_Lgs, iter_skill_num] =Release(time,chosen_results,allocated_set,Lgs,iter_Lgs, iter_skill_num)
for i=1:length(chosen_results)   %��timeΪ2ʱ����ʼ��1,2����
    temp0 = chosen_results{i};
    for j=1:length(temp0)
        temp = temp0(j);
        if  ~isempty(temp{1})%���ֻ��һ��
            temp1 = temp{1};
            % temp11 = temp1(1);  %skill_number
            temp12 = temp1(2);  %Resource_number
            temp13 = temp1(3);  % ����
            temp14 = temp1(4);  % �ͷ�ʱ��
            if isempty(allocated_set)   %����ռ�ֱ�Ӽ���
                allocated_set = [allocated_set, temp13{1}];%�ҵ���Щ��Ŀ�ʼʱ��
            else
                count = 0;   %����ǿգ��ж��Ƿ��Ѿ����ڣ������ھͼ���
                m = 1;
                len = length(allocated_set);
                while m <= len
                    xx = (temp13{1} == allocated_set{1,m});
                    if xx(1) ==1 && xx(2) == 1
                        break
                    else
                        count = count+1;
                        m = m+1;
                    end
                    if count == length(allocated_set)
                        allocated_set = [allocated_set, temp13{1}];
                    end
                end
            end
            if temp14{1}== time+1  % ����ͷ�ʱ����ڵ�ǰʱ��
                iter_Lgs(:, temp12{1}) = Lgs(1:end,temp12{1});
                iter_skill_num(1,:) = (sum(iter_Lgs~=0,2))';
            end
        end
    end
end
end