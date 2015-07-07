function local_error_plot(test_pts, err_loc, max1, min1, max2, min2)
figure(4)
subplot(2,1,1)
surf(((-1:2/(test_pts-1):1)+1)/2*(max2-min2)+min2,...
     ((-1:2/(test_pts-1):1)+1)/2*(max1-min1)+min1, err_loc);
ylabel('x'), xlabel('y')
zlabel('Local Error')
title(['Local Error'])
colorbar


subplot(2,1,2)
contourf(((-1:2/(test_pts-1):1)+1)/2*(max2-min2)+min2,...
         ((-1:2/(test_pts-1):1)+1)/2*(max1-min1)+min1, err_loc)
ylabel('x'), xlabel('y')
zlabel('Local Error')
title(['Local Error'])
colorbar
