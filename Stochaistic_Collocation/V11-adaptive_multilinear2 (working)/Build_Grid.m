function [w x] = Build_Grid(w, min_level, max_level, f, d, error, range)

% Compute grid points and exact values for min_level's
for j = 0:min_level
    i{j+1} = compute_i(d,j);
    x{j+1} = unique(grid_pts(i{j+1}),'rows');
    if j > 0
        x{j+1} = unique([x{j};x{j+1}],'rows');
    end
    z{j+1} = compute_f(f, range, x{j+1});
end
% Use heirarchical surpluses to iteratively refine the grid up to max_level
% or error
check = 0;
x_active{min_level-1} = x{min_level  };
x_active{min_level  } = x{min_level+1};
for k = min_level:max_level-1
    z{k+1} = compute_f(f, range, x_active{k});
    temp   = [];
    y      = grid_pts(compute_i(d,k+1));
    for p = 1:length(x_active{k})
        V{k}(p) = 0;
        Delta = compute_Delta(d, k, x, x_active{k}(p,:), w);
        for i = 1:k
            V{k}(p) = V{k}(p) + Delta(i);
        end
        % Compute error
        w{k+1}(p,1) = z{k+1}(p)-V{k}(p);
        
        % Find values at this level to refine around
        if abs(w{k+1}(p)) >= error
            check = 1;
            temp = [temp; x_active{k}(p,:)];
        end
    end
    if check
        temp1 = 10*ones(2,d);
        x_active{k+1} = x_active{k};
%         x_active{k+1} = [];
        for r = 1:size(temp,1)
            if d == 1
                for s = 1:size(y,1)
                    if abs(temp(r,1) - y(s,1)) <  abs(temp(r,1) - temp1(1,1))
                        temp1(1) = y(s);
                    end
                    if abs(temp(r,1) - y(s,1)) <= abs(temp(r,1) - temp1(2,1))
                        temp1(2) = y(s);
                    end
                end
                x_active{k+1} = [x_active{k+1}; temp1];
            else
                for l = 1:d
                    for l2 = [1:l-1 l+1:d]
                        temp1(:,:) = 10;
                        for s = 1:size(y,1)
                            if y(s,l) == temp(r,l)
                            if abs(temp(r,l2) - y(s,l2)) <  abs(temp(r,l2) - temp1(1,l2))
                                temp1(1,:) = y(s,:);
                            end
                            if abs(temp(r,l2) - y(s,l2)) <= abs(temp(r,l2) - temp1(2,l2))
                                temp1(2,:) = y(s,:);
                            end
                            end
                        end
                        x_active{k+1} = [x_active{k+1}; temp1];
                    end
                end
            end
        end
        x_active{k+1} = unique(x_active{k+1}, 'rows');
        x{k+1}        = x_active{k};
        check = 0;
    else
        disp(k+1);
        break;
    end
end