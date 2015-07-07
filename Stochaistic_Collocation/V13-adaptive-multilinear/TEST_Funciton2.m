clear all; close all ; clc;

test_pts = 100;

func = 6;

if func == 1% Smooth harmonic function
    range = [0 1;0 1];
    f = @(y,x) sin(2*pi.*x).*cos(4*pi.*y)+2;
elseif func == 2% Shifted smooth harmonic function
    range = [0 1;0 1];
    f = @(y,x) sin(2*pi.*x+0.25).*cos(4*pi.*y+0.5)+2;
elseif func == 3% C1 function
    range = [0 1;0 1];
    f = @(x,y) abs(16*sqrt(0.4)/log(abs((sqrt(0.3)+sqrt(0.4))/...
        (sqrt(0.3)-sqrt(0.4))))/(2*sqrt(0.4))*log(abs((sqrt(x.^2+y.^2)...
        +sqrt(0.4))./(sqrt(x.^2+y.^2)-sqrt(0.4))))).^(sqrt(x.^2+y.^2)...
        <=sqrt(0.3))+abs(16*sqrt(0.2)/log(abs((sqrt(0.3)-sqrt(0.2))...
        /(sqrt(0.3)+sqrt(0.2))))/(2*sqrt(0.2))*log(abs((sqrt(x.^2+y.^2)...
        -sqrt(0.2))./(sqrt(x.^2+y.^2)+sqrt(0.2))))).^(sqrt(x.^2+y.^2)...
        >sqrt(0.3))-1;
elseif func == 4 % Leaving this open for the heaviside function
    func = 5;
    range = [100 10000; 0.1 3];
    f = @(rep,map) (24.0./rep+0.38+4.0./sqrt(rep))*(1.0+exp(-0.43./...
        (map.^4.67)));
elseif func == 5% Boiko's model
    range = [100 10000;0.1 3];
    f = @(rep,map) (24.0./rep+0.38+4.0./sqrt(rep))*(1.0+exp(-0.43./...
        (map.^4.67)));
elseif func == 6% Loth's model
    range = [100 10000; 0 5];
    kn = 10;
    Cm = @(Ma) (5/3+2/3*tanh(3*log(Ma+0.1)))*(Ma<=1.45) + ...
        (2.044+0.2*exp(-1.8*(log(Ma/2))^2))*(Ma>1.45);
    Gm = @(Ma) (1-1.525*Ma^4)*(Ma<0.89) + ...
        (0.0002+0.0008*tanh(12.77*(Ma-2.02)))*(Ma>=0.89);
    Hm = @(Ma) 1-0.258*Cm(Ma)/(1+514*Gm(Ma));
    fk = @(kn) (1+kn*(2.514+0.8*exp(-0.55/kn)))^-1;
    Ck = @(Re) 24/Re*(1+0.15*Re^0.687)*fk(kn);
    Cf = @(Re) (0.5+0.0169*sqrt(Re))^-1;
    f = @(Re,Ma) (24/Re*(1+0.15*Re^(0.687))*Hm(Ma) + ...
        0.42*Cm(Ma)/(1+42500*Gm(Ma)/(Re^1.16)))*(Re>45) +...
        (Ck(Re)/(1+Ma^4)+(Ma^4*Cf(Re))/(1+Ma^4))*(Re<=45);
elseif func == 7% Tong's model
    range = [100 500; 0.001 0.6];
    kn  = 10; Ma = 1;
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
    
    f = @(Re,alpha) Cda(Re,Ma) + 0.5048*alpha*(1+34.8/Re^(0.5707))^4 +...
        0.9858*alpha*(1+34.8/Re^(0.5707));
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
grid on
hold on
surfl(M, R/1000, exact, 'light')
shading interp
hold off
xlabel('Ma'), ylabel('Re/1000'), zlabel('C_D')
set(gca, 'XTick', 1:5)
set(gca, 'YTick', 2:2:10)


set(gca, 'FontSize', 24);
set(findall(gcf,'type','text'),'fontSize',24,'fontWeight','bold')
axis([range(2,1) range(2,2) range(1,1)/1000 range(1,2)/1000 0 max(max(exact))])

% figure(2)
% contourf(M,R,exact, 'EdgeColor','none')
% 
% set(gca, 'FontSize', 24);
% set(findall(gcf,'type','text'),'fontSize',24,'fontWeight','bold')
% colorbar