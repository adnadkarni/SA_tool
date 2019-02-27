function [ yTnL ] = TnLFilter( yTnL, lambda, mu )
%UNTITLED Summary of this function goes here

%%  Multivariate filter

nv = size(yTnL.val,2);
nt = size(yTnL.val,1);

% Initialize X and U
yTnL.X = zeros(nt,nv);
yTnL.U = zeros(nt,nv);
yTnL.W = zeros(nt,nv);

%% Check for data anomalies such as nan, zeros, inf

chkNan = (sum(isnan(yTnL.val)) > 0);
chkInf = (sum(isinf(yTnL.val)) > 0);
chkDataloss = (chkNan | chkInf);
passTS = find(~chkDataloss);                                                % get columns with no data discrepancies
yTnL.nameTS = yTnL.nameTS(passTS);

%% make input data

yIn = yTnL.val(:,passTS);  
nv = size(yIn,2);                                                           % update nt

% matrix dimentions
nty = [1:nt]';
ntx = [2:nt-1]';
ntw = [2:nt]';

%% TnL-filter

cvx_begin quiet
    cvx_precision low
    variables X(nv,nt)

    minimize(    sum(norms(yIn(nty,:)'- X(:,nty),2,1))...
        + lambda*sum(norms(X(:,ntx-1) - 2*X(:,ntx) + X(:,ntx+1),2,1))...
        )
cvx_end

%cvx_status

cvx_begin quiet
    cvx_precision low
    variables W(nv,nt)

    minimize(    sum(norms(yIn(nty,:)'- W(:,nty),2,1))...
               + mu*sum(norms(W(:,ntw) - W(:,ntw-1),2,1))...
        )
cvx_end

%% get trend fit and residual

yTnL.X(:,passTS) = X';
yTnL.U(:,passTS) = yIn - X';
yTnL.W(:,passTS) = W';

end

