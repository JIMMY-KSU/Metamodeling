function m = compute_m(i)

for j = 1:i
    if j == 1
        m(j,1) = 1;
    else
        m(j,1) = 2^(j-1)+1;
    end
end