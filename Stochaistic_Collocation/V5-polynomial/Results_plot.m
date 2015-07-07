function Results_plot(test_pts, exact, smol, max1, min1, max2, min2)

name1 = 'Y';
name2 = 'X';
figure(10)
subplot(2,2,1)
surf(((-1:2/(test_pts-1):1)+1)./2.*(max2-min2)+min2,...
    ((-1:2/(test_pts-1):1)+1)./2.*(max1-min1)+min1, exact);
ylabel(name1), xlabel(name2)
zlabel('Analytic Values')
axis([min2 max2 min1 max1 min(min(exact)) max(max(exact))])
title(['Exact Values'])
shading interp

subplot(2,2,2)
contourf(((-1:2/(test_pts-1):1)+1)./2.*(max2-min2)+min2,...
    ((-1:2/(test_pts-1):1)+1)./2.*(max1-min1)+min1, exact)
ylabel(name1), xlabel(name2)
zlabel('Exact Values')
title(['Exact Values'])
colorbar

subplot(2,2,3)
surf(((-1:2/(test_pts-1):1)+1)./2.*(max2-min2)+min2,...
    ((-1:2/(test_pts-1):1)+1)./2.*(max1-min1)+min1, smol);
ylabel(name1), xlabel(name2)
zlabel('Interpolated Values')
axis([min2 max2 min1 max1 min(min(exact)) max(max(exact))])
title(['Interpolated Values'])
shading interp

subplot(2,2,4)
contourf(((-1:2/(test_pts-1):1)+1)./2.*(max2-min2)+min2,...
    ((-1:2/(test_pts-1):1)+1)./2.*(max1-min1)+min1, smol)
ylabel(name1), xlabel(name2)
zlabel('Interpolated Values')
title(['Interpolated Values'])
colorbar