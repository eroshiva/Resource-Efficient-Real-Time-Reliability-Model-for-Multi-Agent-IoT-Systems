%% Clean workspace
clear all;
close all;
clc;

%% ert-CORE algorithm (enchanced real-time Customer-Oriented Reliability Estimation)
% Chceme dostat vysledny vektor [latence, zatizenost, pohotovost], ktery
% nasledne vynasobime s prioritnim rozdelenim (dle SLA/zakaznika) a
% dostaneme tim celkovou spolehlivost

%% Defining some constants
n = 0:10:1000; % vector with number of the systems in IoT network
n = n(2:length(n)); % cutting first item of a vector, which is 0, since
% it's not valid case
precision = 1000; % we want numbers to have three digits after dot
trials = 50000; % number of iterations to run on each attempt

%% Measurement: Reliability Aware IoT --> takes around 1 day 18 hours to compute on 3.5 GHz processor
resultRaIoT = zeros(1,length(n)); % vector containing average time needed for model with certain number of systems to finish computations
failure_rate = 5; % failure rate parameter (input for Poisson distribution)
recovery_rate = 7; % recovery rate parameter (input for exponential distribution)

for i = 1:length(n)

    tTotal = 0; % value for accumulating total time spent on the computations
    for j = 1:trials
        tTotal = tTotal + reliabilityAwareIoT(n(i), n(i), precision, failure_rate, recovery_rate);
    end
    
    resultRaIoT(i) = tTotal/trials; % average time needed to spent on computations
    fprintf("Reliability-Aware IoT: finished estimation for %i devices, estimated time is %s [s]\n", n(i), resultRaIoT(i))
end

% Save workspace data
% filename = sprintf('lab_computation_final_%s.mat', datestr(now,'dd-mm-yyyy_HH-MM'));
% save(filename);
% save("finalComputation1.mat")

%% Measurement: CORE --> takes around 3 hours to compute on 3.5 GHz processor
latencySLA = [20*precision, 1*precision, 5*precision, 1.5*precision]; % latency per SLA in [ms] for each component
availabilitySLA = [0.99, 0.99, 0.99, 0.99]; % availability per SLA for each component

wPr = [0.5, 0.15, 0.3, 0.05]; % workload priorities
lPr = [0.4, 0.15, 0.4, 0.05]; % latency priorities
aPr = [0.6, 0.05, 0.15, 0.1]; % availibility priorities
tPr = [0.2, 0.45, 0.35]; % vector with total priorities over computed domains

resultCore = zeros(1,length(n)); % vector containing average time needed for schema with certain number of devices to finish computations

for i = 1:length(n) % n(1) is 0, not valid case

    tTotal = 0; % value for accumulating total time spent on the computations
    for j = 1:trials
        tTotal = tTotal + ertCore(n(i), precision, latencySLA, availabilitySLA, wPr, lPr, aPr, tPr);
    end
    
    resultCore(i) = tTotal/trials; % average time needed to spent on computations
    fprintf("ertCORE: finished estimation for %i devices, estimated time is %s [s]\n", n(i), resultCore(i))
end

% Save workspace data
% filename = sprintf('lab_computation_ertCore_%s.mat', datestr(now,'dd-mm-yyyy_HH-MM'));
% save(filename);
% save("finalComputation1.mat")

%% Measurement: Reliability of a Thing --> takes around 6 days 2 hours to compute on 3.5 GHz processor
resultRoaT = zeros(1,length(n)); % vector containing average time needed for schema with certain number of devices to finish computations
gamma = 0.5; % special parameter from PageRank formula, specifying minimal reliability of a thing

for i = 1:length(n)

    tTotal = 0; % value for accumulating total time spent on the computations
    for j = 1:trials
        tTotal = tTotal + thingReliability(n(i), precision, gamma);
    end
    
    resultRoaT(i) = tTotal/trials; % average time needed to spent on computations
    fprintf("Reliability of a Thing: finished estimation for %i devices, estimated time is %s [s]\n", n(i), resultRoaT(i))
end

% Save workspace data
% filename = sprintf('lab_computation_thingReliability_%s.mat', datestr(now,'dd-mm-yyyy_HH-MM'));
% save(filename);
% save("finalComputation1.mat")


%% Making a plot
figure(1);
plot(n, resultCore, '-X');
hold on;
plot(n, resultRoaT, '-O');
plot(n, resultRaIoT, '-P');
hold off;

xlabel("Number of systems [-]");
ylabel("Time [s]");
legend("ert-CORE", "Relibility of a Thing", "Reliability-Aware IoT");
grid on;
title("Reliability models time complexity");
axis tight;
xlim([0,1000]);

print -deps epsTimeCmplxty

%% Makeing a plot for first 300 devices
figure(2);
plot(n, resultCore, '-X');
hold on;
plot(n, resultRoaT, '-O');
plot(n, resultRaIoT, '-P');
hold off;

xlabel("Number of systems [-]");
ylabel("Time [s]");
legend("ert-CORE", "Relibility of a Thing", "Reliability-Aware IoT");
grid on;
title("Reliability models time complexity");
axis tight;
xlim([0,300]);

print -deps epsTimeCmplxty300


%% Computing ratio
ratio1 = resultRoaT(length(n))/resultCore(length(n));
fprintf("ertCORE is %.2f times faster in computations with 1 000 devices than Reliability of a Thing\n", ratio1);
ratio2 = resultRaIoT(length(n))/resultCore(length(n));
fprintf("ertCORE is %.2f times faster in computations with 1 000 devices than Reliability-Aware IoT\n", ratio2);
