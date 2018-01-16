%%% **********************************************************************
%%% * Implications of Decentralized Learning in Dense WLANs              *
%%% *    - Submission to 1st workship of FG-ML5G                         *
%%% * Author: Francesc Wilhelmi (francisco.wilhelmi@upf.edu)             *
%%% * Co-Authors: B. Bellalta, C. Cano, A. Jonsson                       *
%%% * Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi        *
%%% * GitHub home: https://github.com/fwilhelmi                          *
%%% * Repository: implications_of_decentralized_learning_in_dense_wlans  *
%%% **********************************************************************

function [] = print_wlan_info(wlans)

    load('constants_ctmn.mat')
    
    nWlans = length(wlans);  % Number of WLANs in the system
        
    disp('WLANS info:')

    for wlan_ix = 1 : nWlans

        disp(['  - wlan ' LABELS_DICTIONARY(wlans(wlan_ix).code) ':'])
        disp(['    * primary channel: '  num2str(wlans(wlan_ix).primary)])
        disp(['    * channel range: '  num2str(wlans(wlan_ix).range(1)) ' - ' num2str(wlans(wlan_ix).range(2))])
        disp('    * positions:')
        disp(['      * ap: ('  num2str(wlans(wlan_ix).position_ap(1)) ', ' num2str(wlans(wlan_ix).position_ap(2))...
            ', ' num2str(wlans(wlan_ix).position_ap(3)) ') m'])
        disp(['      * sta: ('  num2str(wlans(wlan_ix).position_sta(1)) ', ' num2str(wlans(wlan_ix).position_sta(2))...
            ', ' num2str(wlans(wlan_ix).position_sta(3)) ') m'])
        disp(['    * Transmission power: '  num2str(wlans(wlan_ix).tx_power) ' dBm'])
        disp(['    * CCA level: '  num2str(wlans(wlan_ix).cca) ' dBm'])
        disp(['    * lambda: '  num2str(wlans(wlan_ix).lambda) ' packets/s'])
    end
    
end