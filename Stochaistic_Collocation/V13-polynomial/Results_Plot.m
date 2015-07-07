clear all; close all; clc

%Function number
func = 7;
%Maximum local error
error = 0;
%Turn titles on/off
title_onoff = 0;
%Font size
fontsize = 24;
for func = 1:7
%Axis labels
if func < 5
    name1 = 'X' ; name2 = 'Y' ; name3 = 'Z';
elseif func < 7
    name1 = 'Ma'; name2 = 'Re'; name3 = 'C_D';
else
    name1 = '\alpha'; name2 = 'Re'; name3 = 'C_D';
end
a = func;
load(['Output/func_' int2str(func) '_err_' num2str(error) '.mat'])
func = a
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure3 = figure(3);
surf(range(2,1):(range(2,2)-range(2,1))/(num_test_pts(2)-1):range(2,2),...
     range(1,1):(range(1,2)-range(1,1))/(num_test_pts(1)-1):range(1,2),...
     Z)
set(gca, 'FontSize', fontsize);
if title_onoff
    title('Approximated Hypersurface')
    set(gca, 'FontSize', fontsize);
end
set(gca, 'FontSize', fontsize);
xlabel(name1), ylabel(name2), zlabel(name3)
set(gca, 'FontSize', fontsize);

set(gca,'units','centimeters')
pos = get(gca,'Position');
% ti = get(gca,'LooseInset');
ti = [2.5,1.2,5,3];

set(gcf, 'PaperUnits','centimeters');
set(gcf, 'PaperSize', [pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition',[0 0 pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)]);

saveas(figure3,['Plots/Function_' int2str(func) '_Adaptive_e_'...
    num2str(error*1000) 'figure3.pdf'],'pdf')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure4 = figure(4);
contourf(range(2,1):(range(2,2)-range(2,1))/(num_test_pts(2)-1):range(2,2),...
     range(1,1):(range(1,2)-range(1,1))/(num_test_pts(1)-1):range(1,2),...
     Z)
set(gca, 'FontSize', fontsize);
if title_onoff
    title('Contour of Approximated Hypersurface')
    set(gca, 'FontSize', fontsize);
end
xlabel(name1), ylabel(name2)
set(gca, 'FontSize', fontsize);
h = colorbar;
% title(h, name3, 'FontSize', fontsize);
set(gca, 'FontSize', fontsize);

ti = get(gca,'LooseInset');
ti = [0.13,0.11,0.187930316334572,0.075];
set(gca,'Position',[.19 .16 .6 .75]);

set(gca,'units','centimeters')
pos = get(gca,'Position');
% ti = get(gca,'LooseInset');
ti = [2.5,1.2,5,3];

set(gcf, 'PaperUnits','centimeters');
set(gcf, 'PaperSize', [pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition',[0 0 pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)]);

saveas(figure4,['Plots/Function_' int2str(func) '_Adaptive_e_'...
    num2str(error*1000) 'figure4.pdf'],'pdf')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure5 = figure(5);
contourf(range(2,1):(range(2,2)-range(2,1))/(num_test_pts(2)-1):range(2,2),...
     range(1,1):(range(1,2)-range(1,1))/(num_test_pts(1)-1):range(1,2),...
     err_loc*abs(sum(sum(exact))/(num_test_pts(1))^2)./exact)
set(gca, 'FontSize', fontsize);
if title_onoff
    title('Contour of the Local Error')
    set(gca, 'FontSize', fontsize);
end
xlabel(name1), ylabel(name2)
set(gca, 'FontSize', fontsize);
h = colorbar;
% title(h, name3, 'FontSize', fontsize);
set(gca, 'FontSize', fontsize);

ti = get(gca,'LooseInset');
ti = [0.13,0.11,0.187930316334572,0.075];
set(gca,'Position',[.19 .16 .6 .75]);

set(gca,'units','centimeters')
pos = get(gca,'Position');
% ti = get(gca,'LooseInset');
ti = [2.5,1.2,5,3];

set(gcf, 'PaperUnits','centimeters');
set(gcf, 'PaperSize', [pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition',[0 0 pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)]);

saveas(figure5,['Plots/Function_' int2str(func) '_Adaptive_e_'...
    num2str(error*1000) 'figure5.pdf'],'pdf')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
save('reset.mat', 'func', 'error', 'fontsize', 'title_onoff')
clear all; close all
load('reset.mat')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end