function ret = PolyDiff(p)
n = length(p) - 1;

if n == 0
    ret = 0;
    return;
end

for i = n:-1:1
    ret(i) = (n - i + 1) * p(i);
end
end

