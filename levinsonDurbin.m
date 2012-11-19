function [xVector] = levinsonDurbin(autocorrelationVector, yVector)

% % close all; clear all;
% % cd ~/Desktop/
% % 
% % autocorrelationVector = [2 4 5 9.7  9 10]';

autocorrelationVector = autocorrelationVector(:);

initialForwardVector = 1/autocorrelationVector(1);
initialBackwardVector = initialForwardVector;

forwardVector = initialForwardVector;
backwardVector = initialBackwardVector;
xVector = yVector(1)/autocorrelationVector(1);

N = length(yVector);
for k = 1:N-1
    [xVector, forwardVector, backwardVector] = getNewXVector(autocorrelationVector, xVector, yVector, forwardVector, backwardVector);
end    
    
    
end



%% get next forward error

function forwardError = getForwardError(autocorrelationVector, previousForwardVector)

tempAutocorrelationVector = flipud(autocorrelationVector(2:(length(previousForwardVector) + 1)));
forwardError = tempAutocorrelationVector' * previousForwardVector;

end



%% get next backward error

function backwardError = getBackwardError(autocorrelationVector, previousBackwardVector)

tempAutocorrelationVector = autocorrelationVector(2:(length(previousBackwardVector) + 1));
backwardError = tempAutocorrelationVector' * previousBackwardVector;

end



%% get new forward vector

function [forwardVector, backwardVector] = getNewForwardAndBackwardVector(autocorrelationVector, previousForwardVector, previousBackwardVector)

forwardError = getForwardError(autocorrelationVector, previousForwardVector);
backwardError = getBackwardError(autocorrelationVector, previousBackwardVector);

extendedForwardVector = [previousForwardVector; 0];
extendedBackwardVector = [0; previousBackwardVector];

firstFactor = 1/(1 - (forwardError * backwardError));
secondFactor = -forwardError * firstFactor;

forwardVector = (firstFactor * extendedForwardVector) + (secondFactor * extendedBackwardVector);

secondFactor = -backwardError * firstFactor;
backwardVector = (firstFactor * extendedBackwardVector) + (secondFactor * extendedForwardVector);

end


%% get next x error

function xError = getXError(autocorrelationVector, previousXVector)

tempAutocorrelationVector = flipud(autocorrelationVector(2:(length(previousXVector) + 1)));
xError = tempAutocorrelationVector' * previousXVector;

end


%% get new x vector

function [xVector, forwardVector, backwardVector] = getNewXVector(autocorrelationVector, previousXVector, yVector, previousForwardVector, previousBackwardVector)

xError = getXError(autocorrelationVector, previousXVector);

extendedXVector = [previousXVector; 0];
[forwardVector, backwardVector] = getNewForwardAndBackwardVector(autocorrelationVector, previousForwardVector, previousBackwardVector);

secondFactor = yVector(length(extendedXVector)) - xError;

xVector = extendedXVector + (secondFactor * backwardVector);


end