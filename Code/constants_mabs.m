%%% **********************************************************************
%%% * Implications of Decentralized Learning in Dense WLANs              *
%%% *    - Submission to 1st workship of FG-ML5G                         *
%%% * Author: Francesc Wilhelmi (francisco.wilhelmi@upf.edu)             *
%%% * Co-Authors: B. Bellalta, C. Cano, A. Jonsson                       *
%%% * Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi        *
%%% * GitHub home: https://github.com/fwilhelmi                          *
%%% * Repository: implications_of_decentralized_learning_in_dense_wlans  *
%%% **********************************************************************

% LEARNING ITERATIONS AND REPETITIONS

totalIterations = 500;            % Maximum convergence time (one period implies the participation of all WLANs)
minimumIterationToConsider = 250;   % Iteration from which to consider the obtained results
totalRepetitions = 5;             % Number of TOTAL repetitions to take the average
maxIndividualIterations = 10;

% ACTIONS

nChannels = 2;                      % Number of available channels (from 1 to n_channels)
channelActions = 1 : nChannels;     % Possible channels
ccaActions = [-42 -82];             % CCA levels (dBm)
txPowerActions = [1 20];            % Transmit power levels (dBm)

% Each state represents an [i,j,k] combination for indexes on "channels", "cca" and "tx_power"
possibleActions = 1:(size(channelActions, 2) * ...
    size(ccaActions, 2) * size(txPowerActions, 2));
K = size(possibleActions,2);        % Total number of actions
allCombs = allcomb(1:K, 1:K);

% Structured array with all the combinations (for computing the optimal)
possibleComb = allcomb(possibleActions, possibleActions, possibleActions, possibleActions);

randomInitialConfiguration = false;    % Variable for assigning random channel/tx_power/cca at the beginning

% DISPLAY AND PLOT OPTIONS

plotResultsThompsonSampling = true;    % To plot or not the results at the end of the simulation
printResultsThompsonSampling = false;  % To print info after Bandits implementation (1) or not (0)
saveConsoleLogs = false;               % To save logs into a file or not
displayLogsTS = false;                  % Variable to display logs during the TS execution
drawMap = false;                       % Variable for drawing the map when generating it through "generate_wlan_from_file" or "generate_wlan_randomly"

% REWARDS DEFINITION

% Type of reward (shared or individual)
REWARD_INDIVIDUAL = 0;      % individual throughput
REWARD_JOINT = 1;           % joint proportional fairness
REWARD_CENTRALIZED = 2;     % joint proportional fairness

% Types of joint rewards

SHARED_REWARD_PROPORTIONAL_FAIRNESS = 1;        % reward = proportional fairness
SHARED_REWARD_MAX_MIN = 2;                      % reward = min throughput
SHARED_REWARD_INDIVIDUAL_PLUS_AGGREGATE = 3;    % reward = agg*JFI + individual
SHARED_REWARD_MAX_MIN_AND_INDIVIDUAL = 4;       % reward = min + inidividual

% CONVERGENCE CONDITIONS

% Convergence types
CASE_CONVERGENCE_TYPE_1 = 1;    % Check the last X estimated rewards
CASE_CONVERGENCE_TYPE_2 = 2;    % Check the variability of the regret (individual)
CASE_CONVERGENCE_TYPE_3 = 3;    % Check the variability of the regret (collective)
CASE_CONVERGENCE_TYPE_4 = 4;    % Hybrid method of cases 2 and 3 (collective)
% Variables for CASE_CONVERGENCE_TYPE_1
numMaxIterationsConvergence = 10;    % Number of needed iterations without changes to assess convergence        
allowed_error = 0.05;                % Maximum allowed error between measurements
% Variables for CASE_CONVERGENCE_TYPE_2
epsilon_regret = 0.1;               % Maximum allowed variability for the average cumulative regret (R_T/T) 

% OPTIMUM RESULTS FOR PLOTTING PURPOSES

upperBound = 132.8180;  % Optimum throughput isolation
% Optimum results (4 WLANs grid - Cases 1a and 1b) 
optimum_agg_tpt_case_1 = 531.272;
optimum_ind_tpt_case_1 = optimum_agg_tpt_case_1/4;
optimum_pf_case_1 = 19.5559;
% Optimum results (4 WLANs grid - Case 2)
optimum_agg_tpt_case_2 = 266.8408;
optimum_ind_tpt_case_2 = optimum_agg_tpt_case_2/4;
optimum_pf_case_2 = 16.8014;
optimum_agg_tpt = [optimum_agg_tpt_case_1 optimum_agg_tpt_case_2];
optimum_ind_tpt = [optimum_ind_tpt_case_1 optimum_ind_tpt_case_2];

% OUTPUT INFORMATION

pathFigures = './Output/';
endTextOutputFile = ['_' num2str(totalIterations) '_iterations'];
save('constants_mabs.mat');  % Save constants into current folder