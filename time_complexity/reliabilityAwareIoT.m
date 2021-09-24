%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This reliability model is taken from the following publication:
% V Kumar, R Vidhyalakshmi Reliability Aspect of Cloud Computing Environment
% https://link.springer.com/content/pdf/10.1007/978-981-13-3023-0.pdf
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function time = reliabilityAwareIoT(i, j, precision, failure_rate, recovery_rate)
%% Generating data
% precision=1000;
% i = n; % number of tasks - hardcoded?  Possible variations: more than VMs, less than VMs, equal as VMs...
% j = n; % number of VMs

d = zeros(1,i); % vector with deadlines for each VM
x = zeros(i,j); % matrix indicating whether this task i was assigned (1) to the VM j or not (0) -- should I put tough constraint: 1 task per VM? It could reduce computation time
c = zeros(1,j); % computing capacity per VM in instructions per second
l = zeros(1,i); % length of the instructions (per task)
% failure_rate = 3; % failure rate
lambda = poissrnd(failure_rate,1,j); % random Poisson distributed numbers (failure rate)
% recovery_rate = 7; % recovery time parameter of exponential distribution
u = exprnd(recovery_rate,1,j); % random Exponentially distributed numbers (recovery time rate)

t = zeros(i,j); % Total average task processing time per VM
v = 0; % number of tasks whose QoS requirements were not satisfied
reliability = 0; % final reliability of the system

%% Filling in some data
for m = 1:length(d)
   d(m) = randi(10)*randi(precision)/precision; %% We don't care about results, we care only about time complexity
   l(m) = randi(precision);
end

for q = 1:i
   for w = 1:j
      x(q,w) = round(randi(precision)/precision);
   end
end

for m = 1:length(c)
   c(m) = randi(precision); 
end


%% Actual computation

tStart = tic;
% Straightforward implementation
% % Calculating processing time
% for q = 1:i
%    for w = 1:j
%       t(q,w) = (1+lambda(w)/u(w))*l(q)/c(w); 
%    end
% end
% 
% % Calculating number of tasks whose QoS requirements are violated
% for q = 1:i
%     for w = 1:j
%         temp = t(q,w)*x(q,w)-d(q);
%         if temp > 0
%             v = v + 1;
%         end
%     end
% end

% OPTIMIZATION
for q = 1:i
   for w = 1:j
      t(q,w) = (1+lambda(w)/u(w))*l(q)/c(w);
      temp = t(q,w)*x(q,w)-d(q);
      if temp > 0
          v = v + 1;
      end
   end
end

% Final reliability of a system
reliability = 1 - v/sum(sum(x)); % Is it correctlike that? Shouldn't it be just i? It doesn't matter for estimating time complexity

tEnd = toc(tStart);
time = tEnd;

end