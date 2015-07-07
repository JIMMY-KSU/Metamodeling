function x = compute_x(L,m)

for i = 0:L
    if i == 0
        x{i+1} = 0.5;
    elseif i == 1
        x{i+1}(1) = 0;
        x{i+1}(2) = 1;
    else
        for j = 1:m(i)
            sum = 0;
            for k = 0:i
                sum = sum + m(k+1)-1;
            end
            x{i+1}(j) = (2*j-1)/(sum);
        end
    end
end