
%
L = 2;
num_j = 32;
% 分布
for outer_i = 1:length(activity_rules_set)
    activity_rules = activity_rules_set{outer_i};
    for outer_j  = 1:length(allocate_source_rules_set)
        allocate_source_rules = allocate_source_rules_set{outer_j};
        % 计算
        for sim_num= 1:5
            LST
            LFT
            
            CPM
            find_PR
         
        end
        % output : 
        if slst
        elseif slft
        elseif lst
        end
        % 计算
        % 1. 局部 CPM
        % 2. 全部
        
        for sim_num= 1:5
            cpm()
            SLST: 均值，仿真5次qu
            局部 
            LFT
            全局
        end
    end
end





