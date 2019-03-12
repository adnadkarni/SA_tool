function [ vart_avg ] = hp_filter_level(varin,pred_time)

% Parameter data---------------------------------------------------------------
nin = length(varin(:,1));              % Downsample time stamp data from above
tstep = 0.02;                        % Reporting rate assumed 40 msec here
wlen = size(varin,1);%25;                           % Window length
overlap = 1;                         % New samples to aquire for a new window. Waiting time = tstep*overlap
n = wlen;
e = ones(n,1);
D_temp = spdiags([e -2*e e], 0:2, n-2, n);
lambda=10;
rho=0.01;

k=1;
%--------------------------------------------------------------------------
for i=1:overlap:nin-(wlen-1)
    y = varin(i:i+wlen-1,2);
    tw = varin(i:i+wlen-1,1);
    
    % solve l1 trend filtering problem
    cvx_begin quiet
    variable x(n)
    variable w(n)
    variable w1(n-1)
    variable w2(n-1)
    minimize(0.5*sum_square(y-x-w)+lambda*norm(D_temp*x,1)+rho*norm((w2-w1),1));
    subject to
    w1 == w(1:end-1,1);
    w2 == w(2:end,1);
    cvx_end
    
    
    %-------------------------------------------------------------------------
    % First derivative for straight line fit
    dv_dt1(i) = (x(end)-x(end-5))/(5*tstep);
    %--------------------------------------------------------------------------
    % Extrapolate into future
    
    t0 = varin(i+wlen-1,1);
    dt = pred_time-t0;
    
    vart(k) = x(end) + dv_dt1(i)*dt;
    k=k+1;
    
end

vart_avg = mean(vart);
time = 1:size(x,1);
plot(tw,x,tw,y);

