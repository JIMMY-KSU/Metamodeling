clear all; close all; clc;
%Function parameters
name1 = 'X';     name2 = 'Y';
max1  =  1 ;     max2  =  1 ;
min1  =  0 ;     min2  =  0 ;
range = [min1 max1; min2 max2];
% Function
% f = @(x,y) 1/(abs(0.3-x^2-y^2)+0.1);
f = @(x,y) x^2+y^4;
%Number of points to be interpolated in postprocessing
test_pts = 100;
%Number of dimensions
d = 2;
%Max polynomial order
max_level = 3;
%Minimum number of levels before adaptivity
min_level = 2;
%Which function to evaluate
analyt = 1;
% minimum relative tolerance
reltol = 1e-3;
% minimum absolute tolerance
abstol = 1e-8;
%Adaptive error tolerance
adapterr = 0.0;
err = zeros(max_level+1,5);

% Test the algorithm
n = 1;
for r = 1:test_pts
    for j = 1:test_pts
        x_test(1,n) = range(1,1) + (r-1)*(range(1,2)-range(1,1))/(test_pts-1);
        x_test(2,n) = range(2,1) + (j-1)*(range(2,2)-range(2,1))/(test_pts-1);
        n = n+1;
    end
end
% Compute exact function values on the test points
vec_exact = compute_z(f, x_test')';
% Ensure the first two levels are computed
% compute the interpolated values at the testing points
for j = 0:min_level
    i{j+1} = compute_i(d,j);
    x{j+1} = grid_pts(i{j+1});
    x{j+1} = unique(x{j+1},'rows');
end
w{1} = compute_w(f, range, x{1});
y    = x;
for j = 1:min_level
%     z = Adaptive_Smolyak_func(d+j,d,f,range,reltol,abstol,x);
    % calculate the initial heirarchical surpluses for min_level
    w{j+1} = compute_w(f, range, y{j+1});
    w{j+1} = w{j+1} - SC_Interp3(d, w, range, x, y{j+1}(:,1), y{j+1}(:,2));
end
    
for k = min_level+1:max_level
    q = d+k;
    %Find heirarchical surpluses at current level
    w{k} = compute_w(f, range, x{k}) -...
        SC_Interp2(d, w, range, x, x{k}(:,1), x{k}(:,2));
    %Determine points to refine around
    temp   = [];
    for r = 1:length(y{k})
        if abs(w{k}(r)) >= adapterr
            temp = [temp; y{k}(r,:)];
        end
    end
    %If done refining, break
    if isempty(temp)
        break;
    end
    %Find all possible nodes at next level
    i{k+1} = compute_i(d,k);
    x{k+1} = grid_pts(i{k+1});
    x{k+1} = unique(x{k+1},'rows');

    %Refine around nodes with high surplus
    y{k+1} = [];
    for r = 1:length(temp(:,1))
        for l = 1:d
            temp1(1,:) = [10 10];
            temp1(2,:) = [10 10];
            for l2 = [1:l-1 l+1:d]
                for s = 1:length(x{k+1})
                    if temp(r,l) == x{k+1}(s,l)
                        if abs(temp(r,l2) - x{k+1}(s,l2)) < abs(temp(r,l2) - temp1(1,l2))
                            temp1(1,:) = x{k+1}(s,:);
                        end
                        if abs(temp(r,l2) - x{k+1}(s,l2)) <= abs(temp(r,l2) - temp1(2,l2))
                            temp1(2,:) = x{k+1}(s,:);
                        end
                    end
                end
                y{k+1} = [y{k+1}; temp1];
            end
        end
    end
    y{k+1} = unique(y{k+1}, 'rows');
end

figure(1)
num_pts = 0;
for j = 1:length(y)
    plot(y{j}(:,1), y{j}(:,2), '.'), hold on
    num_pts = num_pts + size(y{j}(:,1),1);
end

vec_smol = SC_Interp2(d, w, range, x, x_test(1,:), x_test(2,:));
n = 1;
for p = 1:test_pts
    for j = 1:test_pts
        smol(p,j)  = vec_smol(1,n);
        exact(p,j) = vec_exact(1,n);
        n = n+1;
    end
end
if 1
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
end
% save(['Dat_Sets/Eqn_Num_' int2str(analyt) '/Order_' int2str(q-2)]);
if q == 12
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