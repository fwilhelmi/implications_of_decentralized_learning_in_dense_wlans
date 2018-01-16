%%% **********************************************************************
%%% * Implications of Decentralized Learning in Dense WLANs              *
%%% *    - Submission to 1st workship of FG-ML5G                         *
%%% * Author: Francesc Wilhelmi (francisco.wilhelmi@upf.edu)             *
%%% * Co-Authors: B. Bellalta, C. Cano, A. Jonsson                       *
%%% * Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi        *
%%% * GitHub home: https://github.com/fwilhelmi                          *
%%% * Repository: implications_of_decentralized_learning_in_dense_wlans  *
%%% **********************************************************************

function wlans_output = decide_if_wlan_learns(wlans_input, legacy_percentage)
% decide_if_wlan_learns - Generates a 3D network 
%   OUTPUT: 
%       * wlans_output - contains information of each WLAN in the map. For instance,
%           wlan(1) corresponds to the first one, so that it has unique parameters (x,y,z,BW,CCA,etc.)  
%   INPUT: 
%       * wlans_input: ontains information of each WLAN in the map. For instance,
%           wlan(1) corresponds to the first one, so that it has unique parameters (x,y,z,BW,CCA,etc.)  
%       * legacy_percentage - % of WLANs that are legacy    

    % Copy the input wlans object
    wlans_output = wlans_input;
    % Compute the number of WLANs
    nWlans = size(wlans_output, 2);
    % According to percentage, compute the number of legacy devices
    number_of_legacy_wlans = floor(legacy_percentage * nWlans);
    % Randomly select the indexes of the legacy WLANs
    if number_of_legacy_wlans > 0
        legacy_indexes = datasample(1:nWlans, number_of_legacy_wlans, 'Replace', false);
    else
        legacy_indexes = 0;
    end
    
    % Fill the "legacy" field of each WLAN, according to the calculations done
    for w = 1 : size(wlans_output, 2)                
        if find(legacy_indexes == w) > 0
            wlans_output(w).legacy = 1;
        else
            wlans_output(w).legacy = 0;
        end        
    end
    
end