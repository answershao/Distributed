clc;
close all;
clear all;
fclose('all');
%% һ. ��������׼��
% 1.1 �������
global T cycles resource_cate Simul_Num

T = 1000; % ��ʱ��
cycles = 10; % 10�Σ��ɿ��ǲ����ˣ���Ϊ�����һ��
resource_cate = 4; % ��Դ������,ʵ�ʲ������Ǿֲ���Դ�����������
Simul_Num = 1; % �������,��Ҫ�������������ʱ����һ�£�ͬʱ�ı�

% save folder path set
cur_time = fix(clock);
date_time = strcat(date, ', ', num2str(cur_time(4)), '_ ', num2str(cur_time(5)));
folder = strcat('..//save//', date_time);

if ~exist(folder)
    mkdir(folder)
end

L = 5;
skill_count = 3;
num_j = 6;
[summary_info_save, result_saves_file] = sub_main(folder, num_j, L, skill_count);

