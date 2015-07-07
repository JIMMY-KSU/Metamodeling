clear all; close all; clc;
%Function parameters
name1 = 'X';     name2 = 'Y';
max1  =  1 ;     max2  =  1 ;
min1  =  0 ;     min2  =  0 ;
range = [min1 max1; min2 max2];
% Function
f = @(x,y) 1/(abs(0.3-x^2-y^2)+0.1);
%Number of points to be interpolated in postprocessing
test_pts = 100;
%Number of dimensions
d = 2;
%Max polynomial order
k = 5;
%Which function to evaluate
analyt = 1;
% minimum relative tolerance
reltol = 1e-3;
% minimum absolute tolerance
abstol = 1e-8;
err = zeros(k+1,5);

% Test the algorithm
n = 1;
for i = 1:test_pts
    for j = 1:test_pts
        x1(1,n)        = range(1,1) + (i-1)*(range(1,2)-range(1,1))/(test_pts-1);
        x2(1,n)        = range(2,1) + (j-1)*(range(2,2)-range(2,1))/(test_pts-1);
        vec_exact(1,n) = analyt_func(x1(1,n), x2(1,n), 1);
        n = n+1;
    end
end
% Determine the mantle with different max levels
for q = d+k:d+k
% find the Clenshaw-Curtis nodes and their corresponding function values
z        = Smolyak_func(q, d, f, range, reltol, abstol);
vec_smol = SC_Interp(d, z.z, range, x1, x2);

err(q-1,5) = z.accuracy;

err(q-1,1) = z.npoints;
tic

n = 1;
for i = 1:test_pts
    for j = 1:test_pts
        smol(i,j)  = vec_smol(1,n);
        exact(i,j) = vec_exact(1,n);
        n = n+1;
    end
end

[err_loc err(q-1,2) err(q-1,3) err(q-1,4)] = error_analysis(smol, exact);

% save(['Dat_Sets/Eqn_Num_' int2str(analyt) '/Order_' int2str(q-2)]);
if q == 7
    figure(1)
    mesh(range(1,1):(range(1,2)-range(1,1))/(test_pts-1):range(1,2),...
         range(2,1):(range(2,2)-range(2,1))/(test_pts-1):range(2,2), smol');
    xlabel(name1), ylabel(name2)
    zlabel('Z (SC)')
    axis([min1 max1 min2 max2 min(min(exact)) max(max(exact+1))])
    title('Reconstructed Hypersurface (SC)')
    colorbar
    
    h = gcf;
    print(h, '-dpdf',...
        ['Dat_Sets/Eqn_Num_' int2str(analyt) '/3D_Interp_mantle_Func_' int2str(analyt)]);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    figure(2)
    contourf(range(1,1):(range(1,2)-range(1,1))/(test_pts-1):range(1,2),...
             range(2,1):(range(2,2)-range(2,1))/(test_pts-1):range(2,2), smol')
    xlabel(name1), ylabel(name2)
    zlabel('Z (SC)')
    title('Contour of the Reconstructed Hypersurface (SC)')
    colorbar
    
    h = gcf;
    print(h, '-dpdf',...
        ['Dat_Sets/Eqn_Num_' int2str(analyt) '/Contour_Interp_mantle_Func_' int2str(analyt)]);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    figure(3)
    surf(range(1,1):(range(1,2)-range(1,1))/(test_pts-1):range(1,2),...
         range(2,1):(range(2,2)-range(2,1))/(test_pts-1):range(2,2), log(err_loc'+eps));
    xlabel(name1), ylabel(name2)
    zlabel('Local Error Distribution (SC)')
    title('Local Error Distribution (SC)')
    colorbar
    
    h = gcf;
    print(h, '-dpdf',...
        ['Dat_Sets/Eqn_Num_' int2str(analyt) '/3D_Loc_Err_Func_' int2str(analyt)]);
    
    figure(4)
    contourf(range(1,1):(range(1,2)-range(1,1))/(test_pts-1):range(1,2),...
             range(2,1):(range(2,2)-range(2,1))/(test_pts-1):range(2,2), log(err_loc'+eps))
    xlabel(name1), ylabel(name2)
    title(['Contour of the Local Error Distribution (SC)'])
    colorbar
    
    h = gcf;
    print(h, '-dpdf',...
        ['Dat_Sets/Eqn_Num_' int2str(analyt) '/Contour_Loc_Err_Func_' int2str(analyt)]);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    figure(6)
    subplot(2,2,1)
    meshc(range(1,1):(range(1,2)-range(1,1))/(test_pts-1):range(1,2),...
         range(2,1):(range(2,2)-range(2,1))/(test_pts-1):range(2,2), exact');
    xlabel(name1), ylabel(name2)
    zlabel('Z (exact)')
    axis([min1 max1 min2 max2 min(min(exact)) max(max(exact+1))])
    colorbar
    
    subplot(2,2,2)
    contourf(range(1,1):(range(1,2)-range(1,1))/(test_pts-1):range(1,2),...
             range(2,1):(range(2,2)-range(2,1))/(test_pts-1):range(2,2), exact')
    xlabel(name1), ylabel(name2)
    title(['Contour of the Reconstructed Hypersurface (exact)'])
    colorbar
    
    subplot(2,2,3)
    meshc(range(1,1):(range(1,2)-range(1,1))/(test_pts-1):range(1,2),...
          range(2,1):(range(2,2)-range(2,1))/(test_pts-1):range(2,2), smol');
    xlabel(name1), ylabel(name2)
    zlabel('Z (SC)')
    axis([min1 max1 min2 max2 min(min(exact)) max(max(exact+1))])
    colorbar
    
    subplot(2,2,4)
    contourf(range(1,1):(range(1,2)-range(1,1))/(test_pts-1):range(1,2),...
             range(2,1):(range(2,2)-range(2,1))/(test_pts-1):range(2,2), smol')
    xlabel(name1), ylabel(name2)
    title(['Contour of the Reconstructed Hypersurface (SC)'])
    colorbar
    
    h = gcf;
    print(h, '-dpdf',...
        ['Dat_Sets/Eqn_Num_' int2str(analyt) '/Comparison_Func_' int2str(analyt)]);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
end