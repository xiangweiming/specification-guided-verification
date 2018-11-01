function y = terminate(x,parameter)
temp = abs(x(1,:)-x(2,:));
if max(temp) <= parameter
    y = 1;
else
    y = 0;
end



