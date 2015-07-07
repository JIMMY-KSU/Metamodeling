function y = Refine_Grid(temp, x, d)

temp1 = ones(3,d);

y = [];
for r = 1:length(temp(:,1))
    for l = 1:d
        temp1(:,:) = 10;
        if d > 1
            for l2 = [1:l-1 l+1:d]
                for s = 1:length(x)
                    %                         if temp(r,l) == x(s,l)
                    if abs(temp(r,l2) - x(s,l2)) < abs(temp(r,l2) - temp1(1,l2))
                        temp1(1,:) = x(s,:);
                    end
                    if abs(temp(r,l2) - x(s,l2)) <= abs(temp(r,l2) - temp1(2,l2))
                        temp1(2,:) = x(s,:);
                    end
                    temp1(3,:) = temp(r,l2);
                    %                         end
                end
                y = [y; temp1];
            end
        else
            for s = 1:length(x)
                if abs(temp(r) - x(s)) < abs(temp(r) - temp1(1))
                    temp1(1) = x(s);
                end
                if abs(temp(r) - x(s)) <= abs(temp(r) - temp1(2))
                    temp1(2) = x(s);
                end
                temp1(3) = temp(r);
            end
            y = [y; temp1];
        end
    end
end
y = unique(y, 'rows');
