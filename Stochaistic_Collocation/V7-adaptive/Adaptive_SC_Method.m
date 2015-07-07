clear all; close all; clc;
% Function parameters
name1 = 'X';     name2 = 'Y';
max1  =  1 ;     max2  =  1 ;
min1  =  0 ;     min2  =  0 ;
range = [min1 max1; min2 max2];
% Function
f = @(x,y) 1./(abs(0.3-x.^2-y.^2)+0.1);
% Number of points to be interpolated in postprocessing
test_pts = 100;
% Number of dimensions
d = 2;
% Max level
k = 3;
% minimum relative tolerance
reltol = 1e-3;
% minimum absolute tolerance
abstol = 1e-8;
% adaptivity tolerance
eps = 0.1;
err = zeros(k+1,5);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
levelseq = calc_m(0,d);
x{1}     = grid_pts(levelseq);

levelseq = calc_m(1,d);
x{2}     = grid_pts(levelseq);
x_active = x{2};
for q = d+2:d+k
    m = q-d;
    % find grid points at next level
    n = 1;
    for i = 1:length(x_active(:,1))
        check(1:d) = 0;
        check(1)   = 1;
        dim        = 1;
        for p = 1:d
            for l = 1:d
                if check(l)
%                     if ~(temp(i,1) < 0 || temp(i,1) > 1 || temp(i,2) < 0 || temp(i,2) > 1)
                    temp(n  ,l) = x_active(i,l) + 1/2^(m);
                    temp(n+1,l) = x_active(i,l) - 1/2^(m);
                    check(l) = 0;
%                     end
                else
                    temp(n  ,l) = x_active(i,l);
                    temp(n+1,l) = x_active(i,l);
                end
            end
            if dim <= d
                dim = dim+1;
                check(dim) = 1;
            end
            n = n+d;
        end
    end
    n = 1;
    for i = 1:length(temp(:,1))
        if ~(temp(i,1) < 0 || temp(i,1) > 1 || temp(i,2) < 0 || temp(i,2) > 1)
            temp2(n,:) = temp(i,:);
            n = n+1;
        end
    end
    x{m+1} = unique(temp2, 'rows');
    
%     for i = 1:length(temp(:,1))
%         if temp(i,1) < 0
%             temp(i,1) = 1/2^(m+1);
%         elseif temp(i,1) > 1
%             temp(i,1) = 1 - 1/2^(m+1);
%         elseif temp(i,2) < 0
%             temp(i,2) = 1 - 1/2^(m+1);
%         elseif temp(i,2) > 1
%             temp(i,2) = 1/2^(m+1);
%         end
%     end
% 
%     x{m+1} = unique(temp, 'rows');
    
    
    % interpolate values for next level using current level
    z        = Smolyak_func(q, d, f, range, reltol, abstol);
    vec_smol = SC_Interp(d, z.z, range, x{m+1}(:,1), x{m+1}(:,2));
    % evaluate function at next level points
    for l = 1:d
        v(:,l) = range(l,1)+(range(l,2)-range(l,1)).*x{q-d+1}(:,l);
    end
    for i = 1: length(v(:,1))
        var_vals       = mat2cell(v(i,:), 1, ones(1,d));
        func_vals(i,1) = feval(f, var_vals{:});
    end
    z.z{k+1} = func_vals;
    w = abs(z.z{k+1} - vec_smol);
    
    n = 1;
    for i = 1:length(w)
        if w(i) > eps
%             x_active(n,1:d) = x{q-d+1}(i,1:d);
            n = n+1;
        end
    end
     clear v; clear temp; clear temp2;
end
