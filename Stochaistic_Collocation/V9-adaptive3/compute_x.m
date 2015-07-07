function pts = compute_x(m)

%Currently only 2D NEED TO MAKE THIS N-DIMENSIONAL

% Number of levels
n = size(m,1);
% Number of dimensions
d = size(m,2);

for lend = 1:d
    k = 1;
    for p = 1:n
        for j = 1:m(p,lend)
            if m(p,lend) == 1
                x(j,lend) = 0;
            else
                x(j,lend) = (j-1)/(m(p,lend)-1);
                if abs(x(j,lend)) < 1e-15, x(j,lend) = 0; end
            end
        end
    end
end

k = 1;
% for q = 1:n
    for j = 1:size(x,1)
        for p = 1:size(x,1)
            pts(k,1) = x(j,1);
            pts(k,2) = x(p,2);
            k = k+1;
        end
    end
% end

C = unique(pts,'rows');



% function x = compute_x(i,m)
% 
% for j = 1:m(i)
%     if m(i) == 1
%         x = 0.5;
%     else
%         x(j,1) = (j-1)/(m(i)-1);
%     end
% end