%%% ************************************************************************
%%% * Collaborative Spatial Reuse in Wireless Networks via Selfish MABs    *
%%% * Author: Francesc Wilhelmi (francesc.wilhelmi@upf.edu)                *
%%% * Co-authors: C. Cano, G. Neu, B. Bellalta, A. Jonsson & S. Barrachina *
%%% * Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi          *
%%% * GitHub repository:                                                   *
%%% *   https://github.com/wn-upf/Collaborative_SR_in_WNs_via_Selfish_MABs *
%%% * More info on https://www.upf.edu/en/web/fwilhelmi                    *
%%% ************************************************************************

function [ tptExperiencedByWlan, totalTimesArmHasBeenPlayed, totalEstimatedReward, totalExperiencedRegret ] ...
    = thompson_sampling( wlans, rewardType, sharedRewardType, convergenceActivated, convergenceType, varargin )
% thompson_sampling - Given a WN, applies Thompson sampling to maximize the experienced throughput
%
%   OUTPUT: 
%       * tptExperiencedByWlan - throughput experienced by each WLAN
%         for each of the iterations done
%       * timesArmHasBeenPlayed - times each action has been played
%   INPUT: 
%       * wlan - wlan object containing information about all the WLANs
%       * rewardType - type of reward (individual or joint)
%       * varargin - extra arguments to explicitly indicate new actions
    
    %% CHECK INPUT PARAMETERS AND DETERMINE OPTIONAL ARGUMENTS
    % Use a copy of wlan to make operations
    wlansAux = wlans;
    nWlans = size(wlansAux, 2);
    
    % Load the MABs constants
    load('constants_mabs.mat')
    
    text = ['Applying Thompson Sampling to the introduced WLAN...'];
    display_with_flag(text, displayLogsTS);
    
    % Check optional variables defining a new set of actions
    try
        if size(varargin, 2) == 3
            disp('Error 1')
        elseif size(varargin, 2) == 3
            disp('Error 2')
        elseif size(varargin, 2) == 3
            % Update possible actions
            nChannels = varargin{1};
            channelActions = 1 : nChannels;
            ccaActions = varargin{2};
            txPowerActions = varargin{3};
            % Each state represents an [i,j,k] combination for indexes on "channels", "cca" and "tx_power"
            possibleActions = 1:(size(channelActions, 2) * ...
                size(ccaActions, 2) * size(txPowerActions, 2));
            K = size(possibleActions,2);   % Total number of actions
            allCombs = allcomb(1:K, 1:K);   
        end
    catch
        if size(varargin, 2) ~= 1, error('Wrong number of input arguments'); end
    end
        
    %% INITIALIZE VARIABLES AND DEFINE THE INITIAL CONFIGURATION
    
    display_with_flag(['Initialization...'], displayLogsTS);
    
    initialAction = zeros(1, nWlans);               % Initialize arm selection for each WLAN by using the initial action
    timesArmHasBeenPlayed = zeros(nWlans, K);       % Initialize the times an arm has been played
    transitionsCounter = zeros(nWlans, K^2);        % Initialize the transitions counter per WLAN
    currentAction = zeros(1, nWlans);               % Initialize the current action selected per WLAN
    
    estimatedRewardPerWlan = zeros(nWlans, K);      % Initialize the estimated reward per WLAN for each action

    % Find the index of the initial action taken by each WLAN
    for i = 1 : nWlans
        [~,indexCca] = find(ccaActions==wlansAux(i).cca);
        [~,indexTpc] = find(txPowerActions==wlansAux(i).tx_power);
        initialAction(i) = indexes2val(wlansAux(i).primary, ...
            indexCca, indexTpc, size(channelActions,2), size(ccaActions,2));
    end                  
    
    % Initialize the current selected arm to the initial action
    selectedArm = initialAction;
    % Initialize the previous action selected per WLAN
    previousAction = selectedArm;                   
    
    % Compute the throughput in each WLAN with CTMNs    
    initialThroughput = function_main_sfctmn(wlansAux);

    % Set the initial throughput experienced by each WLAN
    tptExperiencedByWlan(1, :) = initialThroughput;
       
    % For each WLAN, determine and update the rewards
    [estimatedRewardPerWlan, regretPerWlan] = generate_reward(wlansAux, selectedArm, ...
        initialThroughput, timesArmHasBeenPlayed, rewardType, sharedRewardType, estimatedRewardPerWlan);
    
    % Variables to keep track of the estimated rewards in each WLAN
    totalEstimatedReward{1} = estimatedRewardPerWlan;
    totalExperiencedRegret{1} = regretPerWlan;
    
    % Update the times an arm has been played after drawing the initial action
    for i = 1 : nWlans, timesArmHasBeenPlayed(i, initialAction(i)) = 1; end
    totalTimesArmHasBeenPlayed{1} = timesArmHasBeenPlayed;
    
    % Initialize variables to determine convergence
    wlans_that_converged = [];           % Initialization of the wlans that have converged
    countConvergence = zeros(1, nWlans);                % Initialization of the counter to assess convergence in TS
            
    %% ITERATE UNTIL CONVERGENCE OR MAXIMUM CONVERGENCE TIME 
    % START THE ALGORITHM
    text = ['Running ' num2str(totalIterations) ' iterations of Thompson sampling...'];
    display_with_flag(text, displayLogsTS);
    h = waitbar(0,'Please wait...');
    
    % ITERATE UNTIL ENDING OR CONVERGENCE IS ACHIEVED
    % (iteration 1 is considered to be the initialization)
    iteration = 2;
    while(iteration < totalIterations + 1) 
        
        display_with_flag(['Iteration ' num2str(iteration)], displayLogsTS);

        % Check if all the WLANs converged
        if convergenceActivated && size(wlans_that_converged, 2) == nWlans
            display_with_flag(['ALL THE WLANS CONVERGED!'], displayLogsTS);
            % Fill remaining iterations with the last observed performance
            for i = iteration : totalIterations
                tptExperiencedByWlan(i, :) = tptAfterAction;
                [estimatedRewardPerWlan, regretPerWlan] = generate_reward(wlansAux, selectedArm, tptAfterAction, ...
                    timesArmHasBeenPlayed, rewardType, sharedRewardType, estimatedRewardPerWlan); 
                totalEstimatedReward{i} = estimatedRewardPerWlan;
                totalExperiencedRegret{i} = regretPerWlan;
                for wlan_i = 1 : nWlans
                    timesArmHasBeenPlayed(wlan_i, selectedArm(wlan_i)) = ...
                        timesArmHasBeenPlayed(wlan_i, selectedArm(wlan_i)) + 1;  
                end
                totalTimesArmHasBeenPlayed{i} = timesArmHasBeenPlayed;
            end            
            break; % Finish Thompson sampling execution
        end

        waitbar(iteration / totalIterations)
                
        previousArm = selectedArm;
        
        order = randperm(nWlans);       % Assign turns to WLANs randomly   
        % Iterate sequentially for each agent in the random order 
        for i = 1 : nWlans              
            if wlansAux(order(i)).legacy || sum(wlans_that_converged == order(i)) > 0 
                % DO NOTHING - LEGACY WLANs DO NOT MAKE ACTIONS
                transitionsCounter(order(i), selectedArm(order(i))) = ...
                    transitionsCounter(order(i), selectedArm(order(i))) + 1;
            else
                % Select an action according to the policy
                [ selectedArm(order(i)) ] = select_action_thompson_sampling(estimatedRewardPerWlan(order(i),:), ...
                    timesArmHasBeenPlayed(order(i), :));                               
                % Update the current action
                currentAction(order(i)) = selectedArm(order(i));
                % Find the index of the current and the previous action in allCombs
                ix = find(allCombs(:, 1) == previousAction(order(i)) ...
                    & allCombs(:, 2) == currentAction(order(i)));
                % Update the previous action
                previousAction(order(i)) = currentAction(order(i));  
                % Update the transitions counter
                transitionsCounter(order(i), ix) = transitionsCounter(order(i), ix) + 1;
                % Find channel and tx power of the current action
                [a, b, c] = val2indexes(selectedArm(order(i)), ...
                    size(channelActions, 2), size(ccaActions, 2), size(txPowerActions, 2));
                % Update WN configuration
                wlansAux(order(i)).primary = a;  
                wlansAux(order(i)).range = [a a]; 
                wlansAux(order(i)).cca = ccaActions(b);
                wlansAux(order(i)).tx_power = txPowerActions(c);   
            end            
        end
                           
        % Compute the throughput in each WLAN with CTMNs
        tptAfterAction = function_main_sfctmn(wlansAux);
        tptExperiencedByWlan(iteration, :) = tptAfterAction;
        
