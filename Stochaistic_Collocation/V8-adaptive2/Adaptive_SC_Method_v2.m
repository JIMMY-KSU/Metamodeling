clear all; close all; clc;

% Function
f = @(x) exp(-(x-0.4).^2./0.0625^2);
% f = @(x) 12+13.*x-x.^4;
% f = @(x) heaviside(x-0.25);
% Independant variable minima and maxima
range = [0 1];
% Test Domain
num_test_pts = 100;
test_pts(:,1) = range(1):range(1)+(range(2)-range(1))/(num_test_pts-1):range(2);
% Maximum level of refinement
max_level = 5;
% Number of dimensions
d = 1;
% Max Error
error = 0.0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ensure that the first 2 levels are used always
[w x z m] = Initialize(d, f);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute the adaptive grid
[x a m w] = Build_Grid(w, x, z, m, max_level, f, error);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Interpolate the desired values using the adapted grid
A = zeros(num_test_pts,1);
for p = 1:num_test_pts
    Delta = zeros(length(x),1);
    for i = 1:length(x)
        a{i} = compute_basis(i, m{i}, x{i}, test_pts(p));
        Delta(i) = sum(a{i}.*w{i});
        A(p) = A(p) + Delta(i);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n = 1;
for i = 1:length(x)
    for j = 1:length(x{i})
        nodes(n) = x{i}(j);
        y(n)     = feval(f, nodes(n));
        n = n+1;
    end
end
y = zeros(length(nodes),1);
err_L2_num = 0; err_L2_denom = 0;
for i = 1:size(test_pts,1)
    err1(i)      = abs(feval(f,test_pts(i)) - A(i)) ;
    err_L2_num   = err_L2_num    + err1(i)^2 ;
    err_L2_denom = err_L2_denom  + feval(f,test_pts(i))^2;
end
err_3 = sqrt(err_L2_num/err_L2_denom)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
text_size = 20;
figure(1)
plot(test_pts, feval(f,test_pts)), hold on
plot(test_pts, A, 'r'), hold on
plot(nodes, y, 'o')
set(gca, 'FontSize', text_size)
xlabel('Independant Variable')
set(gca, 'FontSize', text_size)
ylabel('Dependant Variable')
set(gca, 'FontSize', text_size)
legend('Exact Function', 'Interpolated Function', 'Interpolation nodes')
% legend('boxoff')
set(gca, 'FontSize', text_size, 'box', 'off')
% title(['Max Error = ' num2str(error) ' and Max Level = ' num2str(max_level) ' with ' num2str(size(nodes,2)) ' nodes'])
% title(['Max Error = ' num2str(error) ' with ' num2str(size(nodes,2)) ' nodes'])
set(gca, 'FontSize', text_size, 'box', 'off')

figure(2)
semilogy(test_pts, abs(feval(f,test_pts) - A))
set(gca, 'FontSize', text_size, 'box', 'off')
title('Log Plot of the local error')
set(gca, 'FontSize', text_size, 'box', 'off')
ylabel('log(error)'), xlabel('independant variable value')
set(gca, 'FontSize', text_size, 'box', 'off')