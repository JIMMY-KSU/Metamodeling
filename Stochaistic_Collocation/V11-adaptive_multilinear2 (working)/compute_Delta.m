function Delta = compute_Delta(d, k, x, y, w)
for i = 1:k
    val_i = compute_i2(d,i-1);
    Delta(i) = 0;
    for q = 1:size(val_i,1)
        lval = i;
        a(1:d) = inf;
        clear num_pts;
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
                        = compute_basis(val_i(q,l),x{val_i(q,l)}(m,l),y(l));
                end
                n = n+m*prod(bounds{2});
            end
        end
        [~, indx] = ismember(pnt,x{lval},'rows');
        for m = 1:size(indx,1)
            if indx(m) ~= 0
                Delta(i) = Delta(i) + w{lval}(indx(m))*prod(a(m,:));
            end
        end
    end
end