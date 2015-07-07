function [L] = Lagrange_Poly(M, y, x, j)

L = 1;
for m = 1:M
    if m ~= j
        L = L*(y-x(m))/(x(j)-x(m));
    end
end