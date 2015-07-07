clear all; close all; clc;
%Function parameters
name1 = 'X';     name2 = 'Y';
max1  =  1 ;     max2  =  10;
min1  =  0 ;     min2  =  0 ;
range = [min1 max1; min2 max2];
% Function
f = @(x,y) 1/(abs(0.3-x^2-y^2)+0.1);
f = @(x,y) x+y;
%Number of points to be interpolated in postprocessing
test_pts = 100;
%Number of dimensions
d = 2;
%Max polynomial order
k = 9;
%Which function to evaluate
analyt = 1;
% minimum relative tolerance
reltol = 1e-3;
% minimum absolute tolerance
abstol = 1e-8;

err_mine = zeros(k, 4);
% Test the algorithm
n = 1;
for i = 1:test_pts
    for j = 1:test_pts
        vec_x1(1,n)    = range(1,1) + (i-1)*(range(1,2)-range(1,1))/(test_pts-1);
        vec_x2(1,n)    = range(2,1) + (j-1)*(range(2,2)-range(2,1))/(test_pts-1);
        vec_exact(1,n) = analyt_func(vec_x1(1,n), vec_x2(1,n), 1);
        n = n+1;
    end
end
% Determine the mantle with different max levels
for q = 3:3
% find the Clenshaw-Curtis nodes and their corresponding function values
options  = spset('MaxDepth', q-d);
z        = spvals(f, d, range, options);
vec_smol = spinterp(z, vec_x1, vec_x2);

err_mine(q-1,1) = z.nPoints;
tic


n = 1;
for i = 1:test_pts
    for j = 1:test_pts
        smol(i,j)  = vec_smol(1,n);
        exact(i,j) = vec_exact(1,n);
        x1(i,j)    = vec_x1(1,n);
        x2(i,j)    = vec_x2(1,n);
        n = n+1;
    end
end

[err_loc err_mine(q-1,2) err_mine(q-1,3) err_mine(q-1,4)] = error_analysis(smol, exact);

% save(['Dat_Sets/Eqn_Num_' int2str(analyt) '/Order_' int2str(q-2)]);
if q == 9
    figure(1)
    mesh(range(1,1):(range(1,2)-range(1,1))/(test_pts-1):range(1,2),...
         range(2,1):(range(2,2)-range(2,1))/(test_pts-1):range(2,2), smol);
    xlabel(name1), ylabel(name2)
    zlabel('Z (SC)')
%     axis([min2 max2 min1 max1 min(min(exact)) max(max(exact+1))])
    title('Reconstructed Hypersurface (SC)')
    colorbar
    
    h = gcf;
    print(h, '-dpdf',...
        ['Dat_Sets/Eqn_Num_' int2str(analyt) '/3D_Interp_mantle_Func_' int2str(analyt)]);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    figure(2)
    contourf(((-1:2/(test_pts-1):1)+1)./2.*(max2-min2)+min2,...
        ((-1:2/(test_pts-1):1)+1)./2.*(max1-min1)+min1, smol)
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
        ((-1:2/(test_pts-1):1)+1)/2*(max1-min1)+min1, log(err_loc));
    xlabel(name1), ylabel(name2)
    zlabel('Local Error Distribution (SC)')
    title('Local Error Distribution (SC)')
    colorbar
    
    h = gcf;
    print(h, '-dpdf',...
        ['Dat_Sets/Eqn_Num_' int2str(analyt) '/3D_Loc_Err_Func_' int2str(analyt)]);
    
    figure(4)
    contourf(((-1:2/(test_pts-1):1)+1)/2*(max2-min2)+min2,...
        ((-1:2/(test_pts-1):1)+1)/2*(max1-min1)+min1, log(err_loc))
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
        ((-1:2/(test_pts-1):1)+1)./2.*(max1-min1)+min1, exact);
    xlabel(name1), ylabel(name2)
    zlabel('Z (exact)')
    axis([min2 max2 min1 max1 min(min(exact)) max(max(exact+1))])
    colorbar
    
    subplot(2,2,2)
    contourf(((-1:2/(test_pts-1):1)+1)./2.*(max2-min2)+min2,...
        ((-1:2/(test_pts-1):1)+1)./2.*(max1-min1)+min1, exact)
    xlabel(name1), ylabel(name2)
    title(['Contour of the Reconstructed Hypersurface (exact)'])
    colorbar
    
    subplot(2,2,3)
    meshc(((-1:2/(test_pts-1):1)+1)./2.*(max2-min2)+min2,...
        ((-1:2/(test_pts-1):1)+1)./2.*(max1-min1)+min1, smol);
    xlabel(name1), ylabel(name2)
    zlabel('Z (SC)')
    axis([min2 max2 min1 max1 min(min(exact)) max(max(exact+1))])
    colorbar
    
    subplot(2,2,4)
    contourf(((-1:2/(test_pts-1):1)+1)./2.*(max2-min2)+min2,...
        ((-1:2/(test_pts-1):1)+1)./2.*(max1-min1)+min1, smol)
    xlabel(name1), ylabel(name2)
    title(['Contour of the Reconstructed Hypersurface (SC)'])
    colorbar
    
    h = gcf;
    print(h, '-dpdf',...
        ['Dat_Sets/Eqn_Num_' int2str(analyt) '/Comparison_Func_' int2str(analyt)]);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
end