%         selectedArm
%         tptAfterAction'
        % Determine and update the rewards of each WLAN
        [estimatedRewardPerWlan, regretPerWlan] = generate_reward(wlansAux, selectedArm, tptAfterAction, ...
            timesArmHasBeenPlayed, rewardType, sharedRewardType, estimatedRewardPerWlan);            
          
        % Update the times WN has selected the current action
        for wlan_i = 1 : nWlans
            timesArmHasBeenPlayed(wlan_i, selectedArm(wlan_i)) = ...
                timesArmHasBeenPlayed(wlan_i, selectedArm(wlan_i)) + 1;  
        end
        
        % Keep track of the estimated reward of each WLAN in each iteration
        totalEstimatedReward{iteration} = estimatedRewardPerWlan;
        % Keep track of the regret experienced by each WLAN
        totalExperiencedRegret{iteration} = regretPerWlan;
        % Keep track of the times an arm has been selected by each WLAN in each iteration
        totalTimesArmHasBeenPlayed{iteration} = timesArmHasBeenPlayed;
        
        currentEstimatedRewardPerWlan = zeros(1, nWlans);
        previousEstimatedRewardPerWlan = zeros(1, nWlans);
        for wlan_i = 1 : nWlans
            currentEstimatedRewardPerWlan(wlan_i) = totalEstimatedReward{iteration}(wlan_i, selectedArm(wlan_i));
            previousEstimatedRewardPerWlan(wlan_i) = totalEstimatedReward{iteration-1}(wlan_i, previousArm(wlan_i));
        end
        
        % Check if the algorithm has converged
        if convergenceActivated
            [wlans_that_converged, countConvergence ] = check_thompson_sampling_convergence ( ...
                convergenceType, wlans_that_converged, countConvergence, ...
                previousEstimatedRewardPerWlan, currentEstimatedRewardPerWlan, ...
                totalExperiencedRegret, iteration );                   
        end
        
        % Increase the number of 'learning iterations'
        iteration = iteration + 1; 
                
    end
           
    text = ['... Done!'];
    display_with_flag(text, displayLogsTS);
    
     close(h) 
    % END OF THE ALGORITHM 

    %% PRINT THE RESULTS    
   
    if printResultsThompsonSampling
        display_execution_information( wlansAux, rewardPerConfiguration, transitionsCounter ) ;
    end
    
end