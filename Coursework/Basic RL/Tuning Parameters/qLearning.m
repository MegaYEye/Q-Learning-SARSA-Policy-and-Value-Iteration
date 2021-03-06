function [v, pi, J] = qLearning(model, maxit, maxeps, epsilon, alpha)

% initialize the value function
Q = zeros(model.stateCount, 4);
pi = ones(model.stateCount, 1);  
policy = ones(model.stateCount, 1);

Cum_Rwd = zeros(length(maxeps), 1);

for i = 1:maxeps,
    % every time we reset the episode, start at the given startState
    s = model.startState; 
    
    a = epsilon_greedy_policy(Q(s,:), epsilon);  %a = 1;  
      
    Rwd = 0;
    
    for j = 1:maxit,
%       PICK AN ACTION
%       a = 1;
        p = 0;
        r = rand;

        for s_ = 1:model.stateCount,
            p = p + model.P(s, s_, a);
            if r <= p,
                break;
            end
        end
                 
        %get action from behaviour policy - epsilon_greedy wrt Q(s,a)
        %action from behaviour policy
        a_  = epsilon_greedy_policy(Q(s, :), epsilon);
                         
        %take action, observe r 
        Reward = model.R(s,a);
        
        Rwd = Rwd + model.gamma * Reward;   %if taking discounted rewards
        
        TargetQ = Reward + model.gamma * max(Q(s_, :));

        Q(s,a) = Q(s,a) + alpha * [ TargetQ - Q(s,a) ];
        
        s = s_;
        a = a_;
        
        [~, idx] = max(Q(s,:));
        policy(s,:) = idx;
        q = Q(:, idx);
        

            
        % SHOULD WE BREAK OUT OF THE LOOP?              
         if s == model.goalState
             if Reward == model.R(model.goalState, a)
                break;
             end
         break;
         end
    end
    
    Cum_Rwd (i)  = Rwd;
        
end

pi = policy;
v = q;
J = Cum_Rwd;

end

