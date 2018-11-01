%% Compute reach set for MLP
function y = networkOutput(input,network)

layerNum = length(network.bias);
weight = network.weight;
bias = network.bias;
activeType =network.activeType;
%inputNum = length(input);

%for i= 1:1:inputNum
    for j = 1:1:layerNum
        input = layerOutput(j,input,network);
    end
%end
y = input;