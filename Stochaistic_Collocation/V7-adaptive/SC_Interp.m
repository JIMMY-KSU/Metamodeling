function ip = SC_Interp(d, vals, range, varargin)

n = size(vals, 2) - 1;

% store the original array shape
orgsize = size(varargin{1});

% Transform multiple parameter inputs to a matrix for fast
% processing; also perform normalization to unit cube.
for k = 1:length(varargin)
    varargin{k} = (varargin{k}(:)-range(k,1))./(range(k,2)-range(k,1));
end
y = [varargin{:}];
	
ninterp = size(y,1);

ip = zeros(ninterp,1);
% do multiple levels at once
for k = 0:n
    % calculate the values of m (the current levels of interpolation)
    levelseq = calc_m(k,d);
    
    ip = ip + spinterpcc(d,vals{1,k+1},y,levelseq);
end
		
% restore original array shape
ip = reshape(ip,orgsize);