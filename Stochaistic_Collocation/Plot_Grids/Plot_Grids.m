clear all; close all;
for j = 0:5
    i{j+1} = compute_i(2,j);
    x{j+1} = unique(grid_pts(i{j+1}),'rows');
%     if j > 0
%         x{j+1} = unique([x{j};x{j+1}],'rows');
%     end
end
figure(1)
plot(x{6}(:,1),x{6}(:,2),'.','MarkerSize',30)
set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', []);
set(gca, 'YTickLabelMode', 'manual', 'YTickLabel', []);
figure(2)
[num C] = Colloc_Pts(7);
plot(C(:,1),C(:,2),'.','MarkerSize',30)
set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', []);
set(gca, 'YTickLabelMode', 'manual', 'YTickLabel', []);
figure(3)
C = Tensor_Pts(2,5);
plot(C(:,1),C(:,2),'.','MarkerSize',30)
set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', []);
set(gca, 'YTickLabelMode', 'manual', 'YTickLabel', []);

for i = 1:size(x,2)
    figure(i+3)
    plot(x{i}(:,1),x{i}(:,2),'.','MarkerSize',30)
    set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', []);
    set(gca, 'YTickLabelMode', 'manual', 'YTickLabel', []);
end
