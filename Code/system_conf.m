%%% *********************************************************************
%%% * Spatial-Flexible CTMN for WLANs                                   *
%%% * Author: Sergio Barrachina-Munoz (sergio.barrachina@upf.edu)       *
%%% * Copyright (C) 2017-2022, and GNU GPLd, by Sergio Barrachina-Munoz *
%%% * GitHub repository: https://github.com/sergiobarra/SFCTMN          *
%%% * More info on https://www.upf.edu/en/web/sergiobarrachina          *
%%% *********************************************************************

%%% File description: script for generating the system configuration

path_loss_model = PATH_LOSS_AX_RESIDENTIAL;         % Path loss model index
access_protocol_type = ACCESS_PROTOCOL_IEEE80211;   % Access protocol type
flag_hardcode_distances = true;                     % Allows hardcoding distances from main_sfctmn.m file
carrier_frequency = 2.4E9;                          % Carrier frequency [MHz] (2.4 or 5) GHz
NOISE_DBM = -100;                                   % Ambient noise [dBm]
BANDWITDH_PER_CHANNEL = 20e6;                       % Bandwitdh in each channel in MHz
NOISE_DBM = -100;                                   % Floor NOISE_DBM in dBm

% Dimensions of the 3D map
MaxX=10;
MaxY=10; 
MaxZ=5;
% Maximum range for a STA
MaxRangeX = 1;
MaxRangeY = 1;
MaxRangeZ = 1;
MaxRange = sqrt(3);

% DSA policy type
dsa_policy_type = DSA_POLICY_ONLY_PRIMARY;
% dsa_policy_type = DSA_POLICY_AGGRESSIVE;
% dsa_policy_type = DSA_POLICY_ONLY_MAX;
% dsa_policy_type = DSA_POLICY_EXPLORER_UNIFORM;
% dsa_policy_type = DSA_POLICY_EXPLORER_LADDER;

save('system_conf.mat');  % Save system configuration into current folder