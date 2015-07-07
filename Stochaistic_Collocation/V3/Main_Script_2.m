clear all; close all; clc

global max1 min1 max2 min2

%Which analytical function to use?
analyt = 5;
%Function parameters
name1 = 'X';
max1  = 1;
min1  = 0;
name2 = 'Y';
max2  = 1;
min2  = 0;
%Number of points to be interpolated in postprocessing
test_pts = 100;
%Number of dimensions
d = 2;
%Max polynomial order
k = 6;
%Error plot on or off
err_plt = 1;

% Test the algorithm
for q = d+k:d+k
    tic
    for i = 1:test_pts
        for j = 1:test_pts
            y(1) = -1 + 2*(i-1)/(test_pts-1);
            y(2) = -1 + 2*(j-1)/(test_pts-1);
            
            exact(i,j) = analyt_func(y(1), y(2), analyt);
            smol(i,j)  = Smolyak_func(q, d, y, analyt);
        end
    end
    toc
    
    [err_loc err_L2(q-1)] = error_analysis(smol, exact);
    if q>d && err_plt
        figure(1)
        semilogy([q-d-1 q-d], [err_L2(q-2) err_L2(q-1)], '-bs', 'MarkerSize', 10)
        title('L2 Error vs. Polynomial Order')
        hold on
    end
%     temp = err_L2(q);
    
    figure(2)
    subplot(2,2,1)
    surf(((-1:2/(test_pts-1):1)+1)./2.*(max2-min2)+min2,...
        ((-1:2/(test_pts-1):1)+1)./2.*(max1-min1)+min1, exact);
    ylabel(name1), xlabel(name2)
    zlabel('Drag(Analytic Values)')
    axis([min2 max2 min1 max1 min(min(exact)) max(max(exact))])
    title(['Empirical Formula (Training Data)'])
    shading interp
    
    subplot(2,2,2)
    contourf(((-1:2/(test_pts-1):1)+1)./2.*(max2-min2)+min2,...
        ((-1:2/(test_pts-1):1)+1)./2.*(max1-min1)+min1, exact)
    ylabel(name1), xlabel(name2)
    zlabel('Drag(Empirical Values)')
    title(['Empirical Formula (Training Data)'])
    colorbar
    
    subplot(2,2,3)
    surf(((-1:2/(test_pts-1):1)+1)./2.*(max2-min2)+min2,...
        ((-1:2/(test_pts-1):1)+1)./2.*(max1-min1)+min1, smol);
    ylabel(name1), xlabel(name2)
    zlabel('Drag(Interpolated Values)')
    axis([min2 max2 min1 max1 min(min(exact)) max(max(exact))])
    title(['Drag Coefficient-Interpolated Values'])
    shading interp
    
    subplot(2,2,4)
    contourf(((-1:2/(test_pts-1):1)+1)./2.*(max2-min2)+min2,...
        ((-1:2/(test_pts-1):1)+1)./2.*(max1-min1)+min1, smol)
    ylabel(name1), xlabel(name2)
    zlabel('Drag(Interpolated Values)')
    title(['Drag Coefficient-Interpolated Values'])
    colorbar
    
    figure(3)
    subplot(1,2,1)
    surf(((-1:2/(test_pts-1):1)+1)./2.*(max2-min2)+min2,...
        ((-1:2/(test_pts-1):1)+1)./2.*(max1-min1)+min1, smol);
    ylabel(name1), xlabel(name2)
    zlabel('Drag(Interpolated Values)')
    % axis([min(Ix2),max(Ix2),min(Iy2),max(Iy2),0.3,1.4])
    caxis([0 1.7])
    title(['Drag(Interpolated Values)'])
    colorbar
    
    subplot(1,2,2)
    contourf(((-1:2/(test_pts-1):1)+1)./2.*(max2-min2)+min2,...
        ((-1:2/(test_pts-1):1)+1)./2.*(max1-min1)+min1, smol)
    ylabel(name1), xlabel(name2)
    zlabel('Drag(Interpolated Values)')
    title(['Drag Coefficient-Interpolated Values'])
    colorbar    
end
