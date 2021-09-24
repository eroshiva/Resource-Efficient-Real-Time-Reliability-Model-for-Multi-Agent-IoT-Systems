%% Function for parameter deviation measurement. Excluding negative values cutting.
% Takes as an input:
% - steps - number of iterations,
% - input - vector with input values,
% - sla - vector with SLA values,
% - pr - vector with priorities.
% As an output it gives computed parameter deviation.
function [parameter, inputMetrics] = measurePnv(steps,input,sla,pr)

    inputMetrics = zeros(4, steps);
    parameter = zeros(1, steps);

    for j = 1:steps

        % Re-computing SLA to see, whether system satisfies requirements
        inputMetrics(:,j) = input(:,j)'./sla; % transponing is needed to set correct dimension (result should be a vector, not a matrix)
        inputMetrics(:,j) = 1 - inputMetrics(:,j);

        % Computing parameter
        parameter(1,j) = inputMetrics(:,j)'*pr';
    end
    
end