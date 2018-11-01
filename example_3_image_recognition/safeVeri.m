function z = safeVeri(image,pred,attack,network,terminateParameter)

lb = round(sqrt(size(image, 2)));
inputMin = image;
for i = 0:1:attack.w-1
    for j = 0:1:attack.l-1  
        temp = image((attack.v-1)*lb+attack.h+i*lb+j)+attack.r(1);
        if temp >= 1
            temp = 1;
        elseif temp <= -1
            temp = -1;
        end
        inputMin((attack.v-1)*lb+attack.h+i*lb+j) = temp;
    end
end
inputMax = image;
for i = 0:1:attack.w-1
    for j = 0:1:attack.l-1  
        temp = image((attack.v-1)*lb+attack.h+i*lb+j)+attack.r(2);
        if temp >= 1
            temp = 1;
        elseif temp <= -1
            temp = -1;
        end
        inputMax((attack.v-1)*lb+attack.h+i*lb+j) = temp;
    end
end
%% Safty verification
%terminateParameter = 0.1; %The xmax_i - xmin_i is smaller than terminateParameter, algorithm stops;  
input.min = inputMin;
input.max = inputMax;
y = networkOutput(input,network);
outputMin = y.min;
outputMax = y.max;
M{1}.input = [inputMin;inputMax];
M{1}.output = [outputMin;outputMax];
numM = 1;
i = 1;
numIntersect = 1;
while numM > 0
    tempM = M{1}; %select the first set in M
    M(1) = []; %remove the selected set
    if intersect(tempM.output,pred) == 0 %if the selected set is safe, record it
        L{i} = tempM;
        numPartition = i;;
        i = i+1;
        numM = numM-1;
        if numM > 0
            continue;
        else
            fprintf('The neural network is safe for digit %g.\n',pred);
            z = 0;
            %fprintf('The safety is guaranteed by %g interval sets.\n', length(L));
            break;
        end
    elseif intersect(tempM.output,pred) == 1 
        numIntersect = numIntersect+1;
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
            %[y.max(1),y.min(2),y.max(1)-y.min(2)]
        elseif terminate(tempM.input,terminateParameter) == 1
            fprintf('Safety of the neural network for digit %g is not clear for the current terminate parameter: %g\nThe safety might be ensured by changing to a smaller parameter.\n',pred,terminateParameter);
            z = 1;
            break;
        end
    end        
end
