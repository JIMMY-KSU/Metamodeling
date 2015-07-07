function a = compute_basis(i, m, x, y)

for j = 1:size(x,1)
    if j == 1
        a(j,1) = 1;
    else
        if abs(y-x(j,1)) < 1/(m(i,1) - 1)
            a(j,1) = 1-(m(i,1)-1)*abs(y(1,1)-x(j,1));
        else
            a(j,1) = 0;
        end
    end
end