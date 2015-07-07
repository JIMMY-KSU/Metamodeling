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

i = compute_i(d,nlevels-1);
m = compute_m(i);
Delta = zeros(size(y,1),1);

for k = 1:nlevels
    for l = 1:d
        for j = 1:size(y,1)
            Delta(j) = Delta(j) +...
                sum(compute_basis(i(k,l),m(k,l),x{i(k,l)},y(j,l)).*w{i(k,l)});
        end
    end
end

Delta = reshape(Delta,orgsize);