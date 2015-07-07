function m = compute_m(i)
i = i+1;
for l = 1:length(i(1,:))
    for p = 1:length(i(:,l))
        if i(p,l) == 1
            m(p,l) = 1;
        else
            m(p,l) = 2^(i(p,l)-1)+1;
        end
    end
end