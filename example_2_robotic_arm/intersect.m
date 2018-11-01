function y = intersect(x1,x2)
if x1(1,1) > x2(1,1) & x1(2,1) < x2(2,1) & x1(1,2) > x2(1,2) & x1(2,2) < x2(2,2)
    y = 0;
else
    y = 1;
end
    

   