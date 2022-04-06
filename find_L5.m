function [L5,L4] = find_L5( satisfy_pro,delay)
Delay = [];
Pro_serial = [];
yb = [];
for i = 1:size(satisfy_pro,1)
    yb(i) = satisfy_pro{i,1}(1);
end


for pro_LP = 1: length(yb)
    Delay(pro_LP)= delay(yb(pro_LP));
    Pro_serial(pro_LP) = yb(pro_LP);
end
A = [-Delay;Pro_serial];%单位成本越高，越优先指派
[B, indexb] = sortrows(A');  %indexb-项目序号
B(:,1) = -B(:,1);            %要的是Pro_serial项目序号
%把indexb里的项目序号，如果得到的是1-2，则先指派PA1-PA2
L4 = indexb';
L5 = cell(1,length(L4)*length(satisfy_pro));%当各个PA定好活动顺序后，用来储存具体的各个项目活动执行顺序

for lie = 1: size(L4,2)
    L5(1,(lie-1)*length(satisfy_pro)+1:lie*length(satisfy_pro)) =satisfy_pro(L4(1,lie),:);%1-6，第二个来的放到7-12,13-18
end