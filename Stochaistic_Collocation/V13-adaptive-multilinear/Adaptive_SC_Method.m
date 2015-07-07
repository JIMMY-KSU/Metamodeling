% function Adaptive_SC_Method()
clear all; close all; clc;
% Function
for func = 5:5
    for error = 0.001:0.009:0.001
        % Apply the proper function
        if func == 1% Smooth harmonic function
            range = [0 1;0 1];
            f = @(y,x) sin(2*pi.*x).*cos(4*pi.*y)+2;
        elseif func == 2% Shifted smooth harmonic function
            range = [0 1;0 1];
            f = @(y,x) sin(2*pi.*x+0.25).*cos(4*pi.*y+0.5)+2;
        elseif func == 3% C1 function
            range = [0 1;0 1];
            f = @(x,y) abs(16*sqrt(0.4)/log(abs((sqrt(0.3)+sqrt(0.4))/...
                (sqrt(0.3)-sqrt(0.4))))/(2*sqrt(0.4))*log(abs((sqrt(x.^2+y.^2)...
                +sqrt(0.4))./(sqrt(x.^2+y.^2)-sqrt(0.4))))).^(sqrt(x.^2+y.^2)...
                <=sqrt(0.3))+abs(16*sqrt(0.2)/log(abs((sqrt(0.3)-sqrt(0.2))...
                /(sqrt(0.3)+sqrt(0.2))))/(2*sqrt(0.2))*log(abs((sqrt(x.^2+y.^2)...
                -sqrt(0.2))./(sqrt(x.^2+y.^2)+sqrt(0.2))))).^(sqrt(x.^2+y.^2)...
                >sqrt(0.3))-1;
        elseif func == 4
            range = [0 1;0 1];
            f = @(y,x) sin(2*pi.*x+0.25).*cos(4*pi.*y+0.5)+2+0.1*rand(1);
        elseif func == 5% Boiko's model
            range = [10 10000;0.1 3];
            f = @(rep,map) (24.0./rep+0.38+4.0./sqrt(rep))*(1.0+exp(-0.43./...
                (map.^4.67)));
        elseif func == 6% Loth's model
            range = [100 10000; 0 5];
            kn = 10;
            Cm = @(Ma) (5/3+2/3*tanh(3*log(Ma+0.1)))*(Ma<=1.45) + ...
                (2.044+0.2*exp(-1.8*(log(Ma/2))^2))*(Ma>1.45);
            Gm = @(Ma) (1-1.525*Ma^4)*(Ma<0.89) + ...
                (0.0002+0.0008*tanh(12.77*(Ma-2.02)))*(Ma>=0.89);
            Hm = @(Ma) 1-0.258*Cm(Ma)/(1+514*Gm(Ma));
            fk = @(kn) (1+kn*(2.514+0.8*exp(-0.55/kn)))^-1;
            Ck = @(Re) 24/Re*(1+0.15*Re^0.687)*fk(kn);
            Cf = @(Re) (0.5+0.0169*sqrt(Re))^-1;
            f = @(Re,Ma) (24/Re*(1+0.15*Re^(0.687))*Hm(Ma) + ...
                0.42*Cm(Ma)/(1+42500*Gm(Ma)/(Re^1.16)))*(Re>45) +...
                (Ck(Re)/(1+Ma^4)+(Ma^4*Cf(Re))/(1+Ma^4))*(Re<=45);
        elseif func == 7% Tong's model
            range = [100 600; 0.001 0.6];
            kn  = 10; Ma = 1;
            Cm  = @(Ma) (5/3+2/3*tanh(3*log(Ma+0.1)))*(Ma<=1.45) + ...
                (2.044+0.2*exp(-1.8*(log(Ma/2))^2))*(Ma>1.45);
            Gm  = @(Ma) (1-1.525*Ma^4)*(Ma<0.89) + ...
                (0.0002+0.0008*tanh(12.77*(Ma-2.02)))*(Ma>=0.89);
            Hm  = @(Ma) 1-0.258*Cm(Ma)/(1+514*Gm(Ma));
            fk  = @(kn) (1+kn*(2.514+0.8*exp(-0.55/kn)))^-1;
            Ck  = @(Re) 24/Re*(1+0.15*Re^0.687)*fk(kn);
            Cf  = @(Re) (0.5+0.0169*sqrt(Re))^-1;
            Cda = @(Re,Ma) (24/Re*(1+0.15*Re^(0.687))*Hm(Ma) + ...
                0.42*Cm(Ma)/(1+42500*Gm(Ma)/(Re^1.16)))*(Re>45) +...
                (Ck(Re)/(1+Ma^4)+(Ma^4*Cf(Re))/(1+Ma^4))*(Re<=45);
            f = @(Re,alpha) Cda(Re,Ma) + 0.5048*alpha*(1+34.8/Re^(0.5707))^4 +...
                0.9858*alpha*(1+34.8/Re^(0.5707));
        end
        % Number of test points and dimensions
        num_test_pts(1:2) = 100;
        d = 2;
        % Test Domain
        % Independant variable minima and maxima
        n = 1;
        for i = 1:num_test_pts(1)
            for j = 1:num_test_pts(2)
                test_pts(n,1) = (i-1)/(num_test_pts(1)-1);
                test_pts(n,2) = (j-1)/(num_test_pts(2)-1);
                n = n+1;
            end
        end
        % Minimum/Maximum level of refinement
        min_level = 2;                  % must be > 1
        max_level = 9;                  % must be >= min_level
        max_level = max_level+1;        % max_level includes level 0
        % Max Error
        % error = 0.001;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Ensure that the minimum specified levels are used always
        tic
        [w x] = Initialize(min_level, f, d, range);
        initialize_time = toc
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Compute the adaptive grid
        tic
        [w x] = Build_Grid(w, min_level, max_level, f, d, error, range);
        adaptive_grid_time = toc
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Interpolate the desired values using the adapted grid
        for m = 1:size(x,2)
            tic
            x2{m} = x{m};
            w2{m} = w{m};
            A = zeros(size(test_pts,1),1);
            Delta{m} = compute_Delta2(d,size(w2,2),x2,test_pts,w2);
            for i = 1:length(w2)
                A = A + Delta{i};
            end
            interpolate_solution_time(m) = toc
            n = 1;
            for i = 1:num_test_pts(1)
                for j = 1:num_test_pts(2)
                    Z(i,j)     = A(n);
                    if func == 4
                        f1 = @(y,x) sin(2*pi.*x+0.25).*cos(4*pi.*y+0.5)+2;
                        exact(i,j) = compute_f(f1,range,test_pts(n,:));
                    else
                        exact(i,j) = compute_f(f,range,test_pts(n,:));
                    end
                    n = n+1;
                end
            end
            nodes = [];
            for i = 1:size(w2,2)
                nodes = [nodes;x{i}];
            end
            err(m,1) = size(nodes,1);
            [err_loc{m} err(m,2) err(m,3) err(m,4)] = error_analysis(Z, exact);
        end
        save(['Output/func_' int2str(func) '_err_' num2str(error) '.mat']);
        save('reset.mat', 'func', 'error')
        clear all
        load('reset.mat')
    end
end