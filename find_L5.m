function [L5] = find_L5(L2, LP, yb,delay)


Delay = [];
                    Pro_serial = [];
                    for    pro_LP = 1: length(yb)
                        Delay(pro_LP)= delay(yb(pro_LP));
                        Pro_serial(pro_LP) = yb(pro_LP);
                    end
                    A = [-Delay;Pro_serial];%��λ�ɱ�Խ�ߣ�Խ����ָ��
                    [B, indexb] = sortrows(A');  %indexb-��Ŀ���
                    B(:,1) = -B(:,1);            %Ҫ����Pro_serial��Ŀ���
                    %��indexb�����Ŀ��ţ�����õ�����1-2������ָ��PA1-PA2
                    L4 = indexb';
                    L5 = cell(1,length(L4)*length(L2));%������PA���û˳��������������ĸ�����Ŀ�ִ��˳��
                    
                    for lie = 1: size(L4,2)
                        L5(1,(lie-1)*length(L2)+1:lie*length(L2)) =LP(L4(1,lie),:);%1-6���ڶ������ķŵ�7-12,13-18
                    end