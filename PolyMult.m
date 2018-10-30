function ret = PolyMult(p, r)

if isnan(r)
    ret = NaN;
    return
end
    
global zero_app

n = length(r);
m = ones([1 n]);
for i = 1 : n
    d = PolyDiff(p);
    while abs(polyval(d, r(i))) < zero_app
        d = PolyDiff(d);
        m(i) = m(i) + 1;
    end
end
ret = m;
end