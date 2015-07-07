clc; close all;

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