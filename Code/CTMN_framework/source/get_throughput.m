%%% *********************************************************************
%%% * Spatial-Flexible CTMN for WLANs                                   *
%%% * Author: Sergio Barrachina-Munoz (sergio.barrachina@upf.edu)       *
%%% * Copyright (C) 2017-2022, and GNU GPLd, by Sergio Barrachina-Munoz *
%%% * GitHub repository: https://github.com/sergiobarra/SFCTMN          *
%%% * More info on https://www.upf.edu/en/web/sergiobarrachina          *
%%% *********************************************************************

function [ throughput ] = get_throughput(  wlans, num_wlans, p_equilibrium, ...
    S_cell, PSI_cell, SINR_cell, mcs_per_wlan, power_from_ap )
    %GET_THROUGHPUT return the throughput of each WLAN
    % Input:
    %   - prob_tx_in_num_channels: array whose element w,n is the probability of WLAN w of transmiting in n channels
    %   - num_wlans: number of WLANs in the system
    %   - num_channels_system: number of channels in the system
    % Output:
    %   - throughput: array whose element w is the average throughput of WLAN w.
    
    %load('constants_ctmn.mat');  % Load constants into local workspace
    constants_ctmn
    
    
    throughput = zeros(num_wlans,1);
          
    for wlan_ix = 1 : num_wlans
        
%         disp([' * WLAN ix: ' num2str(wlan_ix)])        
        
        throughput(wlan_ix) = 0;    
        interest_power = power_from_ap(wlan_ix, wlan_ix);

        for state_ix = 1 : size(S_cell, 2)
                    
            pi_s = p_equilibrium(state_ix); % probability of being in state s          

            % PSI's index of the backward transition origin state 
            [~, origin_psi_ix] = find_state_in_set(S_cell{state_ix}, PSI_cell);
           
            sinr = SINR_cell{origin_psi_ix}(wlan_ix, wlans(wlan_ix).primary);
            if PSI_cell{origin_psi_ix}(wlan_ix, wlans(wlan_ix).primary) == 1 ...
                    && sinr > CAPTURE_EFFECT && interest_power > wlans(wlan_ix).cca
                tx_time = SUtransmission80211ax(PACKET_LENGTH, NUM_PACKETS_AGGREGATED, ...
                    CHANNEL_WIDTH_MHz, SUSS, mcs_per_wlan(wlan_ix, 1));
                rate = 1/tx_time;
                %rate = mcs_rates(1, mcs_per_wlan(wlan_ix, 1));
            else
                rate = 0;
            end
            
%             disp(['  . State ix: ' num2str(state_ix) ' (probability: ' num2str(pi_s) ')'])
%             disp(['     - SINR: ' num2str(SINR_cell{origin_psi_ix}(wlan_ix, :))])        
                                   
            throughput(wlan_ix) = throughput(wlan_ix) + rate * (1 - PACKET_ERR_PROBABILITY) ...
                * pi_s * (1 - PER);
            
%             disp(['     - rate: ' num2str(rate) ', tpt: ' num2str(throughput(wlan_ix))])  
            
        end
                   
%         for num_ch = 1 : num_channels_system
%             throughput(wlan_ix) = throughput(wlan_ix) + (1 - PACKET_ERR_PROBABILITY) * NUM_PACKETS_AGGREGATED *...
%                 PACKET_LENGTH * (MU(num_ch) * prob_tx_in_num_channels(wlan_ix, num_ch + 1)) ./ 1E6;
%         end
    end
end

