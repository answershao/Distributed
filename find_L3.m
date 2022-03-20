function [L3] = find_L3(L2)
A = perms(L2); % ��ͻ�ȫ����-----------?
temp_seq = 1:1:length(L2);
sum1 = cumsum(temp_seq);    % ��һ�� length(L2) �ۼӺ�
theory_value = 2*sum1(end);
if size(A,1) > theory_value
    sequence = ceil(linspace(1, size(A, 1), theory_value));  % �ȼ��ѡȡ
    L3 = A(sequence,:);
else
    L3 = A;
end
end
% length(L2);
% index(L2);%��L2��ÿ�����ǵ�λ�ã�����λ����žͼ����
% randperm(length(L2));%�⼸��λ�ò��ظ�����һ��
% Ҫȡ 10000�Σ�����ÿ�ζ����ظ� 