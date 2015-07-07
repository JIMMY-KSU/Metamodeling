function Delta = SC_Interp2(d, w, range, x, varargin)

n = size(w, 2) - 1;

% store the original array shape
orgsize = size(varargin{1});

% Transform multiple parameter inputs to a matrix for fast
% processing; also perform normalization to unit cube.
for k = 1:length(varargin)
    varargin{k} = (varargin{k}(:)-range(k,1))./(range(k,2)-range(k,1));
end
y = [varargin{:}];
	
ninterp = size(y,1);

Delta = zeros(ninterp,1);
% do multiple levels at once
for k = 0:n
    % calculate the values of i (the current levels of interpolation)
    levelseq = compute_i(d,k);
    % compute the values of Delta
    Delta = Delta + spinterpcc2(d,w,y,levelseq,x);
end
		
% restore original array shape
Delta = reshape(Delta,orgsize);