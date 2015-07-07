clear all; close all; clc

x{1} = [1 2];
x{2} = [3 4];
x{3} = [5 6 7];

y = [2 4 7; 1 3 3; 1 3 6; 2 5 6];

d = 3;

for l = 1:d
    num_pts(l) = size(x{l},2);
end

for l = 1:d
    clear bounds;
    bounds{1} = num_pts(1:l-1);
    bounds{2} = num_pts(l+1:d);
    n = 0;
    for j = 1:prod(bounds{1})
        for i = 1:size(x{l},2)
            pnt(n+(i-1)*prod(bounds{2})+1:n+i*prod(bounds{2}),l) = x{l}(i);
        end
        n = n+i*prod(bounds{2});
    end
end

[~,indx] = ismember(y,pnt,'rows');