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
legend("ERT-CORE", "Relibility of a Thing", "Reliability-Aware IoT");
grid on;
title("Time complexity estimation");
axis tight;
xlim([0,1000]);

print -deps epsTimeCmplxty

%% Makeing a plot for first 300 devices
% figure(2);
% plot(n, resultCore, '-X');
% hold on;
% plot(n, resultRoaT, '-O');
% plot(n, resultRaIoT, '-P');
% hold off;
% 
% xlabel("Number of systems [-]");
% ylabel("Time [s]");
% legend("ert-CORE", "Relibility of a Thing", "Reliability-Aware IoT");
% grid on;
% title("Time complexity estimation");
% axis tight;
% xlim([0,300]);
% 
% print -deps epsTimeCmplxty300

%% Graphs approximation
load('finalComputation1.mat');

% Getting a shape of the curve for Reliability-Aware IoT
f1 = polyfit(n, resultRaIoT, 2); % with degree higher than 4 Matlab warns that the polynom is badly conditioned

% Generating an X-axis with 100 points to plot the approximated curve
% against
x1 = linspace(1, 1000);

% Getting values of the approximated function 
vals1 = polyval(f1, x1);

% Getting a shape of the curve for Reliability of a Thing
f2 = polyfit(n, resultRoaT, 2); % with degree higher than 4 Matlab warns that the polynom is badly conditioned

% Generating an X-axis with 100 points to plot the approximated curve
% against
x2 = linspace(1, 1000);

% Getting values of the approximated function 
vals2 = polyval(f2, x2);

% Getting a shape of the curve for ERT-CORE
f3 = polyfit(n, resultCore, 1); % with degree higher than 4 Matlab warns that the polynom is badly conditioned

% Generating an X-axis with 100 points to plot the approximated curve
% against
x3 = linspace(1, 1000);

% Getting values of the approximated function 
vals3 = polyval(f3, x3);

% Plotting the graph of all approximated functions against theirs reference
% values
figure(3);
% Plotting approximated graph and reference values for Reliability-Aware
% IoT
plot(x1, vals1, 'gx-');
hold on;
grid on;
plot(n, resultRaIoT, 'go');

% Plotting approximated graph and reference values for Reliability of a
% Thing
plot(x2, vals2, 'bx-');
plot(n, resultRoaT, 'bo');

% Plotting approximated graph and reference values for ERT-CORE
plot(x3, vals3, 'rx-');
plot(n, resultCore, 'ro');
hold off;

axis tight;
xlim([0,1000]);
xlabel("Number of systems [-]");
ylabel("Time [s]");
title("Time complexity approximation");
legend("Reliability-Aware IoT", "", "Reliability of a Thing", "", "ERT-CORE", "");

%% Using the approximation and going beyond 1 000 systems
% Generating an X-axis with 100 points to plot the approximated curve
% against
x = linspace(1, 1000000);

% Getting values of the approximated function for Reliability-Aware IoT
raIoTApproximation = polyval(f1, x);

% Getting values of the approximated function for Reliability of a Thing
roatApproximation = polyval(f2, x);

% Getting values of the approximated function for ERT-CORE
ertCoreApproximation = polyval(f3, x);

% Making a plot
figure(4);
plot(x, raIoTApproximation, 'gx-');
hold on;
grid on;
plot(x, roatApproximation, "bx-");
plot(x, ertCoreApproximation, "rx-");
axis tight;

xlabel("Number of systems [-]");
ylabel("Time [s]");
title("Approximated time complexity curves");
legend("Reliability-Aware IoT", "Reliability of a Thing", "ERT-CORE");

print -deps timeCmplxtyApproximation


%% Computing ratio
ratio1 = resultRoaT(length(n))/resultCore(length(n));
fprintf("ertCORE is %.2f times faster in computations with 1 000 systems than Reliability of a Thing\n", ratio1);
ratio2 = resultRaIoT(length(n))/resultCore(length(n));
fprintf("ertCORE is %.2f times faster in computations with 1 000 systems than Reliability-Aware IoT\n", ratio2);

ratio3 = roatApproximation(length(x))/ertCoreApproximation(length(x));
fprintf("ertCORE is %.2f times faster in computations with %d systems than Reliability of a Thing\n", ratio3, x(length(x)));
ratio4 = raIoTApproximation(length(x))/ertCoreApproximation(length(x));
fprintf("ertCORE is %.2f times faster in computations with %d systems than Reliability-Aware IoT\n", ratio4, x(length(x)));
