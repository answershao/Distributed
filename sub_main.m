function [summary_info_save, result_saves_file] = sub_main(folder, statistic_CD, num_j, L, skill_count, normalization)
global T cycles Simul_Num
allocate_source_rules_set = {'shsl', 'mas1', 'lcbr'};
activity_rules_set = {'lst1','lft1', 'slst', 'slft'};
% allocate_source_rules_set = {'shsl'};
% activity_rules_set = {'slft'};

summary_info_save = cell(length(activity_rules_set) * length(allocate_source_rules_set), 12);

for outer_i = 1:length(activity_rules_set)
    activity_rules = activity_rules_set{outer_i};
    
    for outer_j = 1:length(allocate_source_rules_set)
        allocate_source_rules = allocate_source_rules_set{outer_j};
        tic
        t = clock;
        TTC = [];
        APD = [];
        TMS = [];
        seq = 0;
        result_saves_file = cell(50, 12);
        
        for file = 1:5
            [R, r, d, E, delay, ad, people, forestset] = extract_project_info(file, L, num_j);
            [skill_cate, GlobalSourceRequest, Lgs, original_skill_num] = generate_global_info(L, num_j, r, people, skill_count);
            %             [CPM, cpm_start_time, cpm_end_time, original_local_start_times, original_local_end_times, UF, original_total_duration] = calculate_cpm(activity_rules, statistic_CD, d, E, L, R, r,num_j, ad, skill_count,skill_cate,GlobalSourceRequest,Lgs,forestset);
            LST = zeros(L, Simul_Num, num_j); %最晚开始时间
            LFT = zeros(L, Simul_Num, num_j); %最晚结束时间
            CPM = zeros(Simul_Num, L);
            cpm_start_time = zeros(L, Simul_Num, num_j);
            cpm_end_time = zeros(L, Simul_Num, num_j);
            UF = zeros(Simul_Num, 1);
            
            for num = 1:Simul_Num %仿真次数
                for i = 1:L
                    % sprintf('关键路径工期进度:%d / %d',i, L)
                    [CPM(num, i), cpm_start_time(i, num, :), cpm_end_time(i, num, :)] = cpm(statistic_CD(:, num, i), E(:, :, i));
                    sprintf('初始局部调度进度:%d / %d', i, L)
                    %写PA确定活动的优先规则，先写根据仿真工期均值获得的SLFT优先规则
                    [lst, lft] = find_PR_slft_slst(num_j, statistic_CD(:, num, i), E(:, :, i), cpm_end_time(i, num, :)); %-仿真工期-每次仿真生成的活动的LST,LFT
                    LST(i, num, :) = lst;
                    LFT(i, num, :) = lft;
                    %                 for project = 1:L
                    global_cpm_start_time(i,:) = cpm_start_time(i, num, :) + ad(i);
                    global_cpm_end_time(i,:) = cpm_end_time(i, num, :) + ad(i);%多项目中考虑全局资源时，便要考虑项目的到达时间
                    inter_GCPD(i) = max(global_cpm_end_time(i,:));
                end
                GCPD(num) = max(inter_GCPD);%全局关键路径时间
                UF(num) = find_UF(GCPD(num), statistic_CD(:, num, :), skill_count,skill_cate,GlobalSourceRequest,Lgs);%当前得出一个算例的UF
            end
            
            for cycle = 1:cycles %试验次数 2
                for num = 1:Simul_Num %仿真次数 5
                    original_local_start_times = zeros(Simul_Num, num_j, L); %此处的初始开始时间与之前不一，需要重新根据局部优先规则确定
                    original_local_end_times = zeros(Simul_Num, num_j, L);
                    for i = 1:L % CPLEX计算
                        sprintf('初始局部调度进度:%d / %d', i, L)
                        %LST需要带有仿真标志
                        if activity_rules == 'lst1'
                            [original_local_start_time, original_local_end_time] = locals_lst(num_j, R(:, :, i), r(:, :, i), statistic_CD(:, num, i), LST(i, num, :), LFT(i, num, :), forestset, ad(1, i));
                        elseif activity_rules == 'lft1'
                            [original_local_start_time,original_local_end_time] = locals_lft(num_j,R(:, :, i), r(:, :, i), statistic_CD(:, num, i), LFT(i, num, :), forestset, ad(1, i));
                        elseif activity_rules == 'slst'
                            [original_local_start_time, original_local_end_time] = locals_slst(num_j, R(:, :, i), r(:, :, i), statistic_CD(:, num, i), LST(i, num, :), LFT(i, num, :), forestset, ad(1, i));
                        elseif activity_rules == 'slft'
                            [original_local_start_time, original_local_end_time] = locals_slft(num_j, R(:, :, i), r(:, :, i), statistic_CD(:, num, i), LFT(i, num, :), forestset, ad(1, i));
                        end
                        original_local_start_times(num, :, i) = original_local_start_time + 1;
                        original_local_end_times(num, :, i) = original_local_end_time + 1;
                    end
                    %                     realitic_start_times = original_local_start_times - 1;
                    realitic_end_times = original_local_end_times - 1;
                    original_total_duration = max(realitic_end_times, [], 2); %初始局部调度各项目工期最大值
                    
                    %% CA全局协调决策进行
                    L1 = find_L1(GlobalSourceRequest); %找到所有需要全局资源的活动
                    % 需迭代的变量
                    iter_Lgs = Lgs;
                    iter_skill_num = original_skill_num; %全局资源可用量
                    temp_R = R; % 局部资源可用量
                    iter_d = statistic_CD(:, num, :); % 工期变化储存
                    iter_d2 = d; %save 每次分配完的活动实际工期和未分配的活动的期望工期集锦
                    iter_local_start_times = squeeze(original_local_start_times(num, :, :))';
                    iter_local_end_times = squeeze(original_local_end_times(num, :, :))';
                    % 循环
                    allocated_set = {}; chosen_results = []; iter_RN = zeros(1, people); %资源-时间矩阵
                    
                    for time = 1:T
                        sprintf('当前循环:%d-%d-%d', cycle, seq + 1, time)
                        L2 = find_L2(L1, iter_local_start_times, time, allocated_set); % 当前时刻需要全局资源的活动L2
                        if ~isempty(L2)
                            %以项目PA为单位 先给各PA进行全排列，根据项目序号不同
                            %确定好项目序号之后，再对不同项目序号下的活动进行启发式顺序确定
                            %（如同一个项目PA中出现2个活动同时开始，该如何确定让谁先开始）
                            [LP, ~, ~] = find_LP(L2); %yb---找到当前冲突时刻的项目数，及各项目的冲突活动分行排列
                            %LP不同项目储存不同行,yb项目序号，box_pro活动对应的项目序号
                            %把各个项目的活动单独写一个元胞组合，然后当有6种决策顺序时，根据每次的决策顺序不同，对应合并相应活动。
                            % variable neighborhood descent(VND)
                            [satisfy_pro, iter_not] = find_L5_2(LP, GlobalSourceRequest, skill_cate, skill_count, iter_skill_num);
                            % L4 空集，说明当前无项目符合技能可用量
                            % L4不是空集，即所有的项目都至少满足一种技能可用量
                            if ~isempty(iter_not) && ~isempty( satisfy_pro{1})
                                % iter not
                                [iter_local_start_times, iter_local_end_times] = find_act_not(iter_not, time, r, temp_R, iter_d, forestset, iter_local_start_times, iter_local_end_times);
                                % statisfy
                                allocate_pro = size(satisfy_pro, 1); %判断可以分配的项目数，如5个项目里只有3个可以被分配，就无需往下变换邻域了
                                order_rand = randperm(allocate_pro); %随机序列21543
                                s1 = satisfy_pro(order_rand, :);
                                S1 = conbine_cell_to_row(s1);
                                [S_obj, results, Real_Available_skill_cates, temp_Lgs_s, temp_d2, later_start_times, later_end_times, temp_RN_s, later_local_duration, finally_total_duration] = find_obj(allocate_source_rules, S1, time, ad, delay, CPM(num, :), r, temp_R, forestset, skill_cate, GlobalSourceRequest, iter_Lgs, iter_skill_num, iter_d, iter_d2, iter_local_start_times, iter_local_end_times, iter_RN);
                                %S_obj 初始项目顺序对应的初始解与main有关
                                i_pro = 1; %第一个位置的项目
                                count = 0; %便于记录循环几次可以得出代替初始解的解
                                if size(satisfy_pro, 1) == 1
                                    satisfy_delay = S_obj;
                                else
                                    % 交换顺序
                                    while i_pro < allocate_pro
                                        count = count + 1;
                                        a = order_rand(1, i_pro); %a = 1
                                        order_rand(1, i_pro) = order_rand(1, i_pro + 1); %b = 2
                                        order_rand(1, i_pro + 1) = a; %iter_S1 = [2 1 3],Note:所找到的解都是L4/L5解空间里的解，新的顺序
                                        s1 = satisfy_pro(order_rand, :);
                                        S1 = conbine_cell_to_row(s1); %合并为一行
                                        % 求解 S_cur
                                        [S_cur, results11, Real_Available_skill_cates11, temp_Lgs_s11, temp_d211, later_start_times11, later_end_times11, temp_RN_s11, later_local_duration11, finally_total_duration11] = find_obj(allocate_source_rules, S1, time, ad, delay, CPM(num, :), r, temp_R, forestset, skill_cate, GlobalSourceRequest, iter_Lgs, iter_skill_num, iter_d, iter_d2, iter_local_start_times, iter_local_end_times, iter_RN);
                                        
                                        if S_cur >= S_obj %若新解比初始解大，则继续下一个邻域搜索
                                            i_pro = i_pro + 1;
                                        else %否，令当前解代替初始解，作为新的初始解
                                            i_pro = 1; %并返回位置为1的邻域搜索
                                            S_obj = S_cur; %更新obj
                                            [results, Real_Available_skill_cates, temp_Lgs_s, temp_d2, later_start_times, later_end_times, temp_RN_s, later_local_duration, finally_total_duration] = repeat(results11, Real_Available_skill_cates11, temp_Lgs_s11, temp_d211, later_start_times11, later_end_times11, temp_RN_s11, later_local_duration11, finally_total_duration11);
                                            %保存当前时刻分配的活动，分配的活动有哪些，未分配的活动有哪些
                                        end
                                    end
                                    satisfy_delay = S_obj; %break跳到这里
                                end
                                all_total_delay = satisfy_delay;
                                
                            elseif ~isempty(iter_not) || ~isempty( satisfy_pro{1})
                                if ~isempty(iter_not)
                                    % iter not
                                    [later_start_times, later_end_times] = find_act_not(iter_not, time, r, temp_R, iter_d, forestset, iter_local_start_times, iter_local_end_times);
                                    chosen_results{time} = [];    
                                    temp_Lgs_s = iter_Lgs;
                                    Real_Available_skill_cates = iter_skill_num;
                                    temp_d2 = iter_d;
                                    temp_RN_s = iter_RN;
                                    finally_duration = max(max(later_end_times));
                                    
                                    iter_not_delay = delay*(later_end_times(:,num_j) - ad'-CPM(num,:)');
                                    all_total_delay = iter_not_delay;
                                else
                                    % statisfy
                                    allocate_pro = size(satisfy_pro, 1); %判断可以分配的项目数，如5个项目里只有3个可以被分配，就无需往下变换邻域了
                                    order_rand = randperm(allocate_pro); %随机序列21543
                                    s1 = satisfy_pro(order_rand, :);
                                    S1 = conbine_cell_to_row(s1);
                                    [S_obj, results, Real_Available_skill_cates, temp_Lgs_s, temp_d2, later_start_times, later_end_times, temp_RN_s, later_local_duration, finally_total_duration] = find_obj(allocate_source_rules, S1, time, ad, delay, CPM(num, :), r, temp_R, forestset, skill_cate, GlobalSourceRequest, iter_Lgs, iter_skill_num, iter_d, iter_d2, iter_local_start_times, iter_local_end_times, iter_RN);
                                    %S_obj 初始项目顺序对应的初始解与main有关
                                    i_pro = 1; %第一个位置的项目
                                    count = 0; %便于记录循环几次可以得出代替初始解的解
                                    
                                    if size(satisfy_pro, 1) == 1
                                        satisfy_delay = S_obj;
                                    else
                                        % 交换顺序
                                        while i_pro < allocate_pro
                                            count = count + 1;
                                            a = order_rand(1, i_pro); %a = 1
                                            order_rand(1, i_pro) = order_rand(1, i_pro + 1); %b = 2
                                            order_rand(1, i_pro + 1) = a; %iter_S1 = [2 1 3],Note:所找到的解都是L4/L5解空间里的解，新的顺序
                                            s1 = satisfy_pro(order_rand, :);
                                            S1 = conbine_cell_to_row(s1); %合并为一行
                                            % 求解 S_cur
                                            [S_cur, results11, Real_Available_skill_cates11, temp_Lgs_s11, temp_d211, later_start_times11, later_end_times11, temp_RN_s11, later_local_duration11, finally_total_duration11] = find_obj(allocate_source_rules, S1, time, ad, delay, CPM(num, :), r, temp_R, forestset, skill_cate, GlobalSourceRequest, iter_Lgs, iter_skill_num, iter_d, iter_d2, iter_local_start_times, iter_local_end_times, iter_RN);
                                            
                                            if S_cur >= S_obj %若新解比初始解大，则继续下一个邻域搜索
                                                i_pro = i_pro + 1;
                                            else %否，令当前解代替初始解，作为新的初始解
                                                i_pro = 1; %并返回位置为1的邻域搜索
                                                S_obj = S_cur; %更新obj
                                                [results, Real_Available_skill_cates, temp_Lgs_s, temp_d2, later_start_times, later_end_times, temp_RN_s, later_local_duration, finally_total_duration] = repeat(results11, Real_Available_skill_cates11, temp_Lgs_s11, temp_d211, later_start_times11, later_end_times11, temp_RN_s11, later_local_duration11, finally_total_duration11);
                                                %保存当前时刻分配的活动，分配的活动有哪些，未分配的活动有哪些
                                            end
                                        end
                                        satisfy_delay = S_obj; %break跳到这里
                                    end
                                    all_total_delay = satisfy_delay;
                                end   
                            end
                            %% 若两种一样的目标值，可任选一个结果，但是后续的更新，需要根据所选择的项目顺序决定，因为可能项目1分配了，而后续未更新过来
                            %如项目1，1-2，1-3都分配了，但是2-3没有，所以技能可用量为1，
                            %所以后续的更新需要对应调整
                            %如果satify有项目，更新下列数据；
                            %如果satify内没有项目，则依靠iter_not内已经更新好的继续进行，
                            pos = 1;
                            iter_Lgs = temp_Lgs_s(skill_count * (pos - 1) + 1:skill_count * pos, :); %选择的最优顺序的资源技能值矩阵
                            iter_skill_num = Real_Available_skill_cates(pos, :); %选择的最优顺序的技能可用量
                            % iter_R                  = temp_Rs(:,:,:,pos);
                            % % 局部资源
                            iter_d = temp_d2; % 选择好最优顺序的实际工期
                            iter_local_start_times = later_start_times(L * (pos - 1) + 1:L * pos, :); %选择的最优顺序的开始时间
                            iter_local_end_times = later_end_times(L * (pos - 1) + 1:L * pos, :); %选择的最优顺序的结束时间
                            iter_RN = temp_RN_s(pos, :);
                            Best_duration = later_local_duration(pos, :); % 最好的工期
                            finally_duration = max(Best_duration);
                            %  if ~isempty(results)
                            chosen_result = results{pos};
                            chosen_results{time} = chosen_result;
                        end
                        %% 判断已用的全局资源下一时刻是否会释放
                        [allocated_set, iter_Lgs, iter_skill_num] = Release(time, chosen_results, allocated_set, Lgs, iter_Lgs, iter_skill_num);
                        if length(allocated_set) == length(L1) && max(max(iter_local_start_times)) <= time
                            break
                        end
                    end
                    Real_EveryTime_GS_n = [];
                    %% save
                    [average_delay_duration] = find_average_delay(CPM(num, :), finally_total_duration, ad, L, delay); %输出平均项目延期、总延期成本
                    TTC = [TTC; all_total_delay];
                    APD= [APD;average_delay_duration];
                    TMS = [TMS; finally_duration];
                    
                    seq = seq + 1;
                    
                    result_save = {people, original_skill_num, UF, CPM, original_total_duration, finally_total_duration, average_delay_duration, finally_duration, all_total_delay, ad, delay, time};
                    result_saves_file(seq, :) = result_save; %储存每个算例运行多次的信息
                end
            end
        end
        toc
        % result_save       [1, 12] result_save_sims  [50,12] TTC
        % [50, 1]
        save_ETTC = roundn ((sum(TTC)) / (file * cycle * Simul_Num), -2); %50次运行的均值
        save_EAPD = roundn ((sum(APD)) / (file * cycle * Simul_Num), -2); %50次运行的均值
        save_ETMS = roundn ((sum(TMS)) / (file * cycle * Simul_Num), -2); %50次运行的均值
        
        summary_info = cell(1, 12);
        summary_info{1}= num2str(save_EAPD);
        summary_info{2} = num2str(save_ETMS);
        summary_info{3} = num2str(save_ETTC);
        
        summary_info{4} = toc / (Simul_Num * cycles * 5);
        summary_info{5} = num2str(L);
        summary_info{6} = num2str(num_j - 2);
        summary_info{7} = normalization;
        summary_info{8} = activity_rules;
        summary_info{9} = allocate_source_rules;
        
        result_saves_file = [result_saves_file; summary_info];
        save(strcat(folder, '\', num2str(L), '_', num2str(num_j - 2), '_', normalization, '_', activity_rules, '_', allocate_source_rules, '.mat'), 'result_saves_file');
        sprintf('保存文件')
        
        % summary_info_save
        summary_info_save(3 * (outer_i - 1) + outer_j, :) = summary_info;
    end
end
end
