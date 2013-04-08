%{
    Grid States numbering as follows:
          3 4 5 10 
          2 X 6 11   
          1 9 8 7
 %}


function [] = mdpVI(reward) % reward is the reward function
gamma=0.99; e=0.0001; T = buildTransMat();
n = 11; R = [reward*ones(1,n-2) 1 -1]; % n is # of states
U = zeros(n,1); U_nex = zeros(n,1);
step=0; check = e*(1-gamma)/gamma; delta=check;
while delta >= check
    U = U_nex; delta=0;
    for s =1:n
        
        U_nex(s) = R(s) + gamma*max(squeeze(T(s,:,:))*U_nex);
        U_nex'
        diff = abs(U_nex(s)-U(s));
        if diff>delta, delta = diff; end
    end
    step=step+1;
end
step
delta
U'

Policy = [];
for s = 1:9
    [~,a] = max(squeeze(T(s,:,:))*U);
    Policy = [Policy; s a];
end

printPolicy(Policy);
end

function [T] = buildTransMat()

T = zeros(11,4,11); % T(s,a,s')
T(1,1,1) = 0.1; T(1,2,2) = 0.8; T(1,3,9) = 0.1; % From state:1
T(2,1,2) = 0.1; T(2,2,3) = 0.8; T(2,3,2) = 0.1; % From state:2
T(3,1,3) = 0.1; T(3,2,3) = 0.8; T(3,3,4) = 0.1; % From state:3
T(4,1,3) = 0.1; T(4,2,4) = 0.8; T(4,3,5) = 0.1; % From state:4
T(5,1,4) = 0.1; T(5,2,5) = 0.8; T(5,3,10) = 0.1; % From state:5
T(6,1,6) = 0.1; T(6,2,5) = 0.8; T(6,3,11) = 0.1; % From state:6
T(7,1,8) = 0.1; T(7,2,11) = 0.8; T(7,3,7) = 0.1; % From state:7
T(8,1,9) = 0.1; T(8,2,6) = 0.8; T(8,3,7) = 0.1; % From state:8
T(9,1,1) = 0.1; T(9,2,9) = 0.8; T(9,3,8) = 0.1; % From state:9
end

function [] = printPolicy(Policy)

state_map = [1 1 1; 2 1 2; 3 1 3; 4 2 3; 5 3 3; 6 3 2; 7 4 1; 8 3 1; 9 2 1];
action_map = [1 'l'; 2 'u'; 3 'r'; 4 'd'];
for s = 1:9
    fprintf('%d %d %s \n', state_map(s,2), state_map(s,3), action_map(Policy(s,2),2));
end
Policy
end