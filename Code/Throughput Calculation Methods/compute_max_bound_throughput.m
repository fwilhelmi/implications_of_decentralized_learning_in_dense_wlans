%%% **********************************************************************
%%% * Implications of Decentralized Learning in Dense WLANs              *
%%% *    - Submission to 1st workship of FG-ML5G                         *
%%% * Author: Francesc Wilhelmi (francisco.wilhelmi@upf.edu)             *
%%% * Co-Authors: B. Bellalta, C. Cano, A. Jonsson                       *
%%% * Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi        *
%%% * GitHub home: https://github.com/fwilhelmi                          *
%%% * Repository: implications_of_decentralized_learning_in_dense_wlans  *
%%% **********************************************************************

function optimalThroughputPerWlan = compute_max_bound_throughput(wlans, maxPower, maxCCA)
% Given an WLAN (AP+STA), compute the maximum capacity achievable according
% to the power obtained at the receiver without interference
%
% OUTPUT:
%   * optimalThroughputPerWlan - maximum achievable throughput per WLAN (Mbps)
% INPUT:
%   * wlan - object containing all the WLANs information 
%   * powerMatrix - power received from each AP
%   * noise - floor noise in dBm

    wlansAux = wlans;
    nWlans = size(wlansAux, 2);
    
    % Iterate for each WLAN
    for i = 1 : nWlans
        %if wlansAux(i).legacy == 0
            wlansAux(i).tx_power = maxPower;
            wlansAux(i).cca = maxCCA;
            wlansAux(i).primary = 1;
            wlansAux(i).range = [1 1];
            % Put the other WLANs to the other channel
            for j = 1 : nWlans
                if i ~= j
                   wlansAux(j).tx_power = 1;
                   wlansAux(j).primary = 2; 
                   wlansAux(j).range = [2 2];
                end
            end
            throughputPerWlan = function_main_sfctmn(wlansAux);
            optimalThroughputPerWlan(i) = throughputPerWlan(i);
        %end
    end
    
end