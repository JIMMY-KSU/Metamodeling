function X = Zabaras81Smol(npoints)
% clear all; close all; clc;
% [num_pts npoints] = Colloc_Pts(3);
% max1=1; min1=-1; max2=10; min2=0;

global max1 min1 max2 min2

Y = min1 + (0.5*(npoints(:,1)+1))*(max1-min1);
T = min2 + (0.5*(npoints(:,2)+1))*(max2-min2);

h = 0.0001;
for i=1:length(npoints(:,1))
  %RK4 Starts
  XOld=[0.05+0.2*Y(i);0];
  t = 0;

  while (t < max2+1)
    
    PseudoX=XOld;
    K1=[PseudoX(2);-2*PseudoX(2)-17.5*power(PseudoX(1),3)+7.5*PseudoX(1)];
    PseudoX=XOld+0.5*h*K1;
    K2=[PseudoX(2);-2*PseudoX(2)-17.5*power(PseudoX(1),3)+7.5*PseudoX(1)];
    PseudoX=XOld+0.5*h*K2;
    K3=[PseudoX(2);-2*PseudoX(2)-17.5*power(PseudoX(1),3)+7.5*PseudoX(1)];
    PseudoX=XOld+h*K3;
    K4=[PseudoX(2);-2*PseudoX(2)-17.5*power(PseudoX(1),3)+7.5*PseudoX(1)];
    XNew=XOld + (h/6)*(K1+2*K2+2*K3+K4);
    
    if (t == T(i))
        X(i,1) = Y(i);
        X(i,2) = T(i);
        X(i,3) = XNew(1);
        break
    end
    
    t=t+h;
    if t > T(i)
        t = T(i);
    end
    XOld=XNew;

  end
  %RK4 Ends
  
end

X(:,1:2) = npoints;


% figure(1)
% scatter3(X(:,1),X(:,2),X(:,3))