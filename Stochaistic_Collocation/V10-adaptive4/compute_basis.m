function a = compute_basis(i, m, x, y)

% for j = 1:m(i)
for j = 1:size(x,1)
    if i == 1
        a(i,1) = 1;
    else
        if abs(y-x(j)) < 1/(m(i) - 1)
            a(j,1) = 1-(m(i)-1)*abs(y-x(j));
        else
            a(j,1) = 0;
        end
    end
end