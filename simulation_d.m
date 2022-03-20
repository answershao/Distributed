function [simul_d] = simulation_d(d,L,num_j,Simul_Num)%获得多次仿真的均值

simul_d = zeros(Simul_Num, num_j, L);
% simul_num = 1:Simul_Num   %每仿真1次，每个活动将得到一个随机的工期
for i = 1:L
    for  j = 1:num_j
        a =  d(j,1,i)-sqrt(d(j,1,i));%均匀分布的取值区间的下界
        b = d(j,1,i)+sqrt(d(j,1,i));%均匀分布的取值区间的上界
        rand("seed",(4+j)*i)
        simul_d(:,j,i)= ceil(a+(b-a).*rand(Simul_Num,1)); %U1均匀分布在该范围内随机取5个数，就是该活动仿真5次得到的工期，
    end
end
simul_d(:,1,1:L) = 0;simul_d(:,num_j,1:L) = 0; %令矩阵的第一列和最后一列的虚拟活动工期均为0
%d中的每个工期为该活动不确定下的期望值，多次仿真得到的值分别计入到每次执行中


%simul_d =ceil(6+(12-6).*rand(5,1));%活动工期向上取整
%方差根据均值的变化为变化，固定公式，
%在该分布下进行工期的仿真
for num = 1: Simul_Num
    D = simul_d(num,1:num_j,1:L);
    squeeze(D)
end


%仿真服从不同概率分布的工期
%设置一定的方差波动范围
%将生成的工期进行多组保存展示，均值取PSLIB中的确定性的工期即可，方差设置不同范围









