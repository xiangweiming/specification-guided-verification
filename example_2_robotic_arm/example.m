%% Example 1 
clc
clear
%% Generate or load random NN
numNueron = [2,5,2];
network.activeType = {'tansig','purelin'};
numLayer = length(numNueron)-1;

for n = 1:1:numLayer
    network.weight{n} = randn(numNueron(n+1),numNueron(n));
    network.bias{n} = randn(numNueron(n+1),1);
end

%load data_save_for_paper network
%load data_robotic_arm network
load data networks


%% Generate the optimal solution m file, if use the line below, need to pause for a while to generate the m file
run('generateFun.m')

%% Input and unsafe regions
inputMin = [pi/3,pi/3];
inputMax = [2*pi/3,2*pi/3];
unsafeMin = [-14,1];
unsafeMax = [3,17];

%% Compute reachable set
terminateParameter = 0.01; %The xmax_i - xmin_i is smaller than terminateParameter, algorithm stops;  
%falsifyParameter = 100; %The number of randomly generated input in the input box;
tic
input.min = inputMin;
input.max = inputMax;
unsafe = [unsafeMin;unsafeMax];
y = networkOutput(input,network);
outputMin = y.min;
outputMax = y.max;
M{1} = [inputMin;inputMax;outputMin;outputMax];
numM = 1;
i = 1;
while numM > 0
    tempM = M{1}; %select the first set in M
    M(1) = []; %remove the selected set
    if intersect(tempM(3:4,:),unsafe) == 0 %if the selected set is safe, record it
        L{i} = tempM;
        i = i+1;
        numM = numM-1;
        if numM > 0
            continue;
        else
            fprintf('The neural network is safe with respect to unsafe region.\n');
            fprintf('The safety is guaranteed by %g interval sets.\n', length(L));
            figure;
            for i = 1:1:length(L)
                Lx.min = L{i}(1,:);
                Lx.max = L{i}(2,:);
                squareplot(Lx,'c','empty');
                hold on
            end
            title('Partition of input space')
            xlabel('\pi/3 < x_1 < 2\pi/3') % x-axis label
            ylabel('\pi/3 < x_2 < 2\pi/3') % y-axis label
            figure
            for i = 1:1:length(L)
                Ly.min = L{i}(3,:);
                Ly.max = L{i}(4,:);
                squareplot(Ly,'c','empty');
                hold on
            end
            title('Output set estimation and unsafe region')
            xlabel('y_1') % x-axis label
            ylabel('y_2') % y-axis label
            break;
        end
    elseif intersect(tempM(3:4,:),unsafe) == 1 
        if terminate(tempM,terminateParameter) == 0
            [input1,input2] = bisect(tempM(1:2,:));
            input.min = input1(1,:);
            input.max = input1(2,:);
            y = networkOutput(input,network);
            M{numM} = [input.min;input.max;y.min;y.max];
            numM = numM+1;
            input.min = input2(1,:);
            input.max = input2(2,:);
            y = networkOutput(input,network);
            M{numM} = [input.min;input.max;y.min;y.max];
        elseif terminate(tempM,terminateParameter) == 1
               fprintf('Safety of the neural network is not clear for the current terminate parameter: %g\nThe safety might be ensured by changing to a smaller parameter.\n',terminateParameter);
            %end
            break;
        end
    end        
end
toc
unsafeRegion.min = unsafeMin;
unsafeRegion.max = unsafeMax; 
squareplot(unsafeRegion,'red','empty');
hold on;
for i = 1:1:5000
    inputPoint = [inputMin(1) + (inputMax(1)-inputMin(1))*rand;inputMin(2) + (inputMax(2)-inputMin(2))*rand];% center of input set
    yPoint = networkOutputPoint(inputPoint,network); % [y.y0,y.radius] = [center of output set, radius of output set]
    plot(yPoint(1),yPoint(2),'.black')
    hold on
end

















