clear; clc; clf;

% Generate random problem data.
n = 1000;
A = randn(n);
A = .5*(A+A');

% Create the problem structure.
manifold = spherefactory(n);
problem.M = manifold;

% Define the problem cost function and its Euclidean gradient.
problem.cost  = @(x) -x'*(A*x);
problem.egrad = @(x) -2*A*x;      % notice the 'e' in 'egrad' for Euclidean

% Numerically check gradient consistency (just once, optional).
figure(1); clf;
checkgradient(problem);
drawnow;
set(gcf, 'Color', [67, 67, 67]*.65/255);
set(gca, 'Color', [67, 67, 67]*.65/255);
set(gca, 'XColor', 'w');
set(gca, 'YColor', 'w');
set(get(gca, 'title'), 'Color', 'w');
set(get(gca, 'title'), 'FontWeight', 'normal');
hh = get(gca, 'Children');
set(hh(1), 'Color', 'w');
set(hh(1), 'LineWidth', 4);
set(hh(2), 'Color', 'w');
set(hh(2), 'LineWidth', 2);
set(hh(3), 'Color', [243, 199, 238]/255);
set(hh(3), 'LineWidth', 2);
drawnow;

% Solve.
[x, xcost, info, options] = trustregions(problem);

% Display some statistics.
figure(2); clf;
semilogy([info.iter], [info.gradnorm], ...
         '.-', 'LineWidth', 2, ...
         'MarkerSize', 25, ...
         'Color', [243, 199, 238]/255);
xlabel('Iteration number');
ylabel('Norm of the Riemannian gradient of f');
set(gcf, 'Color', [67, 67, 67]*.65/255);
set(gca, 'Color', [67, 67, 67]*.65/255);
set(gca, 'XColor', 'w');
set(gca, 'YColor', 'w');
grid on;
