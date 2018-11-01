function [y1,y2] = bisect(x)
[value,position] = max(abs(x(1,:)-x(2,:)));
y1 = x;
y1(1,position) = x(1,position)+value/2;
y2 = x;
y2(2,position) = x(2,position)-value/2;
