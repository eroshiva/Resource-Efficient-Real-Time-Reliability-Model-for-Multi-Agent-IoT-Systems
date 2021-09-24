%% Clean workspace
clear all;
close all;
clc;

%% ert-CORE algorithm (enchanced real-time Customer-Oriented Reliability Estimation)
% Chceme dostat vysledny vektor [latence, zatizenost, pohotovost], ktery
% nasledne vynasobime s prioritnim rozdelenim (dle SLA/zakaznika) a
% dostaneme tim celkovou spolehlivost

%% Defining some constants
n = [1, 10, 100, 1000, 10000, 100000]; %, 1000000]; % vector with number of devices in IoT network
% n = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 200, 500, 750, 1000]; % vector with number of devices in IoT network
precision = 1000; % we want numbers to have three digits after dot
trials = 50000; % number of iterations to run on each attempt
% trials = 50;

%% Measurement: CORE --> takes around 3 hours to compute on 3.5GHz processor
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

%% Making a plot
figure(1);
% plot(n, resultCore, '-X');
semilogx(n, resultCore, '-X');

xlabel("# Devices");
ylabel("Time [s]");
legend("ert-CORE");
grid on;
title("Reliability model time complexity for logarithmic number of the devices");
% axis tickaligned;
axis tight;
% xlim([0,1000]);
% ylim([0,0.045]);

print -deps ertCoreLogDep