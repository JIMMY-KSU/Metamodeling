clear all; clc; close all

test_pts = 51;

% Which test function (1=cos.5, 2=^3, 3=cos1)
analyt = 1;

%Polynomial Order
k = 7;

%Number of dimensions (Only 2D currently)
N = 2;

pts = Colloc_Pts(N, k);
% pts = Tensor_Pts(N, k);

% figure(2)
% plot(pts, '.b')

% For the full set of Tensor Products
pts2(:,1) = unique(pts(:,1));
pts2(:,2) = unique(pts(:,2));

cd = zeros(length(pts(:,1)),1);
for i = 1:length(pts(:,1))
    cd(i) = analyt_func(pts(i,1),pts(i,2),analyt);
end

h = zeros(length(pts2(:,1)),2);
lagrange = zeros(1,2);

% Y(:) is the location of the value we're looking for
for p = 1:test_pts
    for q = 1:test_pts
        y(1) = -1 + 2*(p-1)/(test_pts-1);
        y(2) = -1 + 2*(q-1)/(test_pts-1);
        
        L = 0;
        
        for j = 1:length(pts2(:,1))
            h(j,1) = Lagrange_Poly(length(pts2(:,1)), y(1), pts2(:,1), j);
            h(j,2) = Lagrange_Poly(length(pts2(:,2)), y(2), pts2(:,2), j);
        end
        
%         for i = 1:length(pts(:,1))
%             lagrange(:) = 0;
%             for j = 1:length(pts2(:,1))
%                 if pts(i,1) == pts2(j,1)
%                     lagrange(1) = h(j,1);
%                 end
%                 if pts(i,2) == pts2(j,2)
%                     lagrange(2) = h(j,2);
%                 end
%             end
%             L              = L + cd(i)*lagrange(1)*lagrange(2);
%             cd_test(p,q)   = L;
%             cd_actual(p,q) = analyt_func(y(1), y(2), analyt);
%         end
    end
end

% plotting(pts, cd, cd_test, cd_actual, test_pts, analyt)

% VDM = vander(pts);

length(pts(:,1))
