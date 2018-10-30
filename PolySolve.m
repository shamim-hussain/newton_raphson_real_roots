function ret = PolySolve(p)

global zero_app


n = length(p) - 1;
ret = [];

if n < 1 || p(1) == 0
    disp('Invalid input polynomial!');
    return;
end

if n == 1
    ret = - p(2) / p(1);
    return;
end

diff = PolyDiff(p);
crit = PolySolve(diff);

if isempty(crit)
    crit = [0];
end

count = 1;
v1 = polyval(p, crit(1));


if ~(abs(v1) < zero_app) && polyval(p, crit(1) - 1) / v1 < 1
    ret(count) = PolyNR(p, crit(1) - 1);
    count = count + 1;
end


for i = 1:(length(crit) - 1)
    v2 = polyval(p, crit(i + 1));
    if abs(v1) < zero_app
        ret(count) = crit(i);
        count = count + 1;
        
    elseif ~(abs(v2) < zero_app) && v1 / v2 < 0;
        ret(count) = PolyNR(p, (crit(i) + crit(i+1)) / 2);
        count = count + 1;
    end
    v1 = v2;
end

if abs(v1) < zero_app
    ret(count) = crit(end);
    
elseif polyval(p, crit(end) + 1) / v1 < 1
    ret(count) = PolyNR(p, crit(end) + 1);
end

end