%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This reliability model is taken from the following publication:
% V Kumar, R Vidhyalakshmi Reliability Aspect of Cloud Computing Environment
% https://link.springer.com/content/pdf/10.1007/978-981-13-3023-0.pdf
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% This function takes following input values:
% - n - number of devices in IoT network (??),
% - precision - how precise you want values to generate,
% - latencySLA - vector of latency values [CPU, RAM, Network Interface, Storage] for each component according to SLA.
% - availabilitySLA - vector of availability values [CPU, RAM, Network Interface, Storage] for each device component according to SLA.
% - wPr - vector specifying workload priorities for each component -
% summation of it should give 1.
% - lPr - vector specifying latency priorities for each component -
% summation of it should give 1.
% - aPr - vector specifying availability priorities for each component -
% summation of it should give 1.
% - tPr - vector specifying priorities for each computed domain (Workload, Latency, Availability) -
% summation of it should give 1.
% As an output it returns time needed to compute reliability for each
% device. Time unit is seconds (??) - calrify..
% This function is used for one step (each moment of time)
function time = ertCore(n, precision, latencySLA, availabilitySLA, wPr, lPr, aPr, tPr)
%% Generate pseudorandom workload values for each device component (CPU, RAM, Network Interface, Storage)

w = generateWorkload(n, precision); % Pseudo-random workload values (you can obtain from htop)
l = generateLatency(n, precision, latencySLA); % Pseudo-random latency workload
a = generateAvailability(n, precision, availabilitySLA); % Pseudo-random availability values: (number of successful requests)/(total number of requests)

reliability = zeros(1, n); % Output vector with computed reliability values for each device
% temp = [0, 0, 0]; % temporary vector for storing in-between values in calculation
parameter = zeros(n, 3);
%%
tStart = tic;
for i = 1:n 
    
    parameter(i,1) = doComputation(w(i,:),wPr);
    parameter(i,2) = doComputation(l(i,:),lPr);
    parameter(i,3) = doComputation(a(i,:),aPr);
    
%     temp(1) = doComputation(w(i,:),wPr);
%     temp(2) = doComputation(l(i,:),lPr);
%     temp(3) = doComputation(a(i,:),aPr);
    
    reliability(i) = parameter(i,:)*tPr'; % computing final reliability of an IoT network
%     reliability(i) = temp*tPr'; % computing final reliability of an IoT network
    
end
tEnd = toc(tStart);
time = tEnd; % time spent on calculations

end

%% This function generates workload values for device components. It takes as an input:
% - n - number of devices,
% - precision - how precise you want generated values to be,
% It returns a vector with generated values. Values are completely random
% and varies from 0 (0%) to 1 (100%).
function prv = generateWorkload(n, precision)
%%
prv = zeros(n, 4); % dimension is 4 because it contains workload values for CPU, RAM, Network Interface, Storage
for i = 1:n
   % Generating pseudorandom number from 0 to 1 (indicates workload %)
   prv(i, 1) = randi(precision)/precision;
   prv(i, 2) = randi(precision)/precision;
   prv(i, 3) = randi(precision)/precision;
   prv(i, 4) = randi(precision)/precision;
end

end

%% This function generates latency values for device components. It takes as an input:
% - n - number of devices,
% - precision - how precise you want generated values to be,
% It returns a matrix with generated values. Values are completely random
% and varies from 0 to 1. Value is computed as following:
% (current latency value)/latency according to SLA)
% Units for SLA latency and current latency should be the same.
function prv = generateLatency(n, precision, latencySLA)
%%
prv = zeros(n, 4); % dimension is 4 because it contains latency values for CPU, RAM, Network Interface, Storage
for i = 1:n
   % Generating pseudorandom number - should be from 0 to 1,
   % but could be even more than 1 - what to do in this case??
   prv(i, 1) = randi(precision)/latencySLA(1);
   prv(i, 2) = randi(precision)/latencySLA(2);
   prv(i, 3) = randi(precision)/latencySLA(3);
   prv(i, 4) = randi(precision)/latencySLA(4);
end

end

%% This function generates availability values for device components. It takes as an input:
% - n - number of devices,
% - precision - how precise you want generated values to be,
% It returns a matrix with generated values. Values are completely random
% and varies from 0 to 1. Value is computed as following:
% (current latency value)/latency according to SLA)
% Units for SLA latency and current latency should be the same.
function prv = generateAvailability(n, precision, availabilitySLA)
%%
prv = zeros(n, 4); % dimension is 4 because it contains latency values for CPU, RAM, Network Interface, Storage
for i = 1:n
   % Generating pseudorandom number from 0 to 1
   prv(i, 1) = (randi(precision)/precision)/availabilitySLA(1);
   prv(i, 2) = (randi(precision)/precision)/availabilitySLA(2);
   prv(i, 3) = (randi(precision)/precision)/availabilitySLA(3);
   prv(i, 4) = (randi(precision)/precision)/availabilitySLA(4);
end

end

%% This function takes as an input:
% - n - number of devices,
% - precision - how precise you want generated values to be,
% It returns an eigen vector.
function eigen = computeEigenVector(p1, p2, p3, p4)
%%
a = [1, p1/p2, p1/p3, p1/p4; p2/p1, 1, p2/p3, p2/p4; p3/p1, p3/p2, 1, p3/p4; p4/p1, p4/p2, p4/p3, 1];
square_a = a*a;

e1 = sum(a(1,:));
e2 = sum(a(2,:));
e3 = sum(a(3,:));
e4 = sum(a(4,:));
total_sum = e1+e2+e3+e4;

eigen = [e1/total_sum, e2/total_sum, e3/total_sum, e4/total_sum];

end

%% This function computes reliability according to CORE schema
% - inData - 4 items vector containing metrics values for each component
% (CPU, RAM, Network Interface, Storage)
% - priorities - 4 items vector containing priority values specified by
% customer for each component (CPU, RAM, Network Interface, Storage)
function reliability = doComputation(inData, priorities)
%%
    eigen = computeEigenVector(inData(1), inData(2), inData(3), inData(4));
    reliability = eigen*priorities';

end
