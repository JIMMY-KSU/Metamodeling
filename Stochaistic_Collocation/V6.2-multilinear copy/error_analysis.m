% Compute the local and L2 error between two functions
function [err_loc err_1 err_2 err_3] = error_analysis(test, exact)

err_loc      = test;
err1         = test;
err_L2_num   = 0;
err_L2_denom = 0;
avg          = abs(sum(sum(exact))/(length(test(1,:))^2));

for i = 1:length(test(:,1))
    for j = 1:length(test(1,:))
        err1(i,j)    = abs(test(i,j) - exact(i,j)) ;
        err_L2_num   = err_L2_num    + err1(i,j)^2 ;
        err_L2_denom = err_L2_denom  + exact(i,j)^2;
    end
end
err_loc = err1/avg;
err_1   = max(max(err1));
err_2   = max(max(err_loc));
err_3   = sqrt(err_L2_num/err_L2_denom);
% err_L2 = norm(err_loc);