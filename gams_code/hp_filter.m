function [ vart_avg,dvardt_avg ] = hp_filter(varin,var0,lambda,pred_time)
global V_orig;
% Parameter data---------------------------------------------------------------
nin = length(varin(:,1));              % Downsample time stamp data from above
tstep = 0.02;                        % Reporting rate assumed 40 msec here
wlen = size(varin,1);%25;                           % Window length
overlap = 1;                         % New samples to aquire for a new window. Waiting time = tstep*overlap
n = wlen;
e = ones(n,1);
D_temp = spdiags([e -2*e e], 0:2, n-2, n);

k=1;
%--------------------------------------------------------------------------
for i=1:overlap:nin-(wlen-1)
    y = varin(i:i+wlen-1,2);
    tw = varin(i:i+wlen-1,1);
    
    % solve l1 trend filtering problem
    cvx_begin quiet
    variable x(n)
    minimize(0.5*sum_square(y-x)+lambda*norm(D_temp*x,1));
    cvx_end
    
    
    %-------------------------------------------------------------------------
    % First derivative for straight line fit
    dvar_dt1(i) = (x(end)-x(end-5))/(5*tstep);
    %--------------------------------------------------------------------------
    % Extrapolate into future
    
    t0 = varin(i+wlen-1,1);
    dt = pred_time-t0;
    
    vart(k) = x(end) + dvar_dt1(i)*dt;
    k=k+1;
    
end

vart_avg = mean(vart);
dvardt_avg = mean(dvar_dt1);
plot(tw,[x,y,var0]);

