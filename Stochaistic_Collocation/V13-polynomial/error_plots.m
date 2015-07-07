function error_plots(num_pts, err_1, err_2, err_3, q)

figure(1)
loglog([num_pts(q-2) num_pts(q-1)], [err_1(q-2) err_1(q-1)], '-bs', 'MarkerSize', 10)
title('Error 1 vs. Number of Points')
hold on

figure(2)
loglog([num_pts(q-2) num_pts(q-1)], [err_2(q-2) err_2(q-1)], '-bs', 'MarkerSize', 10)
title('Error 2 vs. Number of Points')
hold on

figure(3)
loglog([num_pts(q-2) num_pts(q-1)], [err_3(q-2) err_3(q-1)], '-bs', 'MarkerSize', 10)
title('Error 3 vs. Number of Points')
hold on