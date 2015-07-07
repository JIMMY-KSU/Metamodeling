function C = compute_x2(i, m)
% Currently only 2D, need to scale up to N-Dimensions!!!!!!!!!!

% Initialize variables
d = size(m,2);
k = size(m,1);
q = d + k;
pts = 0.5;

n = 1;
for p = 1:q-2
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