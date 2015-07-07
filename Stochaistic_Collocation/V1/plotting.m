function plotting(pts, cd, cd_test, cd_actual, test_pts, analyt)

xlin = linspace(min(pts(:,1)),max(pts(:,1)),test_pts);
ylin = linspace(min(pts(:,2)),max(pts(:,2)),test_pts);
[X,Y] = meshgrid(xlin,ylin);
f = TriScatteredInterp(pts(:,1),pts(:,2),cd);
Z = f(X,Y);

n = 1;
for i = -1:2/(test_pts-1):1
    m = 1;
    for j = -1:2/(test_pts-1):1
        exact(n,m) = analyt_func(i,j,analyt);
        m = m+1;
    end
    n = n+1;
end

figure(1)
contourf(-1:2/(test_pts-1):1, -1:2/(test_pts-1):1,...
    abs(cd_test-cd_actual)./(cd_actual+eps)),colorbar,  hold on
plot3(pts(:,1), pts(:,2), cd, '.m','MarkerSize', 15);
plot(pts(:,1), pts(:,2), '.m')
title('local % error')

% figure(2)
% plot(pts(:,1), pts(:,2), '.')
% title('node points')

figure(3)
subplot(1,3,1)
surf(X,Y,Z), hold on
plot3(pts(:,1), pts(:,2), cd, '.m','MarkerSize', 15);
title('Matlab interpolation, analytic values at node points')

subplot(1,3,2)
surf(-1:2/(test_pts-1):1, -1:2/(test_pts-1):1, cd_test), hold on
plot3(pts(:,1), pts(:,2), cd, '.m','MarkerSize', 15);
title('interpolated values')

subplot(1,3,3)
surf(-1:2/(test_pts-1):1, -1:2/(test_pts-1):1, exact)
title('exact solution')

% subplot(1,3,3)
% surf(-1:2/(test_pts-1):1, -1:2/(test_pts-1):1,...
%     abs(cd_test-cd_actual)./(cd_actual+eps))
% title('local % error')