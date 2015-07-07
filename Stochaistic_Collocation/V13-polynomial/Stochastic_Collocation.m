clear all; close all; clc;
for analyt = 5:5
analyt
global max1 min1 max2 min2

%Number of points to be interpolated in postprocessing
test_pts = 100;
num_test_pts(1:2) = test_pts;
%Number of dimensions
d = 2;
%Max polynomial order
k = 7;

% Initial Conditions?
if analyt < 5%1=smooth; 2=shifted smooth, 3=C1, 4=noisy shifted smooth
    range = [0 1; 0 1];
elseif analyt == 5 %Boiko's model
    range = [100 10000; 0.1 3];
elseif analyt == 6% Loth's model
    range = [100 10000; 0 5];
elseif analyt == 7% Tong's model
    range = [100 600; 0.001 0.6];
end

min1 = range(1,1);
max1 = range(1,2);
min2 = range(2,1);
max2 = range(2,2);

% Test the algorithm
for q = 7:7
    [num_pts(q-1),nodes] = Colloc_Pts(q);
    err(q-1,1)           = num_pts(q-1);
    tic
    
    %   Build the test space
    for i = 1:test_pts
        for j = 1:test_pts
            y(1) = -1 + 2*(i-1)/(test_pts-1);
            y(2) = -1 + 2*(j-1)/(test_pts-1);
            exact(i,j)  = analyt_func(y(1), y(2), analyt);
            exact2(i,j) = analyt_func(y(1), y(2), 2);
            Z(i,j)     = Smolyak_func(q, d, y, analyt, 'poly');
        end
    end
    toc
    if analyt == 4
        [err_loc err(q-1,2) err(q-1,3) err(q-1,4)] = error_analysis(Z, exact2);
    else
        [err_loc err(q-1,2) err(q-1,3) err(q-1,4)] = error_analysis(Z, exact);
    end
    save(['Output/Eqn_Num_' int2str(analyt) '/Order_' int2str(q-2)]);
    if q == 7;
        save(['Output/func_' int2str(analyt) '_err_0.mat']);
    end
end
end