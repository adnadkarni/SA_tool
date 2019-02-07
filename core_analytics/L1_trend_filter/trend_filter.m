function [ Y_tr ] = trend_filter( Y_tr )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%%  Multivariate filter

nv = size(Y_tr.val,2);
nt = size(Y_tr.val,1);

% Initialize X and U
Y_tr.X = zeros(nt,nv);
Y_tr.U = zeros(nt,nv);

% Check for data anomalies such as nan, zeros, inf
chk_nan = (sum(isnan(Y_tr.val)) > 0);
chk_zero = (sum(Y_tr.val) == 0);
chk_inf = (sum(isinf(Y_tr.val)) > 0);
chk_data_error = (chk_nan | chk_zero | chk_inf);
ts_ok = find(~chk_data_error); % get columns with no data discrepancies
Yin = Y_tr.val(:,ts_ok);  
nv = size(Yin,2);   % update nt

% matrix dimentions
nty = [1:nt]';
ntx = [2:nt-1]';

% trend-filter
cvx_begin quiet
    cvx_precision low
    variables Xout(nv,nt)

    minimize(    sum(norms(Yin(nty,:)'- Xout(:,nty),2,1))...
        + Y_tr.lambda*sum(norms(Xout(:,ntx-1) - 2*Xout(:,ntx) + Xout(:,ntx+1),2,1))...
        )
cvx_end

%cvx_status


Y_tr.X(:,ts_ok) = Xout';
Y_tr.U(:,ts_ok) = Yin - Xout';

end

