function m = compute_m(i)

d = size(i,2);
k = size(i,1);

for l = 1:d
    for n = 1:k
        j = i(n,l);
        if j == 1
            m(n,l) = 1;
        else
            m(n,l) = 2^(j-1)+1;
        end
    end
end