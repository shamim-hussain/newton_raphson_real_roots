function ret = PolyNR(p, e)
d = PolyDiff(p);
ret = e;

global tol_nr
global max_iter
global n_iter

for i = 1:max_iter
    t = ret - polyval(p, ret) / polyval(d, ret);
    if abs(t - ret) < tol_nr 
        ret = t;
        n_iter = n_iter + i;
        break;
    end
    ret = t;
end
end

