function Delta = compute_Delta2(d, k, x, y, w)
val_i = compute_i2(d,k-1);
Delta = zeros(size(y,1),1);
for p = 1:size(y,1)
    for q = 1:size(val_i,1)
        lval = k;
        a(1:d) = inf;
        clear num_pts indx pnt a;
        for l = 1:d
            num_pts(l) = size(x{val_i(q,l)},1);
        end
        for l = 1:d
            clear bounds;
            bounds{1} = num_pts(1:l-1);
            bounds{2} = num_pts(l+1:d);
            n = 0;
            for j = 1:prod(bounds{1})
                for m = 1:size(x{val_i(q,l)},1)
                    pnt(n+(m-1)*prod(bounds{2})+1:n+m*prod(bounds{2}),l)...
                        = x{val_i(q,l)}(m,l);
                    a(n+(m-1)*prod(bounds{2})+1:n+m*prod(bounds{2}),l)...
                        = compute_basis(val_i(q,l),x{val_i(q,l)}(m,l),y(p,l));
                end
                n = n+m*prod(bounds{2});
            end
        end
        [none, indx] = ismember(pnt,x{lval},'rows');
        for m = 1:size(indx,1)
            if indx(m) ~= 0
                Delta(p) = Delta(p) + w{lval}(indx(m))*prod(a(m,:));
            end
        end
    end
end
