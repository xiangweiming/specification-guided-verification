function y = intersect(x1,x2)
z1 = min(x1(1,x2));
z2 = x1(2,:);
z2(x2) = [];
z2 = max(z2);
if z1 > z2;
    y = 0;
else
    y = 1;
end
    



    