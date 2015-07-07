clear all; close all; clc;
% Number of dimensions
d = 2;
% Function
if d == 1
    f = @(x) exp(-(x-0.4).^2./0.0625^2);
elseif d == 2
    f = @(x,y) x.^2 + y.^3;
%     f = @(x,y) 1/(abs(0.3-x^2-y^2)+0.1);
end
% Test Domain
if d == 1
    % Independant variable minima and maxima
    range = [0 1];
    num_test_pts = 100;
    test_pts(:,1) = range(1):...
        range(1) + (range(2)-range(1))/(num_test_pts-1):range(2);
else
    % Independant variable minima and maxima
    range = [0 1; 0 1];
    num_test_pts(1) = 20;
    num_test_pts(2) = 20;
    n = 1;
    for i = 1:num_test_pts(1)
        for j =1:num_test_pts(2)
            test_pts(n,1) = range(1,1) +...
                (i-1)*(range(1,2)-range(1,1))/(num_test_pts(1)-1);
            test_pts(n,2) = range(2,1) +...
                (j-1)*(range(2,2)-range(2,1))/(num_test_pts(2)-1);
            n = n+1;
        end
    end
end

        
% Minimum/Maximum level of refinement
min_level = 2;                  % must be > 1
max_level = 3;                  % must be >= min_level
max_level = max_level+1;        % max_level includes level 0
% Max Error
error = 0.01;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ensure that the minimum specified levels are used always
tic
[w x] = Initialize(min_level, f, d, range);
initialize_time = toc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute the adaptive grid
tic
[w x] = Build_Grid(w, min_level, max_level, f, d, error, range);
adaptive_grid_time = toc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Interpolate the desired values using the adapted grid
tic
A = zeros(size(test_pts,1),1);
for p = 1:size(test_pts,1)
    Delta = compute_Delta(d,size(w,2),x,test_pts(p,:),w);
    for i = 1:length(w)
        A(p) = A(p) + Delta(i);
    end
end
interpolate_solution_time = toc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if d == 1
    n = 1;
    for i = 1:length(w)
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
    legend('Exact Function','Interpolated Function','Interpolation nodes')
    set(gca, 'FontSize', text_size, 'box', 'off')
    set(gca, 'FontSize', text_size, 'box', 'off')
    
%     figure(2)
%     semilogy(test_pts, abs(feval(f,test_pts) - A))
%     set(gca, 'FontSize', text_size, 'box', 'off')
%     title('Log Plot of the local error')
%     set(gca, 'FontSize', text_size, 'box', 'off')
%     ylabel('log(error)'), xlabel('independant variable value')
%     set(gca, 'FontSize', text_size, 'box', 'off')
else
    n = 1;
    for i = 1:num_test_pts(1)
        for j = 1:num_test_pts(2)
            Z(i,j)     = A(n);
            exact(i,j) = compute_f(f,range,test_pts(n,:));
            n = n+1;
        end
    end
    nodes = [];
    for i = 1:size(w,2)
        nodes = [nodes;x{i}];
    end
    figure(1)
    subplot(1,2,1),surf(range(1,1):range(1,1)+...
        (range(1,2)-range(1,1))/(num_test_pts(1,1)-1):range(1,2),...
        range(1,1):range(1,1)+...
        (range(1,2)-range(1,1))/(num_test_pts(1,1)-1):range(1,2),...
        exact), title('Exact')
    subplot(1,2,2),surf(range(1,1):range(1,1)+...
        (range(1,2)-range(1,1))/(num_test_pts(1,1)-1):range(1,2),...
        range(1,1):range(1,1)+...
        (range(1,2)-range(1,1))/(num_test_pts(1,1)-1):range(1,2),...
        Z), title('Interpolated')
    figure(2)
    plot(nodes(:,1),nodes(:,2),'.')
end
