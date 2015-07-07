function z = compute_z(f, x)

for j = 1:size(x,1)
    var_vals  = mat2cell(x(j,:), 1, ones(1,size(x,2)));
    z(j,1) = feval(f, var_vals{:});
end
end