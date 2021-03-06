%{
 Grid States numbering as follows:
    3 4 5 10 
    2 X 6 11   
    1 9 8 7
 %}

function [] = mdpPI(reward) % reward is the reward function
T = buildTransMat();
n = 11; R = [reward*ones(1,n-2) 1 -1]; % n is # of states
U = zeros(n,1); %U_nex = zeros(n,1);
P = randi([1, 4],n,1);
step=0; changed = 1;
while changed==1
    changed = 0;
    U = policyEvaluation(U,T,R,P);
    for s =1:n
        [temp,idx] = max(squeeze(T(s,:,:))*U);
        temp2 = (squeeze(T(s,P(s),:))'*U);             
        if  temp >= temp2
           P(s) = idx;
           changed = 1;
        end
        %fprintf('s =%d temp = %d idx = %d temp2 = %d temp > temp2 = %d changed = %d\n',s,temp,idx,temp2, temp>temp2, changed);
    end    

    step=step+1;
    if step ==1000        
        break;
    end
end
%step
Policy = [1:9';P(1:9)']';
printPolicy(Policy);
end

function [U] = policyEvaluation(U,T,R,P)
gamma=0.9999; %e=0.001; 
n = 11; 
U_nex = U;
step=0; 

while step <100 
    U = U_nex; %delta=0;
    for s =1:n
        U_nex(s) = R(s) + gamma*(squeeze(T(s,P(s),:))'*U_nex);    
        %diff = abs(U_nex(s)-U(s));
        %if diff>delta, delta = diff; end
    end
    step=step+1;
end
end

function [T] = buildTransMat()

T = zeros(11,4,11); % T(s,a,s')

% From state:1
T(1,1,1) = 0.9; T(1,1,2) = 0.1; % action left: 1 
T(1,2,1) = 0.1; T(1,2,2) = 0.8; T(1,2,9) = 0.1; % action up: 2
T(1,3,1) = 0.1; T(1,3,9) = 0.8; T(1,3,2) = 0.1; % action right: 3
T(1,4,1) = 0.9; T(1,4,9) = 0.1; % action down: 4

% From state:2
T(2,1,2) = 0.8; T(2,1,1) = 0.1; T(2,1,3) = 0.1; % action left: 1 
T(2,2,2) = 0.2; T(2,2,3) = 0.8; % action up: 2
T(2,3,2) = 0.8; T(2,3,3) = 0.1; T(2,3,1) = 0.1; % action right: 3
T(2,4,2) = 0.2; T(2,4,1) = 0.8; % action down: 4

% From state:3
T(3,1,3) = 0.9; T(3,1,2) = 0.1; % action left: 1 
T(3,2,3) = 0.9; T(3,2,4) = 0.1; % action up: 2
T(3,3,3) = 0.1; T(3,3,4) = 0.8; T(3,3,2) = 0.1; % action right: 3
T(3,4,3) = 0.1; T(3,4,2) = 0.8; T(3,4,4) = 0.1; % action down: 4

% From state:4
T(4,1,4) = 0.2; T(4,1,3) = 0.8; % action left: 1 
T(4,2,4) = 0.8; T(4,2,3) = 0.1; T(4,2,5) = 0.1; % action up: 2
T(4,3,4) = 0.2; T(4,3,5) = 0.8; % action right: 3
T(4,4,4) = 0.8; T(4,4,3) = 0.1; T(4,4,5) = 0.1; % action down: 4

% From state:5 
T(5,1,5) = 0.1; T(5,1,4) = 0.8; T(5,1,6) = 0.1; % action left: 1 
T(5,2,5) = 0.8; T(5,2,4) = 0.1; T(5,2,10) = 0.1; % action up: 2
T(5,3,5) = 0.1; T(5,3,10) = 0.8; T(5,3,6) = 0.1; % action right: 3
T(5,4,6) = 0.8; T(5,4,4) = 0.1; T(5,4,10) = 0.1; % action down: 4

% From state:6
T(6,1,6) = 0.8; T(6,1,5) = 0.1; T(6,1,8) = 0.1; % action left: 1 
T(6,2,6) = 0.1; T(6,2,5) = 0.8; T(6,2,11) = 0.1; % action up: 2
T(6,3,11) = 0.8; T(6,3,5) = 0.1; T(6,3,8) = 0.1; % action right: 3
T(6,4,6) = 0.1; T(6,4,8) = 0.8; T(6,4,11) = 0.1; % action down: 4

% From state:7
T(7,1,7) = 0.1; T(7,1,8) = 0.8; T(7,1,11) = 0.1; % action left: 1 
T(7,2,7) = 0.1; T(7,2,11) = 0.8; T(7,2,8) = 0.1; % action up: 2
T(7,3,7) = 0.9; T(7,3,11) = 0.1; % action right: 3
T(7,4,7) = 0.9; T(7,4,8) = 0.1; % action down: 4

% From state:8
T(8,1,8) = 0.1; T(8,1,9) = 0.8; T(8,1,6) = 0.1; % action left: 1 
T(8,2,6) = 0.8; T(8,2,9) = 0.1; T(8,2,7) = 0.1; % action up: 2
T(8,3,8) = 0.1; T(8,3,7) = 0.8; T(8,3,6) = 0.1; % action right: 3
T(8,4,8) = 0.8; T(8,4,9) = 0.1; T(8,4,7) = 0.1; % action down: 4

% From state:9
T(9,1,9) = 0.2; T(9,1,1) = 0.8; % action left: 1 
T(9,2,9) = 0.8; T(9,2,1) = 0.1; T(9,2,8) = 0.1; % action up: 2
T(9,3,9) = 0.2; T(9,3,8) = 0.8; % action right: 3
T(9,4,9) = 0.8; T(9,4,1) = 0.1; T(9,4,8) = 0.1; % action down: 4
end

function [] = printPolicy(Policy)

grid_map = [1 3 1; 2 2 1; 3 1 1; 4 1 2; 5 1 3; 6 2 3; 7 3 4; 8 3 3; 9 3 2];
state_map = [1 1 1; 2 1 2; 3 1 3; 4 2 3; 5 3 3; 6 3 2; 7 4 1; 8 3 1; 9 2 1];
action_map = [1 'l'; 2 'u'; 3 'r'; 4 'd'];
for s = 1:9
    fprintf('%d %d %s \n', state_map(s,2), state_map(s,3), action_map(Policy(s,2),2));
    grid(grid_map(s,2), grid_map(s,3)) = action_map(Policy(s,2),2);
end
grid
end