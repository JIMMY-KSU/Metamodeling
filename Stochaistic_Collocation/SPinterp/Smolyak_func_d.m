function z = Smolyak_func_d(q, d, f, range)
% q     = number of dimensions plus level of interpolation
% d     = number of dimensions
% coord = coordinates of desired output
% f     = function (handle) being interpolated
% range = min and max of each dimension

% Optional variations
nmin   = 2;                  % minimum levels
reltol = 1e-2;               % minimum relative tolerance
abstol = 1e-6;               % minimum absolute tolerance

% Precomputed values


% Initialize variables
nmaxprev        = 0;
zmin            =  inf;
zmax            = -inf;
xmin            = zeros(1,d);
xmax            = zeros(1,d);
fevalTime       = 0;
surplusCompTime = 0;
npoints         = 0;
levelseq        = [];
success         = 0;
accuracy        = inf;

for k = 0:q-d
    % Error term
    maxsurplus = 0;
    % calculate the values of m (the current levels of interpolation)
    levelseq = calc_m(k,d);
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
    
    [temp, id] = min(z{1,k+1}(:));
    if temp < zmin
        zmin = temp;
        xmin(1,:) = x{k+1}(id,:);
    end
    [temp, id] = max(z{1,k+1}(:));
    if temp > zmax
        zmax = temp;
        xmax(1,:) = x{k+1}(id,:);
    end
    npoints = npoints + size(x{k+1},1);
    if k > 0
        nsurpluses = size(x{k+1},1);
        ip = zeros(nsurpluses, 1);
        for m = 0:k-1
            oldlevelseq = calc_m(m,d);
%             ip = ip + feval(@spinterpcc, d, z{1,m+1}, x{k+1}, ...
%                 levelseq, oldlevelseq);
            ip = ip + feval(@spcmpvalscc, d, z{1,m+1}, x{k+1}, ...
                levelseq, oldlevelseq);
        end
        z{1,k+1} = z{1,k+1} - ip;
    end
    
    maxsurplus = max(abs(z{1,k+1}(:)));
    
    if k > 0
        % compute relative accuracy
        if all(zmax-zmin) > 0
            accuracy = max(maxsurplus./(zmax-zmin));
        else
            accuracy = inf;
        end
        
%         if strcmpi(gridtype, 'chebyshev')
%             z{1,k+1} = reordervals(z{1,k+1},levelseq);
%         end
        
        % break if desired relative accuracy is reached, of if desired
        % absolute tolerance is reached, but only if the minimum number
        % of levels have been computed.
        if accuracy <= reltol || max(maxsurplus) <= abstol
            success = 1;
            if k >= nmin
                break;
            end
        end
    end
end