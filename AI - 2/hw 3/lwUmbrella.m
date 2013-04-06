function [P,variance] = lwUmbrella(numSamples, numSteps, evidence)

P_r = [0.3 0.7]; P_u = [0.1 0.9];
U = evidence+1; % Evidences vector (1 X numSteps)
R = zeros(1,numSteps); % Hidden variable vector (1 X numSteps)

for n = 1:numSamples
    R(1,1) = (rand >= 0.5)+1; % Equal probability of first hidden variable.
    w = 1; % initalize weight of evidence
    S = R(1,1); % initialize prob of non-evidence
    
    for i = 1:numSteps
        w = w*P_u(U(i));
    end
    w
    for i = 2:numSteps
        i
        R(1,i-1)
        x = (rand >= 0.5)+1;
        
        S = S * P_r(R(1,i-1));
    end
    
    P = [P w*S]; % Weighted sampling probability.
end
variance = var(P);
end