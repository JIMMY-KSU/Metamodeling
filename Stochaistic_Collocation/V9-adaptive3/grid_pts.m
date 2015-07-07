function x = grid_pts(i)
% find the grid points corresponding to the m values input

% Get the number of levels
n = size(i,1);

% Get the dimension
d = size(i,2);

% Initialize variables
npoints     = zeros(n,1);
dim         = zeros(d,1);
totalpoints = 0;

for k = 1:n;
	ntemp = 1;
	for l = 1:d
		lev = i(k,l);
		if lev == 0
			continue;
		elseif lev <= 2
			ntemp = ntemp * 2;
		else
			ntemp = ntemp * 2^(lev-1);
		end
	end
	npoints(k) = ntemp;
	totalpoints = totalpoints + ntemp;
end
	
% index contains the index of the resulting array containing all
% subdomains of the level.
index = 1;
	
x = 0.5*ones(totalpoints,d);
	
for kl = 1:n
	c = {};
	ndims = 0;
	for k = 1:d
		% compute the points, scaled to [0,1]
		lev = double(i(kl, k));
		if lev == 0
			continue;
		elseif lev == 1
            ndims = ndims + 1;
            c{ndims} = [0; 1];
        else
            ndims = ndims + 1;
%             c{ndims} = ( ( ( (1:2^(lev-1)) *2 ) -1).*2^(-lev))';
            c{ndims} = ( ( ( (1:2^(lev-1)) *2 ) -1).*2^(-lev))';
        end
        dim(ndims) = k;
    end
    if ndims > 1
        [c{:}] = ndgrid(c{:});
    end
    for k = 1:ndims
		x(index:index+npoints(kl)-1,dim(k)) = c{k}(:);
	end
	index = index + npoints(kl);
end