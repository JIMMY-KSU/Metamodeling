% function F = cheby_filter(N, filtorder)

% % Initialize grid and set up operators
%   x = -cos(pi*(0:N)/N)';
%   c = [2; ones(N-1,1); 2].*(-1).^(0:N)';
%   X = repmat(x,1,N+1);
%   dX = X-X';
%   D  = (c*(1./c)')./(dX+(eye(N+1)));      % off-diagonal entries
%   D  = D - diag(sum(D'));                 % diagonal entries
% %

% Initialize filter operator
filtorder = 2; N = 99;
if (filtorder>0)
    fa = -log(eps);
    sigma = exp(-fa*( (0:N)/N ).^filtorder);
    c = [2; ones(N-1,1); 2];
    for j=0:N;
        for i=0:N;
            F(i+1,j+1)=0;
            for k=0:N;
                F(i+1,j+1)=F(i+1,j+1)+sigma(k+1)./c(k+1).*cos(k*i*pi/N).*cos(k*j*pi/N);
            end
            F(i+1,j+1) = F(i+1,j+1).*2./N./c(j+1);
        end;
    end;
end;