%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This reliability schema is taken from the following publication:
% L. Virgili, D. Ursino, Humanizing IoT: defining the profile and the reliability of a thing, 2020
% https://www.researchgate.net/publication/338988314_Humanizing_IoT_defining_the_profile_and_the_reliability_of_a_thing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Drawbacks:
% - too much data to store

function time = thingReliability(n, precision, gamma)
%% Generating data
inReliability = zeros(1, n); % reliability of each device in the step before
devTran = zeros(n, n); % matrix indicating transactions between devices. Contains 1, if there was a successfull transaction or 0, if there weren't
firstTS = zeros(n, n); % matrix with timestamps of current transaction
currentTS = zeros(n, n); % matrix with timestamps of current transaction

outReliability = zeros(1,n); % computed reliability of each device

%% Filling in with input data

for i = 1:length(inReliability)
   inReliability(i) = randi(precision)/precision; 
end

for i = 1:n
    for j = 1:n
        devTran(i,j) = round(randi(precision)/precision);
        firstTS(i,j) = randi(precision);
        currentTS(i,j) = firstTS(i,j) + randi(precision);
    end     
end

%% Computing reliability

tStart = tic;
for i = 1:length(outReliability)
   
    tmp = interstep(devTran(i,:), inReliability, firstTS(i,:), currentTS(i,:));
    outReliability(i) = gamma+(1-gamma)*(tmp)/sum(devTran(i,:));
    
end

% Normalizing reliability
outReliability = outReliability/max(outReliability);


tEnd = toc(tStart);
time = tEnd;

end

%% Function to compute interstep in reliability model

function out = interstep(okTranSet, inRel, fTS, cTS)
    out = 0;
    for l = 1:length(okTranSet)
        if okTranSet(l) == 1
            out = out + inRel(l)*(1-fTS(l)/cTS(l));
        end
    end
end