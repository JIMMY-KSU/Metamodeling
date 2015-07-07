clear all; close all; clc;

clear all; close all; clc;

% Function
f = @(x,y) 5.*exp(-500.*((x-0.3).^2+(y-0.7).^2))+0.2.*sin(2*pi.*x).*sin(2*pi.*y);
% Maximum level of refinement
max_level = 9;
% Number of dimensions
d = 2;
% Independant variable minima and maxima
range = [0 1 0 1];
% Test Domain
num_test_pts = 100; test_pts = zeros(num_test_pts, d);
for l = 1:d
    test_pts(:,l) = range(l*2-1):range(l*2-1)+...
        (range(l*2)-range(l*2-1))/(num_test_pts-1):range(l*2);
end
% Max relative error
error = 0.01;
% Initialize functions
n = 1;

% Ensure that the first 2 levels are used always
for i = 1:3
    vali{i,1} = compute_i(d,i);
    m{i}      = compute_m(vali{i});
    x{i,1}    = compute_x(m{i});
    for j = 1:length(x{i}(:,1))
        var_vals  = mat2cell(x{i,1}(j,:), 1, ones(1,d));
        z{i,1}(j,1) = feval(f, var_vals{:});
    end
end

n = 1;
for j = 1:i
    for q = 1:length(x{j})
        C(n,1) = x{j}(q,1);
        C(n,2) = x{j}(q,2);
        n = n+1;
    end
end
plot(C(:,1),C(:,2),'.')
c = unique(C, 'rows');

% d = 2; k = 4;
% n = 1;
% for p = 1:k
%     i = compute_i(d,k);
%     m = compute_m(i);
%     x{p} = grid_pts(i);
%     for q = 1:length(x{p})
%         C(n,1) = x{p}(q,1);
%         C(n,2) = x{p}(q,2);
%         n = n+1;
%     end
% end
% 
