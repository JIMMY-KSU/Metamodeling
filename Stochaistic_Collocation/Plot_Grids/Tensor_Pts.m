function C = Tensor_Pts(N, k)
% clear all; close all; clc;
% N = 2; k = 5;
% Collocation method: 1-Smolyak (not working), 2-Stroud-3
coll_method = 1; 

% Particle Mach Number input
ma_n   = N+k;
ma = zeros(ma_n,1);

% Particle Reynolds number input
re_n   = N+k;
re = zeros(re_n,1);

for j = 1:ma_n;
    if coll_method == 1
        if ma_n == 1
            ma(j) = 1;
        else
            ma(j) = -cos(pi*(j-1)/(ma_n-1));
%             ma(j) = (j-1)/(ma_n-1);
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
%             re(j) = (j-1)/(re_n-1);
        end
    end
end

n=1;
for j = 1:length(ma)
    for p = 1:length(re)
        pts(n,1) = ma(j);
        pts(n,2) = re(p);
        n = n+1;
    end
end

C = pts;
plot(C(:,1),C(:,2),'.'), set(gca, 'XTickLabelMode', 'manual', 'XTickLabel', []);
set(gca, 'YTickLabelMode', 'manual', 'YTickLabel', []);