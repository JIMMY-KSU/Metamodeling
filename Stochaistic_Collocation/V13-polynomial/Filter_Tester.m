clear all; close all; clc;

% filtorder = 2; N = 99;
% if (filtorder>0)
%     fa = -log(eps);
%     sigma = exp(-fa*( (0:N)/N ).^filtorder);
%     c = [2; ones(N-1,1); 2];
%     for j=0:N;
%         for i=0:N;
%             F(i+1,j+1)=0;
%             for k=0:N;
%                 F(i+1,j+1)=F(i+1,j+1)+sigma(k+1)./c(k+1).*cos(k*i*pi/N).*cos(k*j*pi/N);
%             end
%             F(i+1,j+1) = F(i+1,j+1).*2./N./c(j+1);
%         end;
%     end;
% end;

h = ['b', 'g', 'r', 'c', 'm', 'y', 'k'];
for filtorder = 2:2:14
    N = 99;
    if (filtorder>0)
        fa = -log(eps);
        sigma = exp(-fa*( (0:N)/N ).^filtorder);
        c = [2; ones(N-1,1); 2];
        for i=0:N;
            F(i+1)=0;
            for k=0:N;
                F(i+1)=F(i+1)+sigma(k+1)./c(k+1).*cos(k*i*pi/N);
            end
        end
    end
    plot(F(1:16),h(filtorder/2)), hold on
end