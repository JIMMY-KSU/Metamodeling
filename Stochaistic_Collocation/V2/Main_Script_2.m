clear all; close all; clc

test_pts = 51;
d = 2;
k = 4;
% q = k+d;
analyt = 2;
for q = d:d+k
    for i = 1:test_pts
        for j = 1:test_pts
            y(1) = -1 + 2*(i-1)/(test_pts-1);
            y(2) = -1 + 2*(j-1)/(test_pts-1);
            
            exact(i,j) = analyt_func(y(1), y(2), analyt);
            smol(i,j)  = Smolyak_func(q, d, y, analyt);
        end
    end
    [err_loc err_L2] = error_analysis(smol, exact);
    if q>d
        figure(1)
        semilogy([q-d-1 q-d], [temp err_L2], '-bs', 'MarkerSize', 10)
        title('L2 Error vs. Polynomial Order')
        hold on
    end
    temp = err_L2;
    
    figure(2)
    subplot(1,2,1), surf(-1:2/(test_pts-1):1, -1:2/(test_pts-1):1, exact);
    title('Exact Solution')
    subplot(1,2,2), surf(-1:2/(test_pts-1):1, -1:2/(test_pts-1):1, smol);
    axis([-1 1 -1 1 min(min(exact)) max(max(exact))])
    title('Sparse Grid Solution')
end
