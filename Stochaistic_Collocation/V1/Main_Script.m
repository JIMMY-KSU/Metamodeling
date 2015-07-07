clear all; clc; close all

% Collocation method: 1-Smolyak (not working), 2-Stroud-3
coll_method = 1; 

% Particle Mach Number input
ma_min = 0.1;
ma_max = 1.75;
ma_n   = 5;

ma = zeros(ma_n,1);

% Particle Reynolds number input
re_min = 100;
re_max = 10000;
re_n   = 5;

re = zeros(re_n,1);

for j = 1:ma_n;
    if coll_method == 1
        if ma_n == 1
            ma(j) = 1;
        else
            ma(j) = -cos(pi*(j-1)/(ma_n-1));
        end
    elseif coll_method == 2
        
    end
end
for j = 1:re_n;
    if coll_method == 1
        if re_n == 1
            re(j) = 1;
        else
            re(j) = -cos(pi*(j-1)/(re_n-1));
        end
    end
end

[X, Y] = meshgrid(ma, re);

figure(2)
plot(X, Y, '.b')
