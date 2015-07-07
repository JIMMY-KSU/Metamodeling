clear all; close all; clc;

global max1 min1 max2 min2

%Which analytical function to use?
analyt = 4;
%Function parameters (1=Re and 2=Ma)
name1 = 'Y';     name2 = 'T';
max1  = 1;       max2  = 1;
min1  = 0;       min2  = 0;
%Number of points to be interpolated in postprocessing
test_pts = 100;
%Number of dimensions
d = 2;
%Max polynomial order
k = 9;
%Error plot on (1) or off (2)
err_plt = 1;

% Test the algorithm
for q = d+7:d+7
    [num_pts(q-1) pts] = Colloc_Pts(q);
    err(q-1,1) = num_pts(q-1);
    tic
    
    if analyt == 6 %Special case for Zabaras Eq. 81
        exact    = Zabaras81Exact(test_pts);
        smol_ans = Zabaras81Smol(pts);
    end
    
%   Build the test space
    for i = 1:test_pts
        for j = 1:test_pts
            y(1) = -1 + 2*(i-1)/(test_pts-1);
            y(2) = -1 + 2*(j-1)/(test_pts-1);
            if analyt == 6 %Special case for Zabaras Eq. 81
                smol(i,j)  = Smol_soln_Zabaras(q, d, y, smol_ans);
            else
                exact(i,j) = analyt_func(y(1), y(2), 3);
                smol(i,j)  = Smolyak_func(q, d, y, analyt);
            end
        end
    end
    toc
    
    [err_loc err(q-1,2) err(q-1,3) err(q-1,4)] = error_analysis(smol, exact);
%     if q>d+1 && err_plt
%         error_plots(err(:,1), err(:,2), err(:,3), err(:,3), q)
%     end
%     
%     save(['Dat_Sets/Eqn_Num_' int2str(analyt) '/Order_' int2str(q-2)]);
% 
%     local_error_plot(test_pts, err_loc, max1, min1, max2, min2)
%     
%     Results_plot(test_pts, exact, smol, max1, min1, max2, min2)
figure(1)
mesh(((-1:2/(test_pts-1):1)+1)./2.*(max2-min2)+min2,...
    ((-1:2/(test_pts-1):1)+1)./2.*(max1-min1)+min1, smol');
xlabel(name1), ylabel(name2)
zlabel('Z (SC)')
axis([min2 max2 min1 max1 min(min(exact)) max(max(exact+1))])
title('Reconstructed Hypersurface (SC)')
colorbar

h = gcf;
print(h, '-dpdf',...
    ['Dat_Sets/Eqn_Num_' int2str(analyt) '/3D_Interp_mantle_Func_' int2str(analyt)]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(2)
contourf(((-1:2/(test_pts-1):1)+1)./2.*(max2-min2)+min2,...
    ((-1:2/(test_pts-1):1)+1)./2.*(max1-min1)+min1, smol')
xlabel(name1), ylabel(name2)
zlabel('Z (SC)')
title('Contour of the Reconstructed Hypersurface (SC)')
colorbar

h = gcf;
print(h, '-dpdf',...
    ['Dat_Sets/Eqn_Num_' int2str(analyt) '/Contour_Interp_mantle_Func_' int2str(analyt)]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(3)
surf(((-1:2/(test_pts-1):1)+1)/2*(max2-min2)+min2,...
     ((-1:2/(test_pts-1):1)+1)/2*(max1-min1)+min1, err_loc');
xlabel(name1), ylabel(name2)
zlabel('Local Error Distribution (SC)')
title('Local Error Distribution (SC)')
colorbar

h = gcf;
print(h, '-dpdf',...
    ['Dat_Sets/Eqn_Num_' int2str(analyt) '/3D_Loc_Err_Func_' int2str(analyt)]);

figure(4)
contourf(((-1:2/(test_pts-1):1)+1)/2*(max2-min2)+min2,...
         ((-1:2/(test_pts-1):1)+1)/2*(max1-min1)+min1, err_loc')
xlabel(name1), ylabel(name2)
title(['Contour of the Local Error Distribution (SC)'])
colorbar

h = gcf;
print(h, '-dpdf',...
    ['Dat_Sets/Eqn_Num_' int2str(analyt) '/Contour_Loc_Err_Func_' int2str(analyt)]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(6)
subplot(2,2,1)
meshc(((-1:2/(test_pts-1):1)+1)./2.*(max2-min2)+min2,...
    ((-1:2/(test_pts-1):1)+1)./2.*(max1-min1)+min1, exact');
xlabel(name1), ylabel(name2)
zlabel('Z (exact)')
axis([min2 max2 min1 max1 min(min(exact)) max(max(exact+1))])
colorbar

subplot(2,2,2)
contourf(((-1:2/(test_pts-1):1)+1)./2.*(max2-min2)+min2,...
    ((-1:2/(test_pts-1):1)+1)./2.*(max1-min1)+min1, exact')
xlabel(name1), ylabel(name2)
title(['Contour of the Reconstructed Hypersurface (exact)'])
colorbar

subplot(2,2,3)
meshc(((-1:2/(test_pts-1):1)+1)./2.*(max2-min2)+min2,...
    ((-1:2/(test_pts-1):1)+1)./2.*(max1-min1)+min1, smol');
xlabel(name1), ylabel(name2)
zlabel('Z (SC)')
axis([min2 max2 min1 max1 min(min(exact)) max(max(exact+1))])
colorbar

subplot(2,2,4)
contourf(((-1:2/(test_pts-1):1)+1)./2.*(max2-min2)+min2,...
    ((-1:2/(test_pts-1):1)+1)./2.*(max1-min1)+min1, smol')
xlabel(name1), ylabel(name2)
title(['Contour of the Reconstructed Hypersurface (SC)'])
colorbar

h = gcf;
print(h, '-dpdf',...
    ['Dat_Sets/Eqn_Num_' int2str(analyt) '/Comparison_Func_' int2str(analyt)]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
