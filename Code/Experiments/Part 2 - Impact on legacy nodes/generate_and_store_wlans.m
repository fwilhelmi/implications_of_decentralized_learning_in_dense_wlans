%%% **********************************************************************
%%% * Implications of Decentralized Learning in Dense WLANs              *
%%% *    - Submission to 1st workship of FG-ML5G                         *
%%% * Author: Francesc Wilhelmi (francisco.wilhelmi@upf.edu)             *
%%% * Co-Authors: B. Bellalta, C. Cano, A. Jonsson                       *
%%% * Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi        *
%%% * GitHub home: https://github.com/fwilhelmi                          *
%%% * Repository: implications_of_decentralized_learning_in_dense_wlans  *
%%% **********************************************************************

%% DEFINE THE VARIABLES TO BE USED
constants_mabs
constants_ctmn
system_conf

nWlans = 8;
draw_map = 0;
random_initial_configuration = 1;

numberOfScenarios = 50;

% Generate scenarios
for i = 1 : numberOfScenarios

    wlans_container{i} = generate_wlan_randomly(nWlans, ...
        random_initial_configuration, draw_map);

end
% Save scenarios into a variable
save('wlans_container.mat', 'wlans_container')

% Compute the maximum achievable throughput per WLAN in each scenario
upperBoundThroughputPerWlan = zeros(numberOfScenarios, nWlans);
for i = 1 : numberOfScenarios
    disp([' - Computing upper bound throughput in scenario ' num2str(i) ' of ' num2str(numberOfScenarios)])
    % Copy data into aux variable
    wlansAux = wlans_container{i};
    % Find the index of the initial action taken by each WLAN    
    initialActionIndexPerWlan = zeros(1, nWlans);
    for j = 1 : nWlans
        [~,indexCca] = find(ccaActions==wlansAux(j).cca);
        [~,indexTpc] = find(txPowerActions==wlansAux(j).tx_power);
        initialActionIndexPerWlan(j) = indexes2val(wlansAux(j).primary, ...
            indexCca, indexTpc, size(channelActions,2), size(ccaActions,2));
    end
    % Initialize the indexes of the taken action
    actionIndexPerWlan = initialActionIndexPerWlan;              
    % Compute the maximum achievable throughput per WLAN
    upperBoundThroughputPerWlan(i,:) = compute_max_bound_throughput(wlansAux, ...
        max(txPowerActions), max(ccaActions));    
end
% Save upper bound throughputs into a variable
save('upperBoundThroughputPerWlan.mat', 'upperBoundThroughputPerWlan')

% To select a specific WLAN from a given scenario:
% wlans_container{j}(i) -> WLAN "i" in scenario "j"