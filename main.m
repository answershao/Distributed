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
Simul_Num = 5; % �������,��Ҫ�������������ʱ����һ�£�ͬʱ�ı�

% save folder path set
cur_time = fix(clock);
date_time = strcat(date, ', ', num2str(cur_time(4)), '_ ', num2str(cur_time(5)));
folder = strcat('..//save//', date_time);

if ~exist(folder)
    mkdir(folder)
end

% ��Ŀ����
% for L = [2, 5]
     for L =  2
    % �ܻ��
    if L == 2
        skill_count = 3; % ����������
    elseif L == 5
        skill_count = 5; % ����������
    end

%     for num_j = [32, 92]
for num_j = [92]
        normalization_set = {'u1', 'u2', 'b1', 'b2', 'exp'};
        for i = 1:5
            normalization = normalization_set{i};
            sprintf(normalization)
            data_input = load(strcat('..\DataGenerate\dataset\', normalization, '_', num2str(Simul_Num), '_', num2str(L), '_', num2str(num_j - 2), '.mat'));
            statistic_CD = data_input.statistic_d;
            [summary_info_save, result_saves_file] = sub_main(folder, statistic_CD, num_j, L, skill_count, normalization);
            % save summart info
            save(strcat(folder, '\', normalization, '_', num2str(Simul_Num), '_', num2str(L), '_', num2str(num_j - 2), '.mat'), 'summary_info_save');
        end
    end
end

% L = 2;
% num_j = 32;
% % �ֲ�
% for outer_i = 1:length(activity_rules_set)
%     activity_rules = activity_rules_set{outer_i};
%     for outer_j  = 1:length(allocate_source_rules_set)
%         allocate_source_rules = allocate_source_rules_set{outer_j};
%         % ����
%         for sim_num= 1:5
%             LST
%             LFT
%
%             CPM
%             find_PR
%
%         end
%         % output :
%         if slst
%         elseif slft
%         elseif lst
%         end
%         % ����
%         % 1. �ֲ� CPM
%         % 2. ȫ��
%
%         for sim_num= 1:5
%             cpm()
%             SLST: ��ֵ������5��qu
%             �ֲ�
%             LFT
%             ȫ��
%         end
%     end
% end
