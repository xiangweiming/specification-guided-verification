clc
clear
load('ex3data1.mat');
load('ex3weights.mat');
value = 2;
%value = 5;
selectX = selectImage(X,y,value);
fprintf('Display the selected image. Press enter to continue.\n');
%displayData(selectX);
%pause;

attack.w = 3; %width of the box
attack.l = 3; %length of the box
attack.v = 1; %start position (v,h)
attack.h = 1; %start position (v,h)
attack.r = [-0.5,0.5];

network.weight = {Theta1,Theta2};
network.bias = {zeros(size(network.weight{1},1),1),zeros(size(network.weight{2},1),1)};
network.activeType = {'sigmoid','sigmoid'};
save data network

%% Generate the optimal solution m file, if use the line below, need to pause for a while to generate the m file
run('generateFun.m')
fprintf('Generate optimal solution m file. Press enter to continue.\n');
pause;

terminateParameter=0.5;
tic
for i = 1:1:size(selectX,1)
    i =46
    %i
    image = selectX(i,:);
    displayData(image);
    pred = predict(Theta1, Theta2, image);
    if pred ~= value
        z(i) = -1;
        fprintf('The prediction of neural network is not correct for the %g th image! \n',i)
        continue;
    else
        z(i) = safeVeri(image,pred,attack,network,terminateParameter);
    end
    toc
end


