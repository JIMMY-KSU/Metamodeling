function Y = analyt_func(x, y, n)
if n == 1
    Y = cos(1/2*pi*x)*cos(1/2*pi*y);
elseif n == 2
    Y = x^3 + y^5+4;
elseif n == 3
    Y = cos(2*pi*x)*cos(2*pi*y);
end