function z = Smolyak_func_d(q, d, y, f)

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
    % ????
    maxsurplus = 0;
    % calculate the values of m (the current levels of interpolation)
    levelseq = calc_m(k,d);
    % calculate the grid points for the currect level on 0<d<1
    x{k+1} = grid_pts(levelseq);
    % calculate function values at the grid points
    z{k+1} = feval(f, x{k+1}); %remember to scale with the range in here
    
    [z(1,k+1),x{k+1}] = ...
        spevalf(gridgen, f, levelseq, d, [], range, varpos, ...
        vectorized,1,functionArgType,val{:});
    if strcmpi(keepFunctionValues, 'on')
        y(1,k+1) = z(:,k+1);
    end
    
    fevalTime = fevalTime + etime(clock,t0);
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
        t0 = clock;
        ip = zeros(nsurpluses, 1);
        for m = uint8(0):k-1
            oldlevelseq = spgetseq(m,d,options);
            ip = ip + feval(ipmethod, d, z{1,m+1}, x{k+1}, ...
                levelseq, oldlevelseq);
        end
        z{1,k+1} = z{1,k+1} - ip;
        surplusCompTime = surplusCompTime + etime(clock,t0);
    end
    
    if strcmpi(keepGrid, 'on')
        % Rescale sparse grid to actual range
        for l = 1:d
            x{k+1}(:,l) = range(l,1)+(range(l,2)-range(l,1)).*x{k+1}(:,l);
        end
    end
    
    maxsurplus = max(abs(z{1,k+1}(:)));
    
    if k > 0
        % compute relative accuracy
        if all(zmax-zmin) > 0
            accuracy = max(maxsurplus./(zmax-zmin));
        else
            accuracy = inf;
        end
        
        if strcmpi(gridtype, 'chebyshev')
            z{1,k+1} = reordervals(z{1,k+1},levelseq);
        end
        
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