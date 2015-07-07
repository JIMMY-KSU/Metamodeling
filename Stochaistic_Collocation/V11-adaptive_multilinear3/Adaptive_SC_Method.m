clear all; close all; clc;
% Number of dimensions
d = 2;
% Function
if d == 1
    f = @(x) exp(-(x-0.4).^2./0.0625^2);
elseif d == 2
    % Simple polynomial function
%     f = @(x,y) x.^2 + y.^3;
    % Line Discontinuity
%     f = @(x,y) 1/(abs(0.3-x^2-y^2)+0.1);
    % Point Singularity
%     alpha = 10^3;
%     f = @(x,y) 5*exp(-alpha*((x-0.5)^2+(y-0.5)^2))...
%         -0.2*sin(2*pi*x)*sin(2*pi*y);
    % Simple Non-linear function
%     f = @(x,y) y.*(4.*x.^2-1);
    % Drag Profile
%     f = @(rep,map) (24.0./rep+0.38+4.0./sqrt(rep))*(1.0+exp(-0.43./(map.^4.67)));
    % Integrated Line Discontinuity
%     f = @(x,y) abs(16*sqrt(0.4)/log(abs((sqrt(0.3)+sqrt(0.4))/(sqrt(0.3)-sqrt(0.4))))...
%         /(2*sqrt(0.4))*log(abs((sqrt(x.^2+y.^2)+sqrt(0.4))./...
%         (sqrt(x.^2+y.^2)-sqrt(0.4))))).^(sqrt(x.^2+y.^2)<=sqrt(0.3))+abs(...
%         16*sqrt(0.2)/log(abs((sqrt(0.3)-sqrt(0.2))/(sqrt(0.3)+sqrt(0.2))))...
%         /(2*sqrt(0.2))*log(abs((sqrt(x.^2+y.^2)-sqrt(0.2))./...
%         (sqrt(x.^2+y.^2)+sqrt(0.2))))).^(sqrt(x.^2+y.^2)>sqrt(0.3))-1;
    % Harmonic Function
%     f = @(x,y) sin(2*pi*x)*cos(2*pi*y)+sin(2*pi*x/5)*cos(2*pi*y/5)...
%         +sin(2*pi*x/10)*cos(2*pi*y/10);
    % Harmonic Function 2
    f = @(y,x) sin(2*pi.*(x+0.25)).*cos(4*pi.*(y+0.4))+2;
    % Harmonic hyperbolic tan function
    f = @(y,x) 1+tanh(x)*tanh(2*y);
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
    range = [0 1;0 1];
    num_test_pts(1) = 101;
    num_test_pts(2) = 101;
    n = 1;
    for i = 1:num_test_pts(1)
        for j = 1:num_test_pts(2)
            test_pts(n,1) = (i-1)/(num_test_pts(1)-1);
            test_pts(n,2) = (j-1)/(num_test_pts(2)-1);
            n = n+1;
        end
    end
end

% Minimum/Maximum level of refinement
min_level = 2;                  % must be > 1
max_level = 11;                  % must be >= min_level
max_level = max_level+1;        % max_level includes level 0
% Max Error
error = 0.0001;
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
for m = 1:size(x,2)
    tic
    x2{m} = x{m};
    w2{m} = w{m};
    A = zeros(size(test_pts,1),1);
    Delta{m} = compute_Delta2(d,size(w2,2),x2,test_pts,w2);
    for i = 1:length(w2)
        A = A + Delta{i};
    end
    interpolate_solution_time(m) = toc
    n = 1;
    for i = 1:num_test_pts(1)
        for j = 1:num_test_pts(2)
            Z(i,j)     = A(n);
            exact(i,j) = compute_f(f,range,test_pts(n,:));
            n = n+1;
        end
    end
    nodes = [];
    for i = 1:size(w2,2)
        nodes = [nodes;x{i}];
    end
    err(m,1) = size(nodes,1);
    [err_loc{m} err(m,2) err(m,3) err(m,4)] = error_analysis(Z, exact);
end
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
    
    figure(2)
    semilogy(test_pts, abs(feval(f,test_pts) - A))
    set(gca, 'FontSize', text_size, 'box', 'off')
    title('Log Plot of the local error')
    set(gca, 'FontSize', text_size, 'box', 'off')
    ylabel('log(error)'), xlabel('independant variable value')
    set(gca, 'FontSize', text_size, 'box', 'off')
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
    for i = 1:size(x,2)
        nodes = [nodes;x{i}];
    end
    nodes(:,1) = range(1,1) + nodes(:,1)*(range(1,2)-range(1,1));
    nodes(:,2) = range(2,1) + nodes(:,2)*(range(2,2)-range(2,1));
    figure(1)
        plot(nodes(:,1),nodes(:,2),'.','MarkerSize',30)
        xlabel('Ma'),ylabel('Re')
    
    figure(2)
    subplot(1,2,1),surf(range(2,1):(range(2,2)-range(2,1))...
        /(num_test_pts(2)-1):range(2,2),...
        range(1,1):(range(1,2)-range(1,1))...
        /(num_test_pts(1)-1):range(1,2),...
        exact), title('Exact'), xlabel('Ma'),ylabel('Re')
    subplot(1,2,2),surf(range(2,1):(range(2,2)-range(2,1))...
        /(num_test_pts(2)-1):range(2,2),...
        range(1,1):(range(1,2)-range(1,1))...
        /(num_test_pts(1)-1):range(1,2),...
        Z), title('Interpolated'), xlabel('Ma'),ylabel('Re')
    
    figure(3)
    mesh(range(2,1):(range(2,2)-range(2,1))...
        /(num_test_pts(2)-1):range(2,2),...
        range(1,1):(range(1,2)-range(1,1))...
        /(num_test_pts(1)-1):range(1,2),...
        Z), title('Interpolated'), hold on,
        plot3(nodes(:,2),nodes(:,1),compute_f(f,range,nodes),'.')
        xlabel('Ma'),ylabel('Re'), hold off
    
    figure(4)
    mesh(range(2,1):(range(2,2)-range(2,1))...
        /(num_test_pts(2)-1):range(2,2),...
        range(1,1):(range(1,2)-range(1,1))...
        /(num_test_pts(1)-1):range(1,2),...
        exact), title('Exact'), hold on,
        plot3(nodes(:,2),nodes(:,1),compute_f(f,range,nodes),'.')
        xlabel('Ma'),ylabel('Re'), hold off
end