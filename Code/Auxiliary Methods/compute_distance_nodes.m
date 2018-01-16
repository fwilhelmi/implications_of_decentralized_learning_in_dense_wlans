%%% **********************************************************************
%%% * Implications of Decentralized Learning in Dense WLANs              *
%%% *    - Submission to 1st workship of FG-ML5G                         *
%%% * Author: Francesc Wilhelmi (francisco.wilhelmi@upf.edu)             *
%%% * Co-Authors: B. Bellalta, C. Cano, A. Jonsson                       *
%%% * Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi        *
%%% * GitHub home: https://github.com/fwilhelmi                          *
%%% * Repository: implications_of_decentralized_learning_in_dense_wlans  *
%%% **********************************************************************

function [distance_ap_ap, distance_ap_sta] = compute_distance_nodes(wlans)

    n_wlans = size(wlans,2);
    
    distance_ap_ap = zeros(n_wlans, n_wlans);
    distance_ap_sta = zeros(n_wlans, n_wlans);
    
    for i= 1 : n_wlans
          
        for j = 1 : n_wlans

            distance_ap_ap(i,j) = sqrt((wlans(i).position_ap(1) - wlans(j).position_ap(1))^2 + ...
                            (wlans(i).position_ap(2) - wlans(j).position_ap(2))^2 + ...
                            (wlans(i).position_ap(3) - wlans(j).position_ap(3))^2);
                        
            distance_ap_sta(i,j) = sqrt((wlans(i).position_ap(1) - wlans(j).position_sta(1))^2 + ...
                            (wlans(i).position_ap(2) - wlans(j).position_sta(2))^2 + ...
                            (wlans(i).position_ap(3) - wlans(j).position_sta(3))^2);
        
        end
        
    end

end