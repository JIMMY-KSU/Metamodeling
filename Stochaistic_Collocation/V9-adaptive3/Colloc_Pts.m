function C = Colloc_Pts(m)

%Currently only 2D NEED TO MAKE THIS N-DIMENSIONAL

% Number of levels
n = size(m,1);
% Number of dimensions
d = size(m,2);

for lend = 1:d
    for k = 1:length(m(:,lend))
        x = 1;
        for j = 1:m(k,1)
            if m(k,1) == 1 && j == 1
                x(j) = 0;
            else
                x(j) = (j-1)/(m(k,1)-1);
                if abs(x(j)) < 1e-15, x(j) = 0; end
            end
        end
    end
end

for j = 1:length(x(:,1))
    for k = 1:length(x(:,2))
        pts(n,1) = x(j,1);
        pts(n,2) = x(k,2);
        n = n+1;
    end
end
C = unique(pts,'rows');



% n = 1;
% for p = 1:q-1
%     x = 1;
%     for j = 1:m(p,1)
%         if m(p,1) == 1 && j == 1
%             x(j) = 0;
%         else
%             x(j) = -cos(pi*(j-1)/(m(p,1)-1));
%             if abs(x(j)) < 1e-15, x(j) = 0; end
%         end
%     end
%     y = 1;
%     for j = 1:m(p,2)
%         if m(p,2) == 1 && j == 1
%             y(j) = 0;
%         else
%             y(j) = -cos(pi*(j-1)/(m(p,2)-1));
%             if abs(y(j)) < 1e-15, y(j) = 0; end
%         end
%     end
%     for j = 1:length(x)
%         for p = 1:length(y)
%             pts(n,1) = x(j);
%             pts(n,2) = y(p);
%             n = n+1;
%         end
%     end
% end