function [w x z m] = Initialize(d, f)

for i = 1:3
    m{i} = compute_m(i);
    x{i} = compute_x(i, m{i});
    z{i} = feval(f, x{i});
end
% Find the second refinement level interpolation of the third level pts.
for k = 1:2
    for p = 1:length(x{k})
        for i = 1:2
            a{i} = compute_basis(i, m{i}, x{i}, x{3}(p));
            U(i,1) = 0;
            U(i) = sum(a{i}.*z{i});
        end
        
        Delta = zeros(2,1);
        for i = 1:2
            if i == 1
                Delta(i) = U(i);
            else
                Delta(i) = U(i) - U(i-1);
            end
        end
        V{k}(p,1) = 0;
        for i = 1:2
            V{k}(p) = V{k}(p) + Delta(i);
        end
        w{k}(p,1) = z{k+1}(p)-V{k}(p);
    end
end