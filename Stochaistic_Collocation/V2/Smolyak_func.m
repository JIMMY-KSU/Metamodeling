function A = Smolyak_func(q, d, y, analyt)

A = 0;
for r = 1:q-1
    i(1) = r;
    for s = q-d+1-i(1):q-i(1)
        if s ~= 0
            i(2) = s;
            
            if i(1) == 1
                m(1) = 1;
            else
                m(1) = 2^(i(1)-1) + 1;
            end
            if i(2) == 1
                m(2) = 1;
            else
                m(2) = 2^(i(2)-1) + 1;
            end
            
            clear x;
            clear a;
            if m(1) == 1
                x(1,1) = 0;
            else
                for j = 1:m(1)
                    x(j,1) = -cos((pi*(j-1))/(m(1)-1));
                end
            end
            if m(2) == 1
                x(1,2) = 0;
                x(2,2) = 2390843092654;
            else
                for j = 1:m(2)
                    x(j,2) = -cos((pi*(j-1))/(m(2)-1));
                end
            end
            
            for j = 1:m(1)
                a(j,1) = Lagrange_Poly(m(1), y(1), x(:,1), j);
            end
            for j = 1:m(2)
                a(j,2) = Lagrange_Poly(m(2), y(2), x(:,2), j);
            end
            
            U = 0;
            for j1 = 1:m(1)
                for j2 = 1:m(2)
                    U = U + analyt_func(x(j1,1), x(j2,2), analyt)...
                        *a(j1,1)*a(j2,2);
                end
            end
            
            A = A + (-1)^(q-sum(i))*nchoosek(d-1, q-sum(i))*U;
        end
    end
end
