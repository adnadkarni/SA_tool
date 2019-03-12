function [init] = l1_prediction_new(V,Pg,Qg,del,ifd,Qr,t2in,numcol)
strt = 1;                          % Starting sample number
stp = 5000;                          % Number of samples considered for making decision

% Time window
pred_int_start = 66;
pred_int_end = 69;
pred_time = 80;

no_wind = 5;

% Obtaning sample numbers for time
tstamp1 = t2in(strt:1:stp,1);

for i=1:no_wind
    t1(i) = find(tstamp1 >= pred_int_start+i-1,1);
    t2(i) = find(tstamp1 >= pred_int_end+i-1,1);
end


global V_orig;

c = size(V,2);
lambda = 10;
for j=1:size(t2,2)
    for i=15%1:c
        dpts = (t2(j)-t1(j))+1;
        Vavg = abs(mean(V(t1(j):1:t2(j),i)));
        vin1(:,j) = V(t1(j):1:t2(j),i)/100 + normrnd(0,0.01*Vavg,dpts,1);
        V_orig = V(t1(j):t2(j),i)/100;
        [ Vt(i,j),dVdt(i,j)] = hp_filter([tstamp1(t1(j):t2(j)),vin1(:,j)],V(t1(j):1:t2(j),i)/100,lambda,pred_time);
    end
end


% lambda = 50;
c = size(Qg,2);
for j=1:size(t2,2)
for i=1%1:c
    dpts = (t2(j)-t1(j))+1;
    Qavg = abs(mean(Qg(t1(j):1:t2(j),i)));
    qin1(:,j) = Qg(t1(j):1:t2(j),i).*(1+ normrnd(0,0.05*Qavg,dpts,1));
    [ Qgt(i,j),dQdt(i,j)] = hp_filter([tstamp1(t1(j):t2(j)),qin1(:,j)],Qg(t1(j):1:t2(j),i),lambda,pred_time);
end
end


c = size(Pg,2);
for j=1:size(t2,2)
for i=1:c
    dpts = (t2(j)-t1(j))+1;
    Pavg = abs(mean(Pg(t1(j):1:t2(j),i)));
    pin1 = Pg(t1(j):1:t2(j),i).*(1 + normrnd(0,0.01*Pavg,dpts,1));

    [ Pgt(i,j),dPdt(i,j)] = hp_filter([tstamp1(t1(j):t2(j)),pin1],Pg(t1(j):1:t2(j),i),lambda,pred_time);
end
end

c = size(del,2);
for j=1:size(t2,2)
for i=1:c
    dpts = (t2(j)-t1(j))+1;
    Delavg = abs(mean(del(t1(j):1:t2(j),i)));
    delin1 = del(t1(j):1:t2(j),i).*(1 + normrnd(0,0.01*Delavg,dpts,1));

    [ Delt(i,j),dDeldt(i,j)] = hp_filter([tstamp1(t1(j):t2(j)),delin1],del(t1(j):1:t2(j),i),lambda,pred_time);
end
end


c = size(ifd,2);
for j=1:size(t2,2)
for i=1:c
    dpts = (t2(j)-t1(j))+1;
    Ifdavg = abs(mean(ifd(t1(j):1:t2(j),i)));
    ifdin1 = ifd(t1(j):1:t2(j),i).*(1 + normrnd(0,0.01*Ifdavg,dpts,1));

    [ Ifdt(i,j),dIfddt(i,j)] = hp_filter([tstamp1(t1(j):t2(j)),ifdin1],ifd(t1(j):1:t2(j),i),lambda,pred_time);
end
end

c = size(Qr,2);
for j=1:size(t2,2)
for i=1:c
    dpts = (t2(j)-t1(j))+1;
    Qravg = abs(mean(Qrg(t1(j):1:t2(j),i)));
    Qrin1 = Qr(t1(j):1:t2(j),i).*(1 + normrnd(0,0.01*Qravg,dpts,1));

    [ Qrt(i,j),dQrdt(i,j)] = hp_filter([tstamp1(t1(j):t2(j)),Qrin1],Qr(t1(j):1:t2(j),i),lambda,pred_time);
end
end

%--------------------------------------------------------------------------
% Create initial value structure to be used in OPF
init.Vmag = mean(Vt,2);
init.Pg = mean(Pgt,2);
init.Qg = mean(Qgt,2);
init.ifd = mean(Ifdt,2);
init.delta = mean(Delt,2);
init.Qr = mean(Qrt,2);
% %------------------------------------------------------------------------
% %------------------------------------------------------------------------

% % Correlation

end
