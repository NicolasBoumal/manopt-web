function M = spheresymmetricfactory(n)
% Returns a manifold struct to optimize over unit-norm symmetric matrices.
%
% function M = spheresymmetricfactory(n)
%
% Manifold of n-by-n real symmetric matrices of unit Frobenius norm.
% The metric is such that the sphere is a Riemannian submanifold of the
% space of nxn symmetric matrices with the usual trace inner product, i.e.,
% the usual metric <A, B> = trace(A'*B).
% 
% See also: spherefactory obliquefactory spherecomplexfactory

% This file is part of Manopt: www.manopt.org.
% Original author: Nicolas Boumal, April 17, 2015.
% Contributors: 
% Change log: 


    M.name = @() sprintf('Sphere of symmetric matrices of size %d', n);
    
    M.dim = @() n*(n+1)/2 - 1;
    
    M.inner = @(x, d1, d2) d1(:).'*d2(:);
    
    M.norm = @(x, d) norm(d, 'fro');
    
    M.dist = @(x, y) real(acos(x(:).'*y(:)));
    
    M.typicaldist = @() pi;
    
    M.proj = @proj;
    function xdot = proj(x, d)
        d = (d+d.')/2;
        xdot = d - x*(x(:).'*d(:));
    end
    
    M.tangent = @proj;
	
    % For Riemannian submanifolds, converting a Euclidean gradient into a
    % Riemannian gradient amounts to an orthogonal projection.
	M.egrad2rgrad = @proj;
	
	M.ehess2rhess = @ehess2rhess;
	function rhess = ehess2rhess(x, egrad, ehess, u)
        % these are not explicitly required, given the use.
        % egrad = (egrad + egrad.')/2;
        % ehess = (ehess + ehess.')/2;
        rhess = proj(x, ehess) - (x(:)'*egrad(:))*u;
	end
    
    M.exp = @exponential;
    
    M.retr = @retraction;

    M.log = @logarithm;
    function v = logarithm(x1, x2)
        v = proj(x1, x2 - x1);
        di = M.dist(x1, x2);
        % If the two points are "far apart", correct the norm.
        if di > 1e-6
            nv = norm(v, 'fro');
            v = v * (di / nv);
        end
    end
    
    M.hash = @(x) ['z' hashmd5(x(:))];
    
    M.rand = @() random(n);
    
    M.randvec = @(x) randomvec(n, x);
    
    M.lincomb = @lincomb;
    
    M.zerovec = @(x) zeros(n);
    
    M.transp = @(x1, x2, d) proj(x2, d);
    
    M.pairmean = @pairmean;
    function y = pairmean(x1, x2)
        y = x1+x2;
        y = y / norm(y, 'fro');
    end

    % TODO : check isometry and fix.
    M.vec = @(x, u_mat) u_mat(:);
    M.mat = @(x, u_vec) reshape(u_vec, [n, m]);
    M.vecmatareisometries = @() false;

end

% Exponential on the sphere
function y = exponential(x, d, t)

    if nargin == 2
        t = 1;
    end
    
    td = t*d;
    
    nrm_td = norm(td, 'fro');
    
    if nrm_td > 4.5e-8
        y = x*cos(nrm_td) + td*(sin(nrm_td)/nrm_td);
    else
        % If the step is too small to accurately evaluate sin(x)/x,
        % then sin(x)/x is almost indistinguishable from 1.
        y = x + td;
        y = y / norm(y, 'fro');
    end

end

% Retraction on the sphere
function y = retraction(x, d, t)

    if nargin == 2
        t = 1;
    end
    
    y = x + t*d;
    y = y / norm(y, 'fro');

end

% Uniform random sampling on the sphere.
function x = random(n)

    x = randn(n);
    x = (x + x.')/2;
    x = x/norm(x, 'fro');

end

% Random normalized tangent vector at x.
function d = randomvec(n, x)

    d = randn(n);
    d = (d + d.')/2;
    d = d - x*(x(:).'*d(:));
    d = d / norm(d, 'fro');

end

% Linear combination of tangent vectors
function d = lincomb(x, a1, d1, a2, d2) %#ok<INUSL>

    if nargin == 3
        d = a1*d1;
    elseif nargin == 5
        d = a1*d1 + a2*d2;
    else
        error('Bad use of spheresymmetric.lincomb.');
    end

end
