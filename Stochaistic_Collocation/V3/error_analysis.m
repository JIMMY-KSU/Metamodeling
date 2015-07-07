% Compute the local and L2 error between two functions
function [err_loc err_L2] = error_analysis(test, exact)

err_loc      = test;
err_L2_num   = 0;
err_L2_denom = 0;

for i = 1:length(test(:,1))
    for j = 1:length(test(1,:))
        err_loc(i,j) = abs((test(i,j) - exact(i,j))/exact(i,j));
        err_L2_num   = err_L2_num + err_loc(i,j)^2;
        err_L2_denom = err_L2_denom + exact(i,j)^2;
    end
end
err_L2 = sqrt(err_L2_num/err_L2_denom);
% err_L2 = norm(err_loc);