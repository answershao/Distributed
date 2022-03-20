
function [best_order] = find_varible(L5,L4)
%解空间：L5     项目号排列L4
num=randperm(size(L5,1),1);%从1-L5的行数中随机取一个整数    L4 = [1,2，3;3，2,1，312；。。。];L5均为解空间
S1 = L4(num,:); %选择一个项目序列作为初始项目顺序        S1= 1 2 3
S2 = L5(num,:); %选择对应的项目活动作为初始项目活动顺序  S2 = {[1,2],[1,3],[2,3],..[]}
S_obj = 8;%初始项目顺序对应的初始解与main有关
allocate_pro = size(L4,1); %判断可以分配的项目数，如5个项目里只有3个可以被分配，就无需往下变换邻域了
i = 1;%第一个位置的项目
count = 0;%便于记录循环几次可以得出代替初始解的解
%% 交换顺序
while i <= allocate_pro
    count = count + 1;
    a = S1(1,i);  %a = 1
    S1(1,i) = S1(1,i+1); %b = 2
    S1(1,i+1) = a; %iter_S1 = [2 1 3],Note:所找到的解都是L4/L5解空间里的解
    iter_S1= S1;  %iter_S1是交换之后的解顺序 
    [lia,loc] = ismember(iter_S1,L5(:,1:length(S1)),'rows'); %loc:iter_S1在L5中的行数
    iter_S2 = L5(loc,:); %选出该行对应的项目活动顺序
    
    
    % 求解 S_cur
    if  S_cur > S_obj
        i = i + 1;
    else
        S_obj = S_cur;
        i = 1;
    end
end
% printf('', count)