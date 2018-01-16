%%% **********************************************************************
%%% * Implications of Decentralized Learning in Dense WLANs              *
%%% *    - Submission to 1st workship of FG-ML5G                         *
%%% * Author: Francesc Wilhelmi (francisco.wilhelmi@upf.edu)             *
%%% * Co-Authors: B. Bellalta, C. Cano, A. Jonsson                       *
%%% * Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi        *
%%% * GitHub home: https://github.com/fwilhelmi                          *
%%% * Repository: implications_of_decentralized_learning_in_dense_wlans  *
%%% **********************************************************************

% EXPERIMENT EXPLANATION:
% ...

clc
clear all

% Add paths to methods folders
addpath(genpath('Power Management Methods/'));
addpath(genpath('Throughput Calculation Methods/'));
addpath(genpath('Network Generation Methods/'));
addpath(genpath('Reinforcement Learning Methods/'));
addpath(genpath('Reinforcement Learning Methods/Action Selection Methods/'));
addpath(genpath('Auxiliary Methods/'));

disp('----------------------------------------------')
disp('EXPERIMENT 1 SELFISH LEARNING')
disp('----------------------------------------------')

% nWorkers = 2;
% parpool('local', nWorkers)

%% DEFINE THE VARIABLES TO BE USED

% Generate constants 
constants_ctmn
constants_mabs
system_conf

%% LOAD THE SCENARIO
load('wlans_container.mat');

% Rewarding type
rewardType = REWARD_INDIVIDUAL;
sharedRewardType = 0;
convergenceActivated = true;       % Determine convergence according to "check_ts_convergence" function
convergenceType = CASE_CONVERGENCE_TYPE_4;                % Type of convergence (avg. regret, estimated reward...)

legacy_percentage = [0 0.25 0.5 0.75];

scenario_id = 1;

% Iterate for each amount of legacy devices in the scenario
for s = 1 : size(legacy_percentage, 2)

    disp('+++++++++++++++++++++++++++++++')
    disp([' LEGACY DEVICES PERCENTAGE: ' num2str(legacy_percentage(s)*100) ' %'])    
    disp('+++++++++++++++++++++++++++++++')

           
    %for r = 1 : size(wlans_container, 2)
    %parfor (r = 1 : size(wlans_container, 2), nWorkers)
    %parfor (r = 1 : 2, nWorkers)
    
        
%         disp([LOG_LVL2 'Scenario ' num2str(r) ' of ' num2str(size(wlans_container, 2))])
%         
%         disp([LOG_LVL3 'Assigning legacy devices...'])
        
%         disp('     - log for testing...')
%         wlans_with_legacy_assignment = decide_if_wlan_learns(wlans_container{r}, legacy_percentage(s));
%              
%         [tptEvolutionPerWlan{s,r}, timesArmHasBeenPlayed{s,r}, totalEstimatedReward{s,r}, totalExperiencedRegret{s,r}]  = ...
%             thompson_sampling(wlans_with_legacy_assignment, rewardType, sharedRewardType, convergenceActivated, convergenceType);
        
        wlans_with_legacy_assignment = decide_if_wlan_learns(wlans_container{scenario_id}, legacy_percentage(s));
             
        [tptEvolutionPerWlan{s,scenario_id}, timesArmHasBeenPlayed{s,scenario_id}, totalEstimatedReward{s,scenario_id}, totalExperiencedRegret{s,scenario_id}]  = ...
            thompson_sampling(wlans_with_legacy_assignment, rewardType, sharedRewardType, convergenceActivated, convergenceType);
        
%         disp([LOG_LVL3 'Saving results...'])
%         % Safety save of the results
%         tptPerWlan = tptEvolutionPerWlan{s,r};
%         armsPerWlan = timesArmHasBeenPlayed{s,r};
%         estimatedRewardPerWlan = totalEstimatedReward{s,r};
%         regretPerWlan = totalExperiencedRegret{s,r};
% 
%     	parsave(sprintf('tptPerWlan_%d_%d.mat', s, r), tptPerWlan);
% 		parsave(sprintf('armsPerWlan_%d_%d.mat', s, r), armsPerWlan);
% 		parsave(sprintf('estimatedRewardPerWlan_%d_%d.mat', s, r), estimatedRewardPerWlan);
% 		parsave(sprintf('regretPerWlan_%d_%d.mat', s, r), regretPerWlan);
    %end

end
% 
delete(gcp('nocreate'))
save('workspace_experiment_1.mat')