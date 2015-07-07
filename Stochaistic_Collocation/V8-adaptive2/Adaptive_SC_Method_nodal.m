clear all; close all; clc;

% Function
f = @(x) exp(-(x-0.4).^2./0.0625^2);
% Independant variable minima and maxima
range = [0 1];
% Test Domain
num_test_pts = 100;
test_pts(:,1) = range(1):range(1) + (range(2)-range(1))/(num_test_pts-1):range(2);
% Maximum level of refinement
level = 6;
% Number of dimensions
d = 1;

% Initialize functions
A = zeros(num_test_pts,1);

for i = 1:level+1
    q{i,1} = i + d;
    m{i,1} = compute_m(i);
    x{i,1} = compute_x(i, m{i});
    z{i,1} = feval(f, x{i});
end

for p = 1:num_test_pts
    for i = 1:length(x)
        a{i} = compute_basis(i, m{i}, x{i}, test_pts(p));
        U(i,1) = 0;
%         for j = 1:m{length(x)}(i)
%             U(i) = U(i) + z{i}(j)*a{i}(j);
%         end
        U(i) = sum(z{i}.*a{i});
    end
    
    Delta = zeros(length(x),1);
    for i = 1:length(x)
        if i == 1
            Delta(i) = U(i);
        else
            Delta(i) = U(i) - U(i-1);
        end
    end
    for i = 1:length(x)
        A(p) = A(p) + Delta(i);
    end
end

n = 1;
for i = 1:length(x)
    for j = 1:length(x{i})
        nodes(n) = x{i}(j);
        n = n+1;
    end
end
y = zeros(length(nodes),1);

figure(1)
plot(test_pts, feval(f,test_pts)), hold on
plot(test_pts, A, 'r'), hold on
plot(nodes, y, 'o')
legend('Exact', 'Interpolated', 'Interpolation nodes')