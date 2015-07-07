clear all; close all ; clc;

test_pts = 100;

eq = 6;

if eq == 1 %Boiko
    range = [100 10000; 0 3];
    f = @(rep,map) (24.0./rep+0.38+4.0./sqrt(rep))*(1.0+exp(-0.43./(map.^4.67)));
elseif eq == 2 %Feng
    range = [0 1000; 0 10];
    infty = @(Re) 24/Re*(1+Re^(2/3)/6);
    zero  = @(Re) 48/Re*(1+2.21/sqrt(Re)-2.14/Re);
    f = @(Re,l) (8/Re*(3*l+2)/(l+1)*(1+0.05*(3*l+2)/(l+1)*Re) -...
        (3*l+2)/(l+1)*Re*log(Re))*(Re<=5) +...
        (4/(l+2)*17*Re^-(2/3)+(l-2)/(l+2)*infty(Re))*...
        (l>2 && Re>5 && Re<=1000) +...
        ((2-l)/2*zero(Re)+4*l/(6+l)*17*Re^(-2/3))*(l<=2 && Re>5 && Re<=1000);
elseif eq == 3
    range = [1 10000; 0 4];
    
    Td = 1; %Particle temperature
    Tc = 1; %Fluid temperature
    k  = .331; %Specific heat ratio
    Cd0 = @(Re) 24/Re; %Drag coefficient for Ma = 0
    h   = @(Ma) 5.6/(1+Ma)+1.7*sqrt(Td/Tc);
    g   = @(Re) (1+Re*(12.278+0.548*Re))/(1+11.278*Re);
    
    f = @(Re,Ma) 2 + (Cd0(Re)-2)*exp(-3.07*sqrt(k)*g(Re)*Ma/Re)...
        + h(Ma)/(sqrt(k)*Ma)*exp(-Re/(2*Ma));
elseif eq == 5
    range = [1 1000; 0 4];
    
    C   = @(Re,Ma) 1+Re^2/(Re^2+100)*exp(-0.225/Ma^2.5);
    xsi = @(Kn) 1.177+0.177*(0.851*Kn^1.16-1)/(0.851*Kn^1.16+1);
    
    f = @(Re,Ma,k,Kn) 24/Re*k*(1+0.15*(k*Re)^0.687)*xsi(Kn)*C(Re,Ma);
elseif eq == 6 %Loth
    range = [100 10000; 0 .01];
    kn = 10;
    Cm = @(Ma) (5/3+2/3*tanh(3*log(Ma+0.1)))*(Ma<=1.45) + ...
        (2.044+0.2*exp(-1.8*(log(Ma/2))^2))*(Ma>1.45);
    Gm = @(Ma) (1-1.525*Ma^4)*(Ma<0.89) + ...
        (0.0002+0.0008*tanh(12.77*(Ma-2.02)))*(Ma>=0.89);
    Hm = @(Ma) 1-0.258*Cm(Ma)/(1+514*Gm(Ma));
    fk = @(kn) (1+kn*(2.514+0.8*exp(-0.55/kn)))^-1;
    Ck = @(Re) 24/Re*(1+0.15*Re^0.687)*fk(kn);
    Cf = @(Re) (0.5+0.0169*sqrt(Re))^-1;
    f  = @(Re,Ma) (24/Re*(1+0.15*Re^(0.687))*Hm(Ma) + ...
        0.42*Cm(Ma)/(1+42500*Gm(Ma)/(Re^1.16)))*(Re>45) +...
        (Ck(Re)/(1+Ma^4)+(Ma^4*Cf(Re))/(1+Ma^4))*(Re<=45);
elseif eq == 7 %Tong
    range = [0 1000; 0.0001 .1]; Ma_num = 1;
    kn  = 10;
    Cm  = @(Ma) (5/3+2/3*tanh(3*log(Ma+0.1)))*(Ma<=1.45) + ...
        (2.044+0.2*exp(-1.8*(log(Ma/2))^2))*(Ma>1.45);
    Gm  = @(Ma) (1-1.525*Ma^4)*(Ma<0.89) + ...
        (0.0002+0.0008*tanh(12.77*(Ma-2.02)))*(Ma>=0.89);
    Hm  = @(Ma) 1-0.258*Cm(Ma)/(1+514*Gm(Ma));
    fk  = @(kn) (1+kn*(2.514+0.8*exp(-0.55/kn)))^-1;
    Ck  = @(Re) 24/Re*(1+0.15*Re^0.687)*fk(kn);
    Cf  = @(Re) (0.5+0.0169*sqrt(Re))^-1;
    Cda = @(Re,Ma) (24/Re*(1+0.15*Re^(0.687))*Hm(Ma) + ...
        0.42*Cm(Ma)/(1+42500*Gm(Ma)/(Re^1.16)))*(Re>45) +...
        (Ck(Re)/(1+Ma^4)+(Ma^4*Cf(Re))/(1+Ma^4))*(Re<=45);
    
    f = @(Re,Ma,alpha) Cda(Re,Ma) + 0.5048*alpha*(1+34.8/Re^(0.5707))^4 +...
        .9858*alpha*(1+34.8/Re^(0.5707));
end

exact = zeros(test_pts, test_pts);
for i = 1:test_pts
    for j = 1:test_pts
        R(i) = range(1,1) + (range(1,2)-range(1,1))*(i-1)/(test_pts-1);
        M(j) = range(2,1) + (range(2,2)-range(2,1))*(j-1)/(test_pts-1);
        exact(i,j) = f(R(i),M(j));
    end
end

figure(1)
surf(M,R,exact, 'EdgeColor','none')
if eq == 3
    set(gca, 'yscale', 'log')
end
ylabel('Re')
if eq == 1 || eq == 3
    xlabel('Ma')
elseif eq == 2
    xlabel('\lambda')
elseif eq == 6
    xlabel('\alpha')
    set(gca, 'xscale', 'log')
    set(gca, 'yscale', 'log')
end

set(gca, 'FontSize', 24);
set(findall(gcf,'type','text'),'fontSize',24,'fontWeight','bold')
axis([range(2,1) range(2,2) range(1,1) range(1,2) 0 max(max(exact))])

figure(2)
contourf(M,R,exact, 'EdgeColor','none')
if eq == 3
    set(gca, 'yscale', 'log')
end
ylabel('Re')
if eq == 1 || eq == 3
    xlabel('Ma')
elseif eq == 2
    xlabel('\lambda')
elseif eq == 7
    xlabel('\alpha')
    set(gca, 'xscale', 'log')
    set(gca, 'yscale', 'log')
end
set(gca, 'FontSize', 24);
set(findall(gcf,'type','text'),'fontSize',24,'fontWeight','bold')
colorbar