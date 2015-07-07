function Delta = spinterpcc2(d,w,y,i,x)

%Find number of points to be interpolated
ninterp = size(y,1);
%Initialize Delta for all points of interest
Delta   = zeros(ninterp,1);

% Get the total number of levels
nlevels = size(i,1);

%Index contains the index of the resulting array containing all
%Subdomains of the level.
index = 1;

%Compute m_i for all levels
m = compute_m(i);

for kl = 1:nlevels
    for k = 1:ninterp
        a = 1;
        l = 1;
        while l <= d
            %Find location in dimension l where we want interpolated value
            yt = y(k,l);
            
            %Security test if yt is within a valid range.
            if yt < 0  || yt > 1
                if yt < 0, yt = 0; else yt = 1; end
                warning('MATLAB:spinterp:outOfRange', ...
                    'Interpolated point is out of valid range.');
            end
            a = a*sum(compute_basis(i(kl,l), m(kl,l), x{kl}, y).*w{kl});
            l = l+1;
        end
        Delta(k) = Delta(k) + a;
    end
end