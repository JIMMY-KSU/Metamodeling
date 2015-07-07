% function[InputVector,OutDesired,Yout,T,X]=Zabaras81Input(npoints)
clear all; close all; clc
npoints=100;

TimeAxis = zeros(npoints,1);
Y        = zeros(npoints,1);
for i=1:npoints
    TimeAxis(i,1)=(10/(npoints-1))*(i-1);
    Y(i,1)=-1+(2/(npoints-1))*(i-1);
end

n=1;
for i=1:npoints
  %RK4 Starts
  XOld=[0.05+0.2*Y(i,1);0];
  t=0;
  h=0.001;


  while (t<10)
    
    PseudoX=XOld;
    K1=[PseudoX(2);-2*PseudoX(2)-17.5*power(PseudoX(1),3)+7.5*PseudoX(1)];
    PseudoX=XOld+0.5*h*K1;
    K2=[PseudoX(2);-2*PseudoX(2)-17.5*power(PseudoX(1),3)+7.5*PseudoX(1)];
    PseudoX=XOld+0.5*h*K2;
    K3=[PseudoX(2);-2*PseudoX(2)-17.5*power(PseudoX(1),3)+7.5*PseudoX(1)];
    PseudoX=XOld+h*K3;
    K4=[PseudoX(2);-2*PseudoX(2)-17.5*power(PseudoX(1),3)+7.5*PseudoX(1)];
    XNew=XOld + (h/6)*(K1+2*K2+2*K3+K4);
    
    for j=1:npoints
        if((t==TimeAxis(j,1))|((t<TimeAxis(j,1))&&((t+h)>(TimeAxis(j,1)))))
            X(i,j)=XNew(1);
            T(i,j)=t;
            Yout(i,j)=Y(i,1);
            OutDesired(n,1)=XNew(1);
            InputVector(n,1)=Y(i);
            InputVector(n,2)=t;
            n=n+1;
            break
        end     
    end
       
    t=t+h;
    XOld=XNew;
    
%     surf(Y,T,X)
%     pause(0.1)
  end
  %RK4 Ends
  
end

% X=X';
% T=T';
% Yout=Yout';
% 
surfc(Yout,T,X)
