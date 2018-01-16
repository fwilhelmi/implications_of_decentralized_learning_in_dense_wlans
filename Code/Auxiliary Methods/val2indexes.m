%%% **********************************************************************
%%% * Implications of Decentralized Learning in Dense WLANs              *
%%% *    - Submission to 1st workship of FG-ML5G                         *
%%% * Author: Francesc Wilhelmi (francisco.wilhelmi@upf.edu)             *
%%% * Co-Authors: B. Bellalta, C. Cano, A. Jonsson                       *
%%% * Copyright (C) 2017-2022, and GNU GPLd, by Francesc Wilhelmi        *
%%% * GitHub home: https://github.com/fwilhelmi                          *
%%% * Repository: implications_of_decentralized_learning_in_dense_wlans  *
%%% **********************************************************************

function [i,j,k] = val2indexes(ix, a, b, c)
% val2indexes provides the indexes i,j,k from index ix
%   OUTPUT: 
%       * i - index of the first element
%       * j - index of the second element
%       * k - index of the third element
%   INPUT: 
%       * ix - index of the (i,j,k) combination
%       * a - size of elements containing "i"
%       * b - size of elements containing "j"
%       * c - size of elements containing "k"

    i = mod(ix, a); 
    if i == 0, i = a; end    
    y = mod(ix, (a * b));
    j = ceil(y/a);
    if j == 0, j = b; end 
    k = ceil(ix / (a * b)); 
    if k > c, k = c; end
    
end