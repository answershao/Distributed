function [R, r, d, E, delay, ad, people, forestset] = extract_project_info(file, L, num_j)

global resource_cate
FolderPath = strcat('F:\Distributed\QuestionSet-mpsplip\\','j',num2str(num_j-2),'\\','MP',num2str(num_j-2),'_',num2str(L),'\\','mp','_','j',num2str(num_j-2),'_','a',num2str(L),'_','nr',num2str(file));
FileName = read_folder(FolderPath); % 输出
people = process_rcp0(FileName,L);
%1.4 读取多项目数据
delay = zeros(1,L);
ad = zeros(1,L);
R = zeros(1,resource_cate,L);   %局部资源可用量
r = zeros(num_j, resource_cate, L);  %局部资源需求量
d = zeros(num_j, 1, L);       %期望工期-问题集中给出，
E = zeros(num_j, num_j-2, L);   %紧后活动集合
for i=1:L
    [delay1,ad1, R1, r1, d1, E1] = process_rcp(FileName(i,:), resource_cate, num_j);  %使用问题库算例时候，数据提取需要补充
    R(:,:,i) = R1;  % 第三个维度表示项目数
    r(:,:,i) = r1;  % 第三个维度表示项目数
    d(:,:,i) = d1;  % 第三个维度表示项目数
    E(:,:,i) = E1;
    delay(1,i) = delay1;
    ad(1,i) = ad1;
end


% 私自修改数据R，r
for i = 1: size(r,3)    % i活动数
    r(:,4,i) = 0;       %使得 r的第四列均为0 （即最后一列）
    R(1,4,i) = 0;       %使得R的第四列为0即不需要第四类局部资源，因为下面需要把第四类局部资源改为需要全局资源
end


% 计算紧前活动 forestset
for i=1:L
    forestset(:,:,i) = find_forestset(E(:,:,i), num_j);
end
end

