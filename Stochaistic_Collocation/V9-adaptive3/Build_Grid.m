function [x a m w] = Build_Grid(w, x, z, m, max_level, f, error)
n = 1; check = 0;
x_active{1} = x{2};
x_active{2} = x{3};
for k = 2:max_level
    m{k+1} = compute_m(k+1);
    z{k+1} = feval(f, x_active{k});
    for p = 1:length(x_active{k})
        for i = 1:k
            a{i}   = compute_basis(i, m{i}, x{i}, x_active{k}(p));
        end
        
        Delta = zeros(k,1);
        for i = 1:k
            Delta(i,1) = sum(a{i}.*w{i});
        end
        V{k}(p) = 0;
        for i = 1:k
            V{k}(p) = V{k}(p) + Delta(i);
        end
        % Compute error
        w{k+1}(p,1) = z{k+1}(p)-V{k}(p);
        
        x_active{k+1}(n,1) = x_active{k}(p);
        n = n+1;
        % Error Check
        if abs(w{k+1}(p)) > error
            check = 1;
            x_active{k+1}(1,1) = 0;
            num = x_active{k}(p,1) - 2^(1-(k+2));
            if num > 0
                x_active{k+1}(n,1) = num;
                n = n+1;
            end
            num = x_active{k}(p,1) + 2^(1-(k+2));
            if num < 1
                x_active{k+1}(n,1) = num;
                n = n+1;
            end
        end
    end
    x_active{k+1}(n,1) = 1;
    x_active{k+1}      = unique(x_active{k+1});
    x{k+1} = x_active{k};
    n = 2;
    if check
        check = 0;
    else
        disp(k+1);
        break;
    end
end