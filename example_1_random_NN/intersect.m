function y = intersect(x1,x2)
[n,m] = size(x1);
for j = 1:1:m
    if x1(1,j) >= x2(1,j) & x1(1,j) <= x2(2,j) | x1(2,j) >= x2(1,j) & x1(2,j) <= x2(2,j)
        y = 1;
        continue;
    else
        y = 0;
        break;
    end
end
tempy = y;
if tempy == 0
    for j = 1:1:m
        if x2(1,j) >= x1(1,j) & x2(1,j) <= x1(2,j) | x2(2,j) >= x1(1,j) & x2(2,j) <= x1(2,j)
            y = 1;
            continue;
        else
            y = 0;
            break;
        end
    end
else
    y = 1;
end
    