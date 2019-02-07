clear
clc

load adani400_data.mat;

y = adani400.MW(10000:60000,[5,8]);
yn = downsample(y,50);

% smoothing

x1_reg = yn(:,1) - detrend(yn(:,1));
x1_ma = smooth(yn(:,1),100,'moving');
x1_lowess = smooth(yn(:,1),50,'lowess');
x2_ma = smooth(yn(:,2),100,'moving');
x2_lowess = smooth(yn(:,2),50,'lowess');
x1_detrend = yn(:,1) - detrend(yn(:,1),'linear',[200,450,600]);
x2_detrend = yn(:,2) - detrend(yn(:,2),'linear',[100,300]);

subplot(2,2,1)
%plot([yn,x1_ma-5,x2_ma+5,x1_lowess-10,x2_lowess+10,x1_detrend-15,x2_detrend+15])
hold on;
plot([1:size(yn,1)]', [yn(:,1),x1_reg,x1_ma+3,x1_lowess-3,x1_detrend-6], 'Linewidth',2)
xlim([0,length(yn)])
ylabel('power flow (MW)')
%legend('noisy data','lin. regression','10-pt MA','Lowess (span = 20%)','detrend')
ax1=gca;
ax1.FontSize = 16;

subplot(2,2,3)
%plot(diff([x1_ma,x2_ma,x1_lowess,x2_lowess,x1_detrend,x2_detrend]));
plot(60*diff([x1_reg,x1_ma,x1_lowess,x1_detrend])/2,'Linewidth',2);
xlabel('time (sec)')
ylabel('trend (MW/min)')
ax2=gca;
ax2.FontSize = 16;