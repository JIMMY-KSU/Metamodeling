clear all; close all; clc;
d = 2; n = 6;

range = [0 pi; 0 pi];
x1 = pi*rand(1,5); x2 = pi*rand(1,5);

f = @(x,y) sin(x) + cos(y);

z = Smolyak_func_d(n, d, f, range);

smol  = SC_Interp(d, z, range, x1, x2);
exact = sin(x1) + cos(x2);

% subplot(1,2,1), ezmesh(f,[0 pi])
% title('f(x,y) = sin(x)+cos(y)')
% subplot(1,2,2), ezmesh(@(x,y) spinterp(z,x,y),[0 pi])
% title('Sparse Grid Interpolant, n=4')