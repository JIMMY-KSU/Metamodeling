clear all; close all; clc;
%Function parameters
max1  =  1 ;     max2  =  1 ;
min1  =  0 ;     min2  =  0 ;
range = [min1 max1; min2 max2];
% Function
f = @(x) exp(-(x-0.4).^2./0.0625^2);
%Number of points to be interpolated in postprocessing
test_pts = 100;
%Number of dimensions
d = 1;
%Max polynomial order
max_level = 5;
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
    x_test(1,n) = range(1,1) + (r-1)*(range(1,2)-range(1,1))/(test_pts-1);
    n = n+1;
end
% Compute exact function values on the test points
vec_exact = compute_z(f, x_test')';
% Ensure the first two levels are computed
% compute the interpolated values at the testing points
for j = 0:min_level
    i{j+1} = compute_i(d,j);
    x{j+1} = grid_pts(i{j+1});
    if j>0
        x{j+1} = unique([x{j+1}; x{j}],'rows');
    end
end
w{1} = compute_w(f, range, x{1});
y    = x;
% calculate the initial heirarchical surpluses for min_level
for j = 1:min_level
    w{j+1} = compute_w(f, range, y{j+1})-SC_Interp3(d, w, range, x, y{j+1}(:,1));
end

for k = min_level+1:max_level
    q = d+k;
    %Find heirarchical surpluses at current level
    w{k} = compute_w(f, range, y{k}) -...
        SC_Interp3(d, w, range, y, y{k}(:,1));
    %Determine points to refine around
    temp   = [];
    for r = 1:length(y{k})
        if abs(w{k}(r)) >= adapterr
            temp = [temp; y{k}(r,:)];
        end
    end
    %If done refining, break
    if isempty(temp)
        fprintf(['The error estimate of ', ...
                    ' is below the required tolerance of ', ...
                    ', so the program exited at ',...
                    int2str(k), ' levels.\n']);
        break;
    end
    %Find all possible nodes at next level
    i{k+1} = compute_i(d,k);
    x{k+1} = grid_pts(i{k+1});
    x{k+1} = unique(x{k+1},'rows');

    %Refine around nodes with high surplus
    y{k+1} = Refine_Grid(temp, x{k+1}, d);
end

num_pts = 0;
for j = 1:length(y)
    if isempty(y{j})
        break
    end
    plot(y{j}(:,1), '.'), hold on
    num_pts = num_pts + size(y{j}(:,1),1);
end

vec_smol = SC_Interp3(d, w, range, y, x_test(1,:));
n = 1;
for i = 1:length(x)
    for j = 1:length(x{i})
        nodes(n) = x{i}(j);
        n = n+1;
    end
end
y = zeros(length(nodes),1);

figure(2)
plot(x_test, vec_exact), hold on
plot(x_test, vec_smol, 'r'), hold on
plot(nodes, y, 'o')
legend('Exact', 'Interpolated', 'Interpolation nodes')