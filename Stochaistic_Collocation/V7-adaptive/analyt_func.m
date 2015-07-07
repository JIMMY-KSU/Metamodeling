function Y = analyt_func(x, y, n)

if n == 1
    Y = 1/(abs(0.3-x^2-y^2)+0.1);
elseif n == 2
    C  = 16*sqrt(0.4)/(log((sqrt(0.3)+sqrt(0.4))/(sqrt(0.4)-sqrt(0.3))));
    C1 = 16*sqrt(0.2)/(log((sqrt(0.3)-sqrt(0.2))/(sqrt(0.3)+sqrt(0.2))));
    XY = sqrt(x^2+y^2);
    if (XY <= 0.3^0.5)
        Y = C /(2*sqrt(0.4))*log(abs((XY+sqrt(0.4))/(XY-sqrt(0.4))));
    else
        Y = C1/(2*sqrt(0.2))*log(abs((XY-sqrt(0.2))/(XY+sqrt(0.2))));
    end
elseif n == 3
    x = (x+1)/2*(max1-min1)+min1;
    y = (y+1)/2*(max2-min2)+min2;
    C  = 16*sqrt(0.4)/(log((sqrt(0.3)+sqrt(0.4))/(sqrt(0.4)-sqrt(0.3))));
    C1 = 16*sqrt(0.2)/(log((sqrt(0.3)-sqrt(0.2))/(sqrt(0.3)+sqrt(0.2))));
    XY = sqrt(x^2+y^2);
    if (XY <= 0.3^0.5)
        Y = C /(2*sqrt(0.4))*log(abs((XY+sqrt(0.4))/(XY-sqrt(0.4))))+0.5*rand(1);
    else
        Y = C1/(2*sqrt(0.2))*log(abs((XY-sqrt(0.2))/(XY+sqrt(0.2))))+0.5*rand(1);
    end
elseif n == 5
    x = (x+1)/2*(max1-min1)+min1;
    y = (y+1)/2*(max2-min2)+min2;
    Y = 5*exp(-500*((x-0.3)^2+(y-0.7)^2))+0.2*sin(2*pi*x)*sin(2*pi*y);
elseif n == 6
    x   = (x+1)/2*(max1-min1)+min1;
    y   = (y+1)/2*(max2-min2)+min2;
    
    kx1 = (2*pi)/(max1-min1);
    ky1 = (2*pi)/(max2-min2);
    kx2 = (2*pi)/(max1-min1)/5;
    ky2 = (2*pi)/(max2-min2)/5;
    kx3 = (2*pi)/(max1-min1)/10;
    ky3 = (2*pi)/(max2-min2)/10;
    A   = ones(3,1);
%     A(1)= rand(1); A(2) = rand(1); A(3) = rand(1);

    Y   = A(1)*sin(kx1*x)*cos(ky1*y) + A(2)*sin(kx2*x)*cos(ky2*y)...
        + A(3)*sin(kx3*x)*cos(ky3*y)...
        + heaviside(x-0.75) + heaviside(y-0.5 + eps);
end