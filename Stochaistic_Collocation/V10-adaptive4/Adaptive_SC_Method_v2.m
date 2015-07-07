clear all; close all; clc;
% Function
f = @(x,y) x^3+y^4;
% Independant variable minima and maxima
range{1} = [0 1];
range{2} = [0 1];
% Maximum level of refinement
max_level = 4;
% Number of dimensions
d = 2;
% Number of points in each dimension of the test domain
num_test_pts = 100;
% Max Error
error = 0.01;
% Test Domain
for l = 1:d
    test_pts(:,l) = range{l}(1):range{l}(1)+(range{l}(2)-range{l}(1))/(num_test_pts-1):range{l}(2);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ensure that the first 2 levels are used always
for i = 0:max_level
    vali{i+1,1} = compute_i(d,i);
    m{i+1,1}    = compute_m(vali{i+1});
%     x{i,1}    = compute_x2(vali{i},m{i});
    x{i+1,1}    = grid_pts(vali{i+1});
    z{i+1,1}    = compute_z(f, x{i+1});
end
% Find the second refinement level interpolation of the third level pts.
for k = 1:max_level-1
    for p = 1:size(x{k+1},1)
        for l = 1:d
            for i = 1:k
                a{i,1}(:,l) = compute_basis(i, m{i}(:,l), x{i}(:,l), x{k+1}(p,l));
            end
        end
        for i = 1:k
            A{i,1} = a{i}(:,1);
            for l = 2:d
                A{i} = A{i}.*a{i}(:,l);
            end
            U(i) = sum(A{i}.*z{i});
        end
        
        Delta = zeros(2,1);
        for i = 1:k
            if i == 1
                Delta(i) = U(i);
            else
                Delta(i) = U(i) - U(i-1);
            end
        end
        V{k,1}(p,1) = 0;
        for i = 1:k
            V{k}(p) = V{k}(p) + Delta(i);
        end
        w{k,1}(p,1) = z{k+1}(p)-V{k}(p);
    end
end


nds = [];
for i = 1:length(x)
    nds = [nds; x{i}];
end
figure(1)
plot(nds(:,1),nds(:,2),'.')

y = zeros(length(nds),1);
err_L2_num = 0; err_L2_denom = 0;
n = 1;
for i = 1:size(x{size(x,1)-1},1)
        err1(n)      = abs(feval(f,x{size(x,1)-1}(i,1), x{size(x,1)-1}(i,2)) - V{size(V,1)}(n));
        err_L2_num   = err_L2_num    + err1(n)^2 ;
        err_L2_denom = err_L2_denom  + feval(f,x{size(x,1)-1}(i,1),x{size(x,1)-1}(i,2))^2;
        n = n+1;
end
err_3 = sqrt(err_L2_num/err_L2_denom)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%