function [num C] = Colloc_Pts(q)

for p = 1:q-1
    i(p,1) = p;
    i(p,2) = q-p;
end

for p = 1:q-1
    if i(p,1) == 1
        m(p,1) = 1;
    else
        m(p,1) = 2^(i(p,1)-1)+1;
    end
    if i(p,2) == 1
        m(p,2) = 1;
    else
        m(p,2) = 2^(i(p,2)-1)+1;
    end
end

n = 1;
for p = 1:q-1
    x = 1;
    for j = 1:m(p,1)
        if m(p,1) == 1 && j == 1
            x(j) = 0;
        else
            x(j) = -cos(pi*(j-1)/(m(p,1)-1));
            if abs(x(j)) < 1e-15, x(j) = 0; end
        end
    end
    y = 1;
    for j = 1:m(p,2)
        if m(p,2) == 1 && j == 1
            y(j) = 0;
        else
            y(j) = -cos(pi*(j-1)/(m(p,2)-1));
            if abs(y(j)) < 1e-15, y(j) = 0; end
        end
    end
    for j = 1:m(p,1)
        if j == m(p,1) || j == 1
            a(j) = 1/(m(p,1)*(m(p,1)-2));
        else
            sum = 0;
            for g = 1:(m(p,1)-3)/2
                sum = sum + 1/(4*g*g-1)*cos(2*pi*g*(j-1)/(m(p,1)-1));
            end
            a(j) = 2/(m(p,1)-1)*(1-cos(pi*(j-1))/(m(p,1)*(m(p,1)-2)) - sum);
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
num = length(C(:,1));
end