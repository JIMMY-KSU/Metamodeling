function Delta = compute_Delta(d, k, x, y, w)
for i = 1:k
    val_i = compute_i2(d,i-1);
    Delta(i) = 0;
    for q = 1:size(val_i,1)
        lval = i;
        a(1:2)   = inf;
        for j1 = 1:size(x{val_i(q,1)},1)
            pnt(1) = x{val_i(q,1)}(j1,1);
            a(1) = compute_basis(val_i(q,1),pnt(1),y(1));
            for j2 = 1:size(x{val_i(q,2)},1)
                pnt(2) = x{val_i(q,2)}(j2,2);
                [~,indx] = ismember(pnt,x{lval},'rows');
                a(2) = compute_basis(val_i(q,2),pnt(2),y(2));
                if indx ~= 0
                    Delta(i) = Delta(i) + w{lval}(indx)*a(1)*a(2);
                end
            end
        end
        
    end
end