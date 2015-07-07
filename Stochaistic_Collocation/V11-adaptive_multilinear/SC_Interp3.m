function Delta = SC_Interp3(d, w, range, x, varargin)

% store the original array shape
orgsize = size(varargin{1});
%find number of levels
nlevels = size(w,2);

% Transform multiple parameter inputs to a matrix for fast
% processing; also perform normalization to unit cube.
for k = 1:length(varargin)
    varargin{k} = (varargin{k}(:)-range(k,1))./(range(k,2)-range(k,1));
end
y = [varargin{:}];

for n = 1:nlevels
    i{n} = compute_i2(d,n);
    m{n} = compute_m(i{n});
end
A = zeros(size(y,1),1);

for p = 1:size(y,1)
    Delta = zeros(nlevels,1);
    for l = 1:d
%         for k = 1:size(i,1)
            for n = 1:nlevels
                a{n} = compute_basis(n,m{n},x{n},y(p,l));
%                 Delta(n)  = sum(a{i(k,l)}.*w{i(k,l)});
                Delta(n)  = sum(a{n}.*w{n});
                A(p)      = A(p) + Delta(n);
            end
%         end
    end
end

Delta = reshape(A,orgsize);