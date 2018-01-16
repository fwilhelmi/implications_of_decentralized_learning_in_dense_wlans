% Multi-Agent Reinforcement Learning Methods to Minimize OBSS Interferences
% Authors - Francesc Wilhelmi, Boris Bellalta, Anders Jonsson, Cristina Cano

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
disp('EXPERIMENT 2-3 INDIVIDUAL REWARD IN THE EXPOSED SCENARIO')
disp('-----------------------')

%% DEFINE THE VARIABLES TO BE USED

% Generate constants 
constants_ctmn
constants_mabs
system_conf

%% GENERATE THE SCENARIO ACCORDING TO DEFINED VARIABLES

disp('Processing WLAN input...')
% File containing WLANs initial configuration
fileName = './Input/grid_scenario/grid_4_wlans_full_overlapping.csv';
[wlans, nWlans] = generate_wlans(fileName);

rewardType = REWARD_INDIVIDUAL;     % Type of reward: selfish or cooperative
sharedRewardType = 0;               % Null shared reward, does not apply in the selfish case
convergenceActivated = true;       % Determine convergence according to "check_ts_convergence" function
convergenceType = CASE_CONVERGENCE_TYPE_2;                % Type of convergence (avg. regret, estimated reward...)

%% IMPLEMENT MABs (EPSILON-GREEDY)

disp(' * Executing MABs (Thompson sampling):')
disp(['    - n_wlans: ' num2str(size(wlans, 2))])
disp(['    - channels: ' num2str(channelActions)])
disp(['    - Tx power levels: ' num2str(txPowerActions)])
disp(['    - CCA levels: ' num2str(ccaActions)])
  
[tptEvolutionPerWlan, totalTimesArmHasBeenPlayed, totalEstimatedReward, totalExperiencedRegret]  = ...
    thompson_sampling(wlans, rewardType, sharedRewardType, convergenceActivated, convergenceType);
   
%% PLOT THE RESULTS

displayResults = 1;
displayAnimation = 0;

if displayResults
    plot_results_individual_performance_thompson_sampling(wlans, tptEvolutionPerWlan, ...
        totalTimesArmHasBeenPlayed{totalIterations}, totalExperiencedRegret, 'TS', 2);
end

if displayAnimation
    plot_animation_gaussian_estimates(totalEstimatedReward, totalTimesArmHasBeenPlayed);
    animation_bar_plot(totalMeanReward, 'Mean reward')
    animation_bar_plot(totalEstimatedReward, 'Estimate reward')
end

% Save Workspace
save(['./Output/EXPERIMENT_2_3' endTextOutputFile '_workspace.mat'])