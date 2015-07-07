function m = compute_m(i)

if i == 1
    m = 1;
else
    m = 2^(i-1)+1;
end