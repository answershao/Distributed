function [simul_d] = simulation_d(d,L,num_j,Simul_Num)%��ö�η���ľ�ֵ

simul_d = zeros(Simul_Num, num_j, L);
% simul_num = 1:Simul_Num   %ÿ����1�Σ�ÿ������õ�һ������Ĺ���
for i = 1:L
    for  j = 1:num_j
        a =  d(j,1,i)-sqrt(d(j,1,i));%���ȷֲ���ȡֵ������½�
        b = d(j,1,i)+sqrt(d(j,1,i));%���ȷֲ���ȡֵ������Ͻ�
        rand("seed",(4+j)*i)
        simul_d(:,j,i)= ceil(a+(b-a).*rand(Simul_Num,1)); %U1���ȷֲ��ڸ÷�Χ�����ȡ5���������Ǹû����5�εõ��Ĺ��ڣ�
    end
end
simul_d(:,1,1:L) = 0;simul_d(:,num_j,1:L) = 0; %�����ĵ�һ�к����һ�е��������ھ�Ϊ0
%d�е�ÿ������Ϊ�û��ȷ���µ�����ֵ����η���õ���ֵ�ֱ���뵽ÿ��ִ����


%simul_d =ceil(6+(12-6).*rand(5,1));%���������ȡ��
%������ݾ�ֵ�ı仯Ϊ�仯���̶���ʽ��
%�ڸ÷ֲ��½��й��ڵķ���
for num = 1: Simul_Num
    D = simul_d(num,1:num_j,1:L);
    squeeze(D)
end


%������Ӳ�ͬ���ʷֲ��Ĺ���
%����һ���ķ������Χ
%�����ɵĹ��ڽ��ж��鱣��չʾ����ֵȡPSLIB�е�ȷ���ԵĹ��ڼ��ɣ��������ò�ͬ��Χ









