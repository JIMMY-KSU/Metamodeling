function results = Smolyak_func(q, d, f, range, reltol, abstol)
% q     = number of dimensions plus level of interpolation
% d     = number of dimensions
% coord = coordinates of desired output
% f     = function (handle) being interpolated
% range = min and max of each dimension

% Optional variations
nmin   = 2;                  % minimum levels

% Initialize variables
nmaxprev = 0;
zmin     =  inf;
zmax     = -inf;
levelseq = [];
success  = 0;
accuracy = inf;
npoints  = 0;

for k = 0:q-d
    % Error term
    maxsurplus = 0;
    % calculate the values of m (the current levels of interpolation)
    levelseq = compute_i(d,k);
    % calculate the grid points for the currect level on 0<d<1
    x{k+1} = grid_pts(levelseq);
    % Rescale sparse grid to actual range
    for l = 1:d
        inputs{k+1}(:,l) = range(l,1)+(range(l,2)-range(l,1)).*x{k+1}(:,l);
    end
    v = inputs{k+1};
    % calculate function values at the grid points
    for i = 1: length(v(:,1))
        var_vals       = mat2cell(v(i,:), 1, ones(1,d));
        func_vals(i,1) = feval(f, var_vals{:});
    end
    z{k+1} = func_vals;
    
    temp= min(z{1,k+1}(:));
    if temp < zmin
        zmin = temp;
    end
    temp = max(z{1,k+1}(:));
    if temp > zmax
        zmax = temp;
    end
    if k > 0
        nsurpluses = size(x{k+1},1);
        ip = zeros(nsurpluses, 1);
        for m = 0:k-1
            oldlevelseq = compute_i(d,m);
            ip = ip + spcmpvalscc(d, z{1,m+1}, x{k+1}, ...
                levelseq, oldlevelseq);
        end
        z{k+1} = z{k+1} - ip;
        
        maxsurplus = max(abs(z{1,k+1}(:)));
        
        % compute relative accuracy
        if all(zmax-zmin) > 0
            accuracy = max(maxsurplus/(zmax-zmin));
        else
            accuracy = inf;
        end
        npoints = npoints + size(x{k+1},1);
        
        % break if desired relative accuracy is reached, of if desired
        % absolute tolerance is reached, but only if the minimum number
        % of levels have been computed.
        if accuracy <= reltol || max(maxsurplus) <= abstol
            if k >= nmin
                success = 1;
                fprintf(['The error estimate of ', num2str(accuracy), ...
                    ' is below the required tolerance of ', ...
                    num2str(reltol), ', so the program exited at ', int2str(k), ' levels.\n']);
                break;
            end
        end
    end
end
% Display a warning if the error tolerance is not met
if ~success
    warning(['The error estimate, ', num2str(accuracy), ', is still above the ',...
			' error tolerance of ', num2str(reltol), '.']);
end
results.npoints  = npoints+1;
results.w        = z;
results.accuracy = accuracy;
