function z = compute_f(f, range, x)

for l = 1:size(x,2)
    x_test(:,l) = range(l,1) + (range(l,2)-range(l,1))*x(:,l);
end


for j = 1:size(x,1)
    var_vals  = mat2cell(x_test(j,:), 1, ones(1,size(x,2)));
    z(j,1) = feval(f, var_vals{:});
end
end