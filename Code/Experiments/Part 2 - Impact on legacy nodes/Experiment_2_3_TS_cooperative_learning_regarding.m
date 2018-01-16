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
% By using a simple grid of 4 WLANs sharing 2 channels, we want to test the
% e-greedy method if using different numbers of iterations. We fix alpha,
% gamma and initial epsilon to the values that generated better results in
% terms of proportional fairness in the Experiment_1

clc
clear all

% Add paths to methods folders
addpath(genpath('Power Management Methods/'));
addpath(genpath('Throughput Calculation Methods/'));
addpath(genpath('Network Generation Methods/'));
addpath(genpath('Reinforcement Learning Methods/'));
addpath(genpath('Reinforcement Learning Methods/Action Selection Methods/'));
addpath(genpath('Auxiliary Methods/'));

disp('-----------------------')
disp('EXPERIMENT 3 COOPERATIVE LERANING (REGARDING LEGACY PERFORMANCE)')
disp('-----------------------')

%% DEFINE THE VARIABLES TO BE USED

% Generate constants 
constants_ctmn
constants_mabs
system_conf

%% LOAD THE SCENARIO
generate_and_store_wlans;
legacy_percentage = [0 0.25 0.5 0.75];

% Rewarding type
rewardType = REWARD_JOINT;
rewardSubtype = SHARED_REWARD_MAX_MIN_AND_INDIVIDUAL;
consderLegacy = true;

for p = 1 : size(legacy_percentage, 2)

    disp('+++++++++++++++++++++++++++++++')
    disp([' LEGACY DEVICES PERCENTAGE: ' num2str(legacy_percentage(p)*100) ' %'])    
    disp('+++++++++++++++++++++++++++++++')

    for r = 1 : size(wlans_container, 2)

        disp([' * Scenario ' num2str(r) ' of ' num2str(size(wlans_container, 2))])

        wlans_with_legacy_assignment = decide_if_wlan_learns(wlans_container{r}, legacy_percentage(p));

        [tptEvolutionPerWlan{p, r}, timesArmHasBeenPlayed{p, r}, totalMeanReward{p, r}, totalestimatedReward{p, r}]  = ...
            thompson_sampling(wlans_with_legacy_assignment, rewardType, rewardSubtype, consderLegacy);

    end

end

save('workspace_experiment_3.mat')