function selectX = selectImage(X,y,value)
if value == 0
    value = 10;
end
position = find(y==value);
for i = 1:1:length(position)
    selectX(i,:) = X(position(i),:);
end




