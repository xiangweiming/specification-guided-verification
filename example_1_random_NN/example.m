%% Example 1 
clc
clear
%% Generate or load random NN
%numNueron = [2,1000,2];
%network.activeType = {'tansig','purelin'};
%numLayer = length(numNueron)-1;

%for n = 1:1:numLayer
%    network.weight{n} = randn(numNueron(n+1),numNueron(n));
%    network.bias{n} = randn(numNueron(n+1),1);
%end

%load data_save_for_paper network
load data_5_layer_10_neuron network
%load NeuralNetwork7_3
%network.weight = W;
% network.bias = b;
% network.activeType = {'poslin','poslin','poslin','poslin','poslin','poslin','poslin','purelin'};
%load data network
save data network


%% Generate the optimal solution m file, if use the line below, need to pause for a while to generate the m file
run('generateFun.m')
fprintf('Generate optimal solution m file. Press enter to continue.\n');
pause;

%% Input and unsafe regions
inputMin = [-5,-5];
inputMax = [5,5];
unsafeMin = [1,1];
unsafeMax = [6,6];

%% Compute reachable set
terminateParameter = 0.01; %The xmax_i - xmin_i is smaller than terminateParameter, algorithm stops;  
tic
input.min = inputMin;
input.max = inputMax;
unsafe = [unsafeMin;unsafeMax];
y = networkOutput(input,network);
outputMin = y.min;
outputMax = y.max;
M{1}.input = [inputMin;inputMax];
M{1}.output = [outputMin;outputMax];
numM = 1;
i = 1;
while numM > 0
    tempM = M{1}; %select the first set in M
    M(1) = []; %remove the selected set
    if intersect(tempM.output,unsafe) == 0 %if the selected set is safe, record it
        L{i} = tempM;
        %numPartition = i;
        i = i+1;
        numM = numM-1;
        if numM > 0
            continue;
        else
            fprintf('The neural network is safe with respect to unsafe region.\n');
            fprintf('The safety is guaranteed by %g interval sets.\n', length(L));
            figure;
            for i = 1:1:length(L)
                Lx.min = L{i}.input(1,:);
                Lx.max = L{i}.input(2,:);
                squareplot(Lx,'c','empty');
                hold on
            end
            title('Partition of input space')
            xlabel('-5 < x_1 < 5') % x-axis label
            ylabel('-5 < x_2 < 5') % y-axis label
            figure
            for i = 1:1:length(L)
                Ly.min = L{i}.output(1,:);
                Ly.max = L{i}.output(2,:);
                squareplot(Ly,'c','empty');
                hold on
            end
            title('Output set estimation and unsafe region')
            xlabel('y_1') % x-axis label
            ylabel('y_2') % y-axis label
            break;
        end
    elseif intersect(tempM.output,unsafe) == 1 
        if terminate(tempM.input,terminateParameter) == 0
            [input1,input2] = bisect(tempM.input);
            input.min = input1(1,:);
            input.max = input1(2,:);
            y = networkOutput(input,network);
            M{numM}.input = [input.min;input.max];
            M{numM}.output = [y.min;y.max];
            numM = numM+1;
            input.min = input2(1,:);
            input.max = input2(2,:);
            y = networkOutput(input,network);
            M{numM}.input = [input.min;input.max];
            M{numM}.output = [y.min;y.max];
        elseif terminate(tempM.input,terminateParameter) == 1
            fprintf('Safety of the neural network is not clear for the current terminate parameter: %g\nThe safety might be ensured by changing to a smaller parameter.\n',terminateParameter);
            break;
        end
    end        
end
toc
unsafeRegion.min = unsafeMin;
unsafeRegion.max = unsafeMax; 
squareplot(unsafeRegion,'red','full');
hold on;
for i = 1:1:5000
    inputPoint = [inputMin(1) + (inputMax(1)-inputMin(1))*rand;inputMin(2) + (inputMax(2)-inputMin(2))*rand];% center of input set
    yPoint = networkOutputPoint(inputPoint,network); % [y.y0,y.radius] = [center of output set, radius of output set]
    plot(yPoint(1),yPoint(2),'.black')
    hold on
end

















