%% 3 types of activation functions
function y = activeFun(x,activeType) 
switch activeType
    case 'sigmoid'
        y = sigmoid(x);
    case 'tansig'
        y = tansig(x);
    case 'logsig'
        y = logsig(x);
    case 'purelin'
        y = purelin(x);
    case 'poslin'
        y = poslin(x);
end