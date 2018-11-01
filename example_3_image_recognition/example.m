%% Example 1 
clc
clear
%% Generate or load random NN
load('ex3data1.mat');
load('ex3weights.mat');
attack.w = 3; %width of the box
attack.l = 3; %length of the box
attack.v = 1; %start position (v,h)
attack.h = 1; %start position (v,h)
attack.r = [-0.5,0.5];
m = size(X, 1);
sel = unidrnd(m); %select image number;
image = X(sel, :);
lb = round(sqrt(size(image, 2)));%length of the image
displayData(image);
fprintf('Display the selected image. Press enter to continue.\n');
pause;
pred = predict(Theta1, Theta2, image);
fprintf('Neural Network Prediction: %d (digit %d)\n', pred, mod(pred, 10));
pause;
attackImage = image;
for i = 0:1:attack.w-1
    for j = 0:1:attack.l-1  
        ra = attack.r(1)+(attack.r(2)-attack.r(1))*rand; 
        temp = image((attack.v-1)*lb+attack.h+i*lb+j)+ra;
        if temp >= 1
            temp = 1;
        elseif temp <= -1
            temp = -1;
        end
        attackImage((attack.v-1)*lb+attack.h+i*lb+j) = temp;
    end
end
displayData(attackImage);
fprintf('Display the attacked image. Press enter to continue.\n');
pause;

network.weight = {Theta1,Theta2};
network.bias = {zeros(size(network.weight{1},1),1),zeros(size(network.weight{2},1),1)};
network.activeType = {'sigmoid','sigmoid'};
save data network

%% Generate the optimal solution m file, if use the line below, need to pause for a while to generate the m file
run('generateFun.m')
fprintf('Generate optimal solution m file. Press enter to continue.\n');
pause;
%% Verify image
terminateParameter=0.1;
z = safeVeri(image,pred,attack,network,terminateParameter);




















