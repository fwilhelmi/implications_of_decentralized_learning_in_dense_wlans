%%% **********************************************************************
%%% * Implications of Decentralized Learning in Dense WLANs              *
%%% *    - Submission to 1st workship of FG-ML5G                         *
%%% * Author: Francesc Wilhelmi (francisco.wilhelmi@upf.edu)             *
%%% * Co-Authors: B. Bellalta, C. Cano, A. Jonsson                       *
%%% * Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi        *
%%% * GitHub home: https://github.com/fwilhelmi                          *
%%% * Repository: implications_of_decentralized_learning_in_dense_wlans  *
%%% **********************************************************************

function [ estimatedRewardPerWlan, regretPerWlan ] = generate_reward(wlans, actionPerWlan, ...
    throughputPerWlan, timesArmHasBeenPlayed, rewardType, sharedRewardType, estimatedRewardPerWlan)
    
    constants_mabs
        
    nWlans = size(wlans, 2);                        % Number of WLANs in the map
    K = size(timesArmHasBeenPlayed, 2);             % Number of actions per WLAN
    rewardPerConfiguration = zeros(nWlans, K);      % Initialize the reward obtained for each configuration per WLAN

    tptArray = [];

    % Iterate for each WLAN
    for i = 1 : nWlans            
        % Check the reward type (selfish or shared)
        if rewardType == REWARD_INDIVIDUAL    
%             if wlans(i).legacy % If the WLAN is legacy, assign 0 to the reward
%                 rewardPerConfiguration(i, actionPerWlan(i)) = 0;
%             else
                rewardPerConfiguration(i, actionPerWlan(i)) = ...
                    throughputPerWlan(i) / upperBound;
                
                regretPerWlan(i) = min(1, 1 - throughputPerWlan(i) / upperBound);
                
%             end
        elseif rewardType == REWARD_JOINT
            % Build an array of throughputs for WLANs implementing TS 
            if ~wlans(i).legacy          
                tptArray = [tptArray throughputPerWlan(i)];
            end                
        else
            text = 'Wrong reward type introduced. Refer to "constants_mabs.m"';
            error(text);
        end        
    end
        
    % Iterate for each WLAN
    for i = 1 : nWlans
        % Check if WLAN "i" is legacy and if a shared reward is being used
        if rewardType == REWARD_JOINT && ~wlans(i).legacy      
            % Check if the selected joint reward is the proportional fairness
            if sharedRewardType == SHARED_REWARD_PROPORTIONAL_FAIRNESS    
                %rewardPerConfiguration(i, actionPerWlan(i)) = max(0, compute_proportional_fairness(tptArray)); %...
                rewardPerConfiguration(i, actionPerWlan(i)) = ...
                    max(0, compute_proportional_fairness(tptArray) / ...
                    compute_proportional_fairness(upperBound * ones(1, size(tptArray,2))));                          
            elseif sharedRewardType == SHARED_REWARD_INDIVIDUAL_PLUS_AGGREGATE      
                % Check if the selected joint reward is the sum of the individual and the aggregate throughput
                rewardPerConfiguration(i, actionPerWlan(i)) = ...
                    tptArray(i)/upperBound + ...     
                    sum(tptArray)/sum(upperBound*ones(1, nWlans)) * jains_fairness(tptArray);                   
            elseif sharedRewardType == SHARED_REWARD_MAX_MIN
               % Check if the selected joint reward is the minimum individual throughput for max-min maximization                     
               [min_throughput, ~] = min(tptArray);              
               rewardPerConfiguration(i, actionPerWlan(i)) = min_throughput/upperBound;      
            elseif sharedRewardType == SHARED_REWARD_MAX_MIN_AND_INDIVIDUAL
                % Check if the selected joint reward is the sum of the individual and the minimum individual throughput             
                [min_throughput, ~] = min(tptArray);  
                rewardPerConfiguration(i, actionPerWlan(i)) = 0.5*min_throughput/upperBound + 0.5*tptArray(i)/upperBound;                      
            else
                % No shared reward allowed
            end     
            % Generate the regret according to the experienced reward
            regretPerWlan(i) = min(1, 1 - rewardPerConfiguration(i, actionPerWlan(i)));                
        end 
        % Estimated reward
        estimatedRewardPerWlan(i, actionPerWlan(i)) = ...
            (estimatedRewardPerWlan(i, actionPerWlan(i)) * ...
            timesArmHasBeenPlayed(i, actionPerWlan(i)) + rewardPerConfiguration(i, actionPerWlan(i))) / ...
            (timesArmHasBeenPlayed(i, actionPerWlan(i)) + 2);                            
    end
                
end