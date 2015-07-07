clear all; close all; clc;
% Function
f = @(x,y) x^3+y^4;
% Independant variable minima and maxima
range{1} = [0 1];
range{2} = [0 1];
% Maximum level of refinement
max_level = 6;
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
for i = 1:7
    vali{i,1} = compute_i(d,i);
    m{i,1}    = compute_m(vali{i});
    x{i,1}    = compute_x2(vali{i},m{i});
    z{i,1}    = compute_z(f, x{i});
end
% Find the second refinement level interpolation of the third level pts.
temp = 2;
temp = 6;
for k = 1:temp
    for p = 1:length(x{k})
        for l = 1:d
            for i = 1:temp
                a{i}(:,l) = compute_basis(i, m{i}(:,l), x{i}(:,l), x{k+1}(p,l));
            end
        end
        for i = 1:temp
            A{i} = a{i}(:,1);
            for l = 2:d
                A{i} = A{i}.*a{i}(:,l);
            end
            U(i) = sum(A{i}.*z{i});
        end
        
        Delta = zeros(2,1);
        for i = 1:temp
            if i == 1
                Delta(i) = U(i);
            else
                Delta(i) = U(i) - U(i-1);
            end
        end
        V{k,1}(p,1) = 0;
        for i = 1:temp
            V{k}(p) = V{k}(p) + Delta(i);
        end
        w{k}(p,1) = z{k+1}(p)-V{k}(p);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute the adaptive grid
k;
if 0
n = 1; check = 0;
x_active{1,1} = x{2};
x_active{2,1} = x{3};
for k = 2:max_level
    vali{k+1} = compute_i(d,k+1);
    m{k+1}    = compute_m(vali{k+1});
    z{k+1}    = compute_z(f, x_active{k});
    for p = 1:length(x_active{k})
        for l = 1:d
            for i = 1:k
                a{i}(:,l) = compute_basis(i, m{i}(:,l), x{i}(:,l), x_active{k}(p,l));
            end
        end
        for i = 1:k
            A{i} = a{i}(:,1);
            for l = 2:d
                A{i} = A{i}.*a{i}(:,l);
            end
        end
        Delta = zeros(k,1);
        for i = 1:k
            Delta(i,1) = sum(A{i}.*w{i});
        end
        V{k}(p) = 0;
        for i = 1:k
            V{k}(p) = V{k}(p) + Delta(i);
        end
        % Compute error
        w{k+1}(p,1) = z{k+1}(p)-V{k}(p);
        
        x_active{k+1}(n,:) = x_active{k}(p,:);
        n = n+1;
        % Error Check
        if abs(w{k+1}(p)) > error
            check = 1;
            x_active{k+1}(1,:) = 0;
            for l = 1:d
                num = x_active{k}(p,l) - 2^(1-(k+2));
                if num > 0
                    x_active{k+1}(n,:) = x_active{k}(p,:);
                    x_active{k+1}(n,l) = num;
                    n = n+1;
                end
                num = x_active{k}(p,l) + 2^(1-(k+2));
                if num < 1
                    x_active{k+1}(n,:) = x_active{k}(p,:);
                    x_active{k+1}(n,l) = num;
                    n = n+1;
                end
            end
        end
    end
    x_active{k+1}(n,:) = 1;
    x_active{k+1}      = unique(x_active{k+1},'rows');
    x{k+1} = x_active{k};
    n = 2;
    if check
        check = 0;
    else
        disp(k+1);
        break;
    end
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Interpolate the desired values using the adapted grid
if 0
V = zeros(num_test_pts^d,1);
for p = 1:num_test_pts
    for l = 1:d
        for i = 1:length(x)
            a{i}(p,q) = compute_basis(i, m{i}, x{i}(:,l), test_pts{l}(p));
        end
        
        Delta = zeros(length(x),1);
        for i = 1:length(x)
            Delta(i) = sum(a{i}.*w{i});
        end
        for i = 1:length(x)
            V(p) = V(p) + Delta(i);
        end
    end
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n = 1;
for i = 1:length(x)
    for j = 1:size(x{i},1)
        nodes(n,:) = x{i}(j,:);
        y(n)     = compute_z(f, nodes(n,:));
        n = n+1;
        nodes = unique(nodes,'rows');
    end
end
y = zeros(length(nodes),1);
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