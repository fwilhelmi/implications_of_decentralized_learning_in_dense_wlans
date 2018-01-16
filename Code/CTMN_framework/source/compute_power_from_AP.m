function [ Power_STA_from_AP ] = compute_power_from_AP( wlans, distance_ap_sta, carrier_frequency, path_loss_model )
    %compute_data_rate computes the data rate of each WLAN in every channel in every global state. 
    % Input:
    %   - wlans: array of structures with wlans info
    % Output: 
    %   - Power_from_AP: array of power sensed in the STA from its AP (in dBm)

%     load('constants_ctmn.mat');  % Load constants into local workspace
    constants_ctmn
    
    num_wlans = length(wlans);  % Number of WLANs
    
    Power_STA_from_AP = zeros(1, num_wlans);
    
    for i = 1 : num_wlans
        
        Power_STA_from_AP(i) = compute_power_received(distance_ap_sta(i, i), wlans(i).tx_power, ...
            GAIN_TX_DEFAULT, GAIN_RX_DEFAULT, carrier_frequency, path_loss_model );
        
    end
        
end

