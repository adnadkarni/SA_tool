function [outputArg1,outputArg2] = extrapolateTrend(inputArg1,inputArg2)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here



t_ahead = 50;
tser_ahead =  [0:t_ahead]';
Qg_now = Yo{win_num}.X;
Qg_ahead = Qg_now(end,:) + Ye{win_num}.trnd_mag(end,:).*tser_ahead/60;

%subplot(2,2,1)
plot(Yo{win_num}.t_indx, Yo{win_num}.val, 'LineWidth',3);
hold on;
plot(Yo{win_num}.t_indx, Yo{win_num}.X, 'k', 'LineWidth',2);
ta = (tser_ahead + Yo{win_num}.t_indx(end));
plot(ta, Qg_ahead,'--k','LineWidth',2);
plot([Yo{win_num}.t_indx;ta],600*ones(801,1),'--r','LineWidth',1);



outputArg1 = inputArg1;
outputArg2 = inputArg2;
end

