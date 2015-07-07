function [w x] = Initialize(min_level, f, d, range)

% Compute grid points and exact values for min_level's
for j = 0:min_level
    i{j+1} = compute_i(d,j);
    x{j+1} = unique(grid_pts(i{j+1}),'rows');
    if j > 0
        x{j+1} = unique([x{j};x{j+1}],'rows');
    end
    z{j+1} = compute_f(f, range, x{j+1});
end
i{min_level+2} = compute_i(d,min_level+1);
x{min_level+2} = unique(grid_pts(i{min_level+2}),'rows');
w{1} = z{1};
% Compute Hierarchical Surpluses for the minimum levels
for k = 1:min_level
    for p = 1:length(x{k+1})
        V{k}(p) = 0;
        Delta = compute_Delta(d,k,x,x{k+1}(p,:),w);
        for i = 1:k
            V{k}(p) = V{k}(p) + Delta(i);
        end
        % Compute error
        w{k+1}(p,1) = z{k+1}(p)-V{k}(p);
    end
end