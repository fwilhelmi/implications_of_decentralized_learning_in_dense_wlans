%%% **********************************************************************
%%% * Implications of Decentralized Learning in Dense WLANs              *
%%% *    - Submission to 1st workship of FG-ML5G                         *
%%% * Author: Francesc Wilhelmi (francisco.wilhelmi@upf.edu)             *
%%% * Co-Authors: B. Bellalta, C. Cano, A. Jonsson                       *
%%% * Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi        *
%%% * GitHub home: https://github.com/fwilhelmi                          *
%%% * Repository: implications_of_decentralized_learning_in_dense_wlans  *
%%% **********************************************************************

function [ throughput_per_configuration ] = compute_throughput_all_combinations( wlans )
% Computes the throughput experienced by each WLAN for all the possible
% combinations of Channels, CCA and TPC 
%
%   NOTE: the "allcomb" function does not hold big amounts of combinations 
%   (a reasonable limit is 4 WLANs with 2 channels and 4 levels of TPC)
%
% OUTPUT:
%   * throughputPerConfiguration - tpt achieved by each WLAN for each configuration (Mbps)
% INPUT:
%   * wlans - object containing all the WLANs information 

    constants_ctmn
    constants_mabs

    disp('      - Computing the throughput for all the combinations...')

    % Generate a copy of the WLAN object to make modifications
    wlansAux = wlans;    
    nWlans = size(wlansAux, 2);  
        
    log_k = round(size(possibleComb, 1)/10);
    throughput_per_configuration = zeros(size(possibleComb, 1), nWlans);
    
    % Try all the combinations
    for i = 1:size(possibleComb, 1)
        
        if mod(i, log_k) == 0
             disp(['Progress: ' num2str(round(i*100/size(possibleComb, 1))) ' %'])
        end
        
        % Change WLANs configuration 
        for j = 1:nWlans 
            [ch, cca_ix, tpc_ix] = val2indexes(possibleComb(i,j), ...
                nChannels, size(ccaActions, 2), size(txPowerActions, 2));
            wlansAux(j).primary = ch;
            wlansAux(j).range = [ch ch];
            wlansAux(j).cca = ccaActions(cca_ix);
            wlansAux(j).tx_power = txPowerActions(tpc_ix);       
        end
        % Compute the Throughput and store it
        throughput_per_configuration(i,:) = function_main_sfctmn(wlansAux);
        
    end
    
end