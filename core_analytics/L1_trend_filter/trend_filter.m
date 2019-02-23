function [ yTr ] = trend_filter( yTr, lambda )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%%  Multivariate filter

nv = size(yTr.val,2);
nt = size(yTr.val,1);

% Initialize X and U
yTr.X = zeros(nt,nv);
yTr.U = zeros(nt,nv);

%% Check for data anomalies such as nan, zeros, inf

chkNan = (sum(isnan(yTr.val)) > 0);
chkInf = (sum(isinf(yTr.val)) > 0);
chkDataloss = (chkNan | chkInf);
passTS = find(~chkDataloss);                                                % get columns with no data discrepancies
yTr.nameTS = yTr.nameTS(passTS);

%% make input data

yIn = yTr.val(:,passTS);  
nv = size(yIn,2);                                                           % update nt

% matrix dimentions
nty = [1:nt]';
ntx = [2:nt-1]';

%% trend-filter

cvx_begin quiet
    cvx_precision low
    variables Xout(nv,nt)

    minimize(    sum(norms(yIn(nty,:)'- Xout(:,nty),2,1))...
        + lambda*sum(norms(Xout(:,ntx-1) - 2*Xout(:,ntx) + Xout(:,ntx+1),2,1))...
        )
cvx_end

%cvx_status

%% get trend fit and residual
yTr.X(:,passTS) = Xout';
yTr.U(:,passTS) = yIn - Xout';

end

