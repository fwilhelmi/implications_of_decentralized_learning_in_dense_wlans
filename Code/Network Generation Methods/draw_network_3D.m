%%% **********************************************************************
%%% * Implications of Decentralized Learning in Dense WLANs              *
%%% *    - Submission to 1st workship of FG-ML5G                         *
%%% * Author: Francesc Wilhelmi (francisco.wilhelmi@upf.edu)             *
%%% * Co-Authors: B. Bellalta, C. Cano, A. Jonsson                       *
%%% * Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi        *
%%% * GitHub home: https://github.com/fwilhelmi                          *
%%% * Repository: implications_of_decentralized_learning_in_dense_wlans  *
%%% **********************************************************************

function draw_network_3D(wlans)
% DrawNetwork3D - Plots a 3D of the network 
%   INPUT: 
%       * wlan - contains information of each WLAN in the map. For instance,
%       wlan(1) corresponds to the first one, so that it has unique
%       parameters (x,y,z,BW,CCA,etc.)

    %load('constants_mabs.mat')
    load('system_conf.mat')
    
    set(0,'defaultUicontrolFontName','Times New Roman');
    set(0,'defaultUitableFontName','Times New Roman');
    set(0,'defaultAxesFontName','Times New Roman');
    set(0,'defaultTextFontName','Times New Roman');
    set(0,'defaultUipanelFontName','Times New Roman');
    
    for j=1:size(wlans,2)
        x(j)=wlans(j).position_ap(1);
        y(j)=wlans(j).position_ap(2);
        z(j)=wlans(j).position_ap(3);
    end
    
    figure
    axes;
    labels = num2str((1:size(y' ))','%d');  
    
    for i = 1 : size(wlans,2)
        scatter3(wlans(i).position_ap(1), wlans(i).position_ap(2), wlans(i).position_ap(3), 150, [0 0 0], 'filled');
        hold on;   
        scatter3(wlans(i).position_sta(1), wlans(i).position_sta(2), wlans(i).position_sta(3), 75, [0 0 1], 'filled');
        line([wlans(i).position_ap(1), wlans(i).position_sta(1)], [wlans(i).position_ap(2), wlans(i).position_sta(2)], ...
            [wlans(i).position_ap(3), wlans(i).position_sta(3)], 'Color', [0.4, 0.4, 1.0], 'LineStyle', ':');        
    end
    
    set(gca,'FontSize', 18);
    text(x,y,z,labels,'horizontal','left','vertical','bottom','FontSize', 18) 
    xlabel('x [meters]');
    ylabel('y [meters]');
    zlabel('z [meters]');
    axis([0 MaxX 0 MaxY 0 MaxZ])
    
end