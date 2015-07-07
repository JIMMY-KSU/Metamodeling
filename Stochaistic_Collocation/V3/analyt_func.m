function Y = analyt_func(x, y, n)
if n == 1
    Y = cos(1/2*pi*x)*cos(1/2*pi*y);
elseif n == 2
    Y = x^3 + y^3 + 4;
elseif n == 3
    Y = cos(2*pi*x)*cos(2*pi*y);
elseif n == 4
    global max1 min1 max2 min2
    
    x = (x+1)/2*(max1-min1)+min1;
    y = (y+1)/2*(max2-min2)+min2;
    Y = (24.0/x+0.38+4.0/sqrt(x))*(1.0+exp(-0.43/(y^4.67)));
elseif n == 5
    Y = 1/(abs(0.3-x^2-y^2)+0.1);
end