function [ y ] = datalossByChannel( x, tp )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

numSamp = length(x);

%% check for data loss
if (isempty(x))
    y =[];
    
else
    tmp1 = isnan(x);
    tmp2 = (x==0);
    tmp3 = isinf(x);
    
    switch tp
        case 1                                                              % voltage magnitude
            tmp4 = (x >= 4e5-100 & x <= 4e5+100);                           % find at limit entries
            
        case 2
            tmp4 = zeros(numSamp,1);
            
        case 3
            tmp4 = [abs(x) >= 1e3];
            
        case 4
            tmp4 = zeros(numSamp,1);
            
        case 5
            tmp4 = [x <= 45 | x >= 55];
            
        case 6
            tmp4 = zeros(numSamp,1);
            
        case 7
            tmp4 = zeros(numSamp,1);
            
        case 8
            tmp4 = zeros(numSamp,1);
            
        case 9
            tmp4 = zeros(numSamp,1);
            
        case 10
            tmp4 = zeros(numSamp,1);
            
    end
    
    % overall data loss
    y.typeDataloss = [tmp1,  tmp2,  tmp3,  tmp4];                           % all type of data loss in logical
        
    % percentage data loss
    
    y.percNan = 100*sum(tmp1)/numSamp;                                      % % nan entries
    
    y.percZero = 100*sum(tmp2)/numSamp;                                     % % zero entries
    
    y.percInf = 100*sum(tmp3)/numSamp;                                      % % inf entries
    
    y.percLimit = 100*sum(tmp4)/numSamp;                                    % percentage of entries at limits or above
    
    y.percAll = 100*sum([tmp1 |  tmp2 |  tmp3 |  tmp4])/numSamp;            % overall data loss status

    
end
end

