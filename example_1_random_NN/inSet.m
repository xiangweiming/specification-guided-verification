function y = inSet(point,set)
n = length(point);
for i = 1:1:n
    if point(i) < set(1,i) | point(i) > set(2,i)
        y = 0;
        break;
    else
        y = 1;
    end
end