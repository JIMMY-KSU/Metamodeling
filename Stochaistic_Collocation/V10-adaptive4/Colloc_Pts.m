% function [num C] = Colloc_Pts(q)
clear all; close all; clc;
d = 2;
k = 4;
q = d+k;

index = 1;
nodes = zeros(65,d);
for n = 1:k
    i = compute_i(d,n);
    m = compute_m(i);
%     x{n} = grid_pts(i);
    x{n} = compute_x2(i,m);
    for m = 1:size(x{n},1)
        nodes(index,:) = x{n}(m,:);
        index = index+1;
    end
end
nodes = unique(nodes, 'rows');
plot(nodes(:,1),nodes(:,2),'.')

i = compute_i(d,k);
m = compute_m(i);
x = compute_x(i,m);
plot(x(:,1),x(:,2),'.')

for l = 1:d
    for n = 1:k
        for j = 1:m(k,l)
            if m(n,l) == 1
                Y(j,l) = 0.5;
            else
                Y(j,l) = (j-1)/(m(n,l)-1);
            end
        end
    end
end

n = 1;
for p = 1:q-1
    x = 1;
    for j = 1:m(p,1)
        if m(p,1) == 1 && j == 1
            x(j) = 0;
        else
            x(j) = (j-1)/(m(p,1)-1);
        end
    end
    y = 1;
    for j = 1:m(p,2)
        if m(p,2) == 1 && j == 1
            y(j) = 0;
        else
            y(j) = (j-1)/(m(p,2)-1);
        end
    end
    for j = 1:length(x)
        for p = 1:length(y)
            pts(n,1) = x(j);
            pts(n,2) = y(p);
            n = n+1;
        end
    end
end

C   = unique(pts,'rows');
num = size(C,1);
plot(C(:,1),C(:,2),'.')