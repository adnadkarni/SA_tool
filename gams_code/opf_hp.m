clc
clear

% OPF linked HP filter

data_ip             % Data input from PMU sim or Trans stab program
[init] = l1_prediction_new(V,Pg,Qg,del,ifd,Zg,t2in,numcol);   % Predict 5 sec in future
operative_new       % OPF stage