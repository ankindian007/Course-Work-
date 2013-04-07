function [P,variance] = pfUmbrella(numSamples, numSteps, evidence)

P_r = [0.3 0.7]; P_u = [0.9 0.1; 0.1 0.9]; % Conditional Prob Tables
U = evidence+1; % Evidences vector (1 X numSteps)
P = []; % probability set over each iteration

for n = 1:200
    
    X = (rand(1,numSamples)<=0.5)+1; % initial samples
    W = []; % initalize weight of evidence
    
    for i = 1:numSteps
        i
        size(X)
        size(P_r(X))
        X = (rand(1,numSamples) <= P_r(X))+1; % propogate
        W = P_u(U(i),X); % weighting
        size_F = round(sum(X==1)/mean(W));
        X = [ones(1,size_F) (ones(1,numSamples-size_F)+1)] % Resample
    end    
    
    P = [P sum(X==2)/numSamples];
end
P = mean(P);
variance = var(P);
end