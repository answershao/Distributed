function [average_delay_duration, total_delay] = find_average_delay(CPM,finally_tocal_duration,ad,L,delay)
delay_duration = [];
delay_duration_s = [];
for i =1:L
    delay_duration(i) = finally_tocal_duration(i)' - ad(i) - CPM(i);
    delay_duration_s  = [delay_duration_s ;delay_duration(i)];
end

total_delay = delay*delay_duration_s;
average_delay_duration =ceil(sum(delay_duration_s)/L);
% 