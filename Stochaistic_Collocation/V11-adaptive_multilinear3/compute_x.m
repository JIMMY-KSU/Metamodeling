function x = compute_x(i,m)

for j = 1:m(i)
    if m(i) == 1
        x = 0.5;
    else
        x(j,1) = (j-1)/(m(i)-1);
    end
end