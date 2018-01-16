%%% **********************************************************************
%%% * Implications of Decentralized Learning in Dense WLANs              *
%%% *    - Submission to 1st workship of FG-ML5G                         *
%%% * Author: Francesc Wilhelmi (francisco.wilhelmi@upf.edu)             *
%%% * Co-Authors: B. Bellalta, C. Cano, A. Jonsson                       *
%%% * Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi        *
%%% * GitHub home: https://github.com/fwilhelmi                          *
%%% * Repository: implications_of_decentralized_learning_in_dense_wlans  *
%%% **********************************************************************

function wlans = generate_wlan_randomly(nWlans, random_initial_conf, draw_map)
% GenerateNetwork3D - Generates a 3D network 
%   OUTPUT: 
%       * wlan - contains information of each WLAN in the map. For instance,
%       wlan(1) corresponds to the first one, so that it has unique
%       parameters (x,y,z,BW,CCA,etc.)
%   INPUT: 
%       * nWlans: number of WLANs on the studied environment

    load('constants_mabs.mat');  % Load constants into workspace
    load('system_conf.mat')      % Load system configuration constants
        
    % Generate wlan structures
    wlans = [];                                      % Array of structures containning wlans info

    for w = 1 : nWlans
        % WLAN code
        wlans(w).code = w;   
        % Initial configuration
        if random_initial_conf % Random
            wlans(w).primary = datasample(nChannels, 1);        % Pick primary channel
            wlans(w).tx_power = datasample(txPowerActions, 1);  % Pick transmission power
            wlans(w).cca = datasample(ccaActions, 1);           % Pick CCA level
        else % Greedy configuration
            wlans(w).primary = min(nChannels);          % Pick primary channel
            wlans(w).tx_power = max(txPowerActions);    % Pick transmission power
            wlans(w).cca = min(ccaActions);             % Pick CCA level
        end
        
        % Channels range (for Channel Bonding purposes - does not apply here)
        wlans(w).range = [wlans(w).primary wlans(w).primary];  % pick range

        % Position AP
        wlans(w).x = MaxX*rand();
        wlans(w).y = MaxY*rand();
        wlans(w).z = MaxZ*rand(); 
        wlans(w).position_ap = [wlans(w).x  wlans(w).y  wlans(w).z];
        % Position STA
        if(rand() < 0.5), xc = MaxRangeX.*rand();  
        else xc = -MaxRangeX.*rand();
        end
        if(rand() < 0.5), yc = MaxRangeY.*rand();
        else yc = -MaxRangeY.*rand();
        end
        if(rand() < 0.5), zc = MaxRangeZ.*rand();
        else zc = -MaxRangeZ.*rand();
        end
        wlans(w).xn = min(abs(wlans(w).x+xc), MaxX);  
        wlans(w).yn = min(abs(wlans(w).y+yc), MaxY);
        wlans(w).zn = min(abs(wlans(w).z+zc), MaxZ);
        xn(w)=wlans(w).xn;
        yn(w)=wlans(w).yn;
        zn(w)=wlans(w).zn;        
        wlans(w).position_sta = [wlans(w).xn  wlans(w).yn  wlans(w).zn];

        %wlans(w).lambda = input_data(w,INPUT_FIELD_LAMBDA);         % Pick lambda
        wlans(w).bandwidth = BANDWITDH_PER_CHANNEL;
        
        wlans(w).lambda = 14815;
        wlans(w).states = [];   % Instantiate states for later use          
        wlans(w).widths = [];   % Instantiate acceptable widhts item for later use
        
        wlans(w).transmitting = 0;

    end

    display_wlans = false;
    if display_wlans
        for w = 1 : nWlans
            wlans(w)
        end
    end
    
    if draw_map, draw_network_3D(wlans); end

end