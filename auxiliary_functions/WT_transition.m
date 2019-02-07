clc
%clear

load Yst
load Ytr

nInt = length(Yst{1});
yXtick = [1:length(Yi.val(:,5))]*125/(25*60);
wtXtick = 15:57;

y3 = Yi.val(:,5);
y5 = Yi.val(:,7);

for i=1:nInt
    wt3(i,1) = Yst{1}{i}.trnd_wtd(3);
    et3(i,1) = Yst{1}{i}.trnd_mag(end,3);
    
    
    wt5(i,1) = Yst{1}{i}.trnd_wtd(5);
    et5(i,1) = Yst{1}{i}.trnd_mag(end,5);
    
    tindx(i,1) = Ytr{1}{i}.t_indx(end);
end

figure(1)
subplot(2,2,1)
plot(yXtick, y3, 'LineWidth', 2)
ax = gca;
ax.FontSize = 12;
ylabel('MW flow');
grid on;
title('sharp trend')

subplot(2,2,2)
plot(yXtick, y5, 'LineWidth', 2)
ax = gca;
ax.FontSize = 12;
grid on;
title('slow trend')

subplot(2,2,3)
plot(wtXtick, [wt3,et3], 'LineWidth', 2);
xlim([0,60])
ax = gca;
ax.FontSize = 12;
ylabel('Trend (MW/min)')
xlabel('Time (minute)')
grid on;


subplot(2,2,4)
plot(wtXtick, [wt5,et5], 'LineWidth', 2);
xlim([0,60])
ax = gca;
ax.FontSize = 12;
xlabel('Time (minute)')
grid on;