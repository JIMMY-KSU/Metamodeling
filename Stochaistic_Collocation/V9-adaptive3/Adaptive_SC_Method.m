clear all; close all; clc;

% Function
% f = @(x,y) 5.*exp(-500.*((x-0.3).^2+(y-0.7).^2))+0.2.*sin(2*pi.*x).*sin(2*pi.*y);
f = @(x,y) x^3 + y^4;
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
error = 0.0;
% Initialize functions
n = 1;

% Ensure that the first 2 levels are used always
for i = 1:3
    vali{i,1} = compute_i(d,i);
    m{i,1}    = compute_m(vali{i});
    x{i,1}    = grid_pts(vali{i});
    z{i,1}    = compute_z(f, x{i});
end
% Find the second refinement level interpolation of the third level pts.
for k = 1:2
    for p = 1:length(x{k})
        for i = 1:2
            prod_a{i} = ones(size(x{i},1), 1);
            for l = 1:d
                a{i}(:,l) = compute_basis(i, m{i}(:,l), x{i}(:,l), x{3}(p,l));
                prod_a{i} = prod_a{i}.*a{i}(:,l);
            end
            U(i) = sum(prod_a{i}.*z{i});
        end
        
        Delta = zeros(2,1);
        for i = 1:2
            if i == 1
                Delta(i) = U(i);
            else
                Delta(i) = U(i) - U(i-1);
            end
        end
        V{k}(p,1) = 0;
        for i = 1:2
            V{k}(p) = V{k}(p) + Delta(i);
        end
        w{k}(p,1) = z{k+1}(p)-V{k}(p);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x_active{1} = x{2};
x_active{2} = x{3};
check       = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute the adaptive grid
for k = 2:max_level
    vali{k+1} = compute_i(d,k);
    m{k+1}    = compute_m(vali{k+1});
    z{k+1}    = compute_z(f, x_active{k});
    for p = 1:length(x_active{k})
        for i = 1:k
            prod_a{i} = ones(size(x{i},1), 1);
            for l = 1:d
                a{i}(:,l) = compute_basis(i, m{i}(:,l), x{i}(:,l), x{3}(p,l));
                prod_a{i} = prod_a{i}.*a{i}(:,l);
            end
        end
        
        Delta = zeros(k,1);
        for i = 1:k
            Delta(i,1) = sum(prod_a{i}.*w{i});
        end
        V{k}(p) = 0;
        for i = 1:k
            V{k}(p) = V{k}(p) + Delta(i);
        end
        % Compute error
        w{k+1}(p,1) = z{k+1}(p)-V{k}(p);
        
        for l = 1:d
            x_active{k+1}(n,:) = x_active{k}(p,:);
            n = n+1;
            % Error Check
            if abs(w{k+1}(p)) > error
                check = 1;
                x_active{k+1}(1,l) = 0;
                num = x_active{k}(p,l) - 2^(1-(k+2));
                if num > 0
                    x_active{k+1}(n,:) = x_active{k}(p,:);
                    x_active{k+1}(n,l) = num;
                    n = n+1;
                end
                num = x_active{k}(p,l) + 2^(1-(k+2));
                if num < 1
                    x_active{k+1}(n,1:d) = x_active{k}(p,1:d);
                    x_active{k+1}(n,l) = num;
                    n = n+1;
                end
            end
        end
        x_active{k+1}(n,l) = 1;
        x_active{k+1}         = unique(x_active{k+1}, 'rows');
        x{k+1} = x_active{k};
    end
    n = 2;
    if check
        check = 0;
    else
        disp(k+1);
        break;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Interpolate the desired values using the adapted grid
A = zeros(num_test_pts,1);
for p = 1:num_test_pts
    for i = 1:size(x,1)
        prod_a{i} = ones(size(x{i},1), 1);
        for l = 1:d
             a{i}(:,l) = compute_basis(i, m{i}(:,l), x{i}(:,l), x{3}(p,l));
            prod_a{i} = prod_a{i}.*a{i}(:,l);
        end
    end
    
    Delta = zeros(length(x),1);
    for i = 1:length(x)
        Delta(i) = sum(prod_a{i}.*w{i});
    end
    for i = 1:length(x)
        A(p) = A(p) + Delta(i);
    end
end

% n = 1;
% for i = 1:length(x)
%     for j = 1:length(x{i})
%         nodes(n) = x{i}(j);
%         y(n)     = feval(f, nodes(n));
%         n = n+1;
%     end
% end
% y = zeros(length(nodes),1);

n = 1;
for k = size(x,1)
    for i = 1:test_pts
        for j = 1:test_pts
            smol(i,j)  = A{k}(1,n);
            exact(i,j) = z{k}(1,n);
            n = n+1;
        end
    end
end

% figure(1)
% plot(test_pts, feval(f,test_pts)), hold on
% plot(test_pts, A, 'r'), hold on
% plot(nodes, y, 'o')
% legend('Exact', 'Interpolated', 'Interpolation nodes')