close all; clc

label_x = 'X';
label_y = 'Y';
label_z = 'Drag (Adaptive SC)';

A = zeros(size(test_pts,1),1);
for i = 1:8,size(w2,1)-1;
    A = A + Delta{i};
end

n = 1;
for i = 1:num_test_pts(1)
    for j = 1:num_test_pts(2)
        Z(i,j)     = A(n);
        exact(i,j) = compute_f(f,range,test_pts(n,:));
        n = n+1;
    end
end
% Z = Z';
nodes = [];
for i = 1:8,size(x,2);
    nodes = [nodes;x{i}];
end
nodes(:,1) = range(1,1) + nodes(:,1)*(range(1,2)-range(1,1));
nodes(:,2) = range(2,1) + nodes(:,2)*(range(2,2)-range(2,1));
figure(1)
plot(nodes(:,2),nodes(:,1),'.'), xlabel(label_x), ylabel(label_y)
     title('Interpolation Nodes (Adaptive SC)')

figure(2)
contourf(range(1,1):(range(1,2)-range(1,1))...
    /(num_test_pts(1)-1):range(1,2),...
    range(2,1):(range(2,2)-range(2,1))...
    /(num_test_pts(2)-1):range(2,2),...
    Z)
    title('Contour of the Reconstructed Hypersurface (Adaptive SC)')
    xlabel(label_x),ylabel(label_y), colorbar
    
figure(3)
mesh(range(1,1):(range(1,2)-range(1,1))...
    /(num_test_pts(1)-1):range(1,2),...
    range(2,1):(range(2,2)-range(2,1))...
    /(num_test_pts(2)-1):range(2,2),...
    Z)
    title('Reconstructed Hypersurface (Adaptive SC)')
    xlabel(label_x),ylabel(label_y), zlabel(label_z), colorbar
    
figure(4)
mesh(range(2,1):(range(2,2)-range(2,1))...
    /(num_test_pts(2)-1):range(2,2),...
    range(1,1):(range(1,2)-range(1,1))...
    /(num_test_pts(1)-1):range(1,2),...
    Z), title('Exact'), hold on,
    plot3(nodes(:,2),nodes(:,1),compute_f(f,range,nodes),'.')
    xlabel('Ma'),ylabel('Re'), hold off