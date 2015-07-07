function a = compute_basis(i, m, x, y)
for j = 1:length(x)
    if i == 1
        a(i,1) = 1;
    else
        if abs(y-x(j)) < 1/(m - 1)
            a(j,1) = 1-(m-1)*abs(y-x(j));
        else
            a(j,1) = 0;
        end
    end
end