function [one_row_cell] = conbine_cell_to_row(multi_rows_cell)
%conbine_cell_to_row �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

one_row_cell = cell(1,size(multi_rows_cell,1)*length(multi_rows_cell));
for hang_x = 1:size(multi_rows_cell,1)
    one_row_cell(1,(hang_x-1)*length(multi_rows_cell)+1:hang_x*length(multi_rows_cell)) = multi_rows_cell(hang_x,:);
end
end

