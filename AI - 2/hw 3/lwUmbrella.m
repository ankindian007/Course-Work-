function [P,variance] = lwUmbrella(numSamples, numSteps, evidence)

P_r = [0.3 0.7]; P_u = [0.9 0.1; 0.1 0.9]; % Conditional Prob Tables
U = evidence+1; % Evidences vector (1 X numSteps)
R = []; % Hidden variable vector
Weights = []; % Sample probability vector
P = []; % probability set over each iteration

for n = 1:200
    for n = 1:numSamples
        x = (rand >= 0.5)+1; % intial sample
        w = 1; % initalize weight of evidence
        
        for i = 1:numSteps
            x = (rand <= P_r(x))+1;
            w = w * P_u(U(i),x); % weight accomodation as per the sample
        end
        
        R = [R x]; % Sampled R_numStep value T=1/F=0.
        Weights = [Weights w];% Weighted sampling probability.
    end
    
    w_t = sum(Weights(R==2));
    w_f = sum(Weights(R==1));
    P = [P w_t/(w_t + w_f)];
end
P = mean(P);
variance = var(P);
end

%{
        if x==2  % true parent
            x = (rand <= P_r(x))+1; % sampling for T need < P_r(x=2)=0.7
        else % false parent
            x = (rand <= P_r(x))+1; % sampling for T need < P_r(x=1)=0.3
        end
%}