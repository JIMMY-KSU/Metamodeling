% Compute the local and L2 error between two functions
function [err_loc err_L2] = error_analysis(test, exact)

err_loc = test;

for i = 1:length(test(:,1))
    for j = 1:length(test(1,:))
        err_loc(i,j) = abs(test(i,j) - exact(i,j));
    end
end
err_L2 = norm(err_loc);