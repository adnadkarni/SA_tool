function [ Y_lev ] = level_filter( Y_lev )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%%  Multivariate filter

nv = size(Y_lev.val,2);
nt = size(Y_lev.val,1);

nty = [1:nt]';
ntx = [2:nt]';

cvx_begin quiet
    cvx_precision low
    variables X(nv,nt)

    minimize(    sum(norms(Y_lev.val(nty,:)'- X(:,nty),2,1))...
        + Y_lev.mu*sum(norms(X(:,ntx) - X(:,ntx-1),2,1))...
        )
cvx_end

cvx_status
Y_lev.X = X';
Y_lev.U = Y_lev.val - Y_lev.X;
end

