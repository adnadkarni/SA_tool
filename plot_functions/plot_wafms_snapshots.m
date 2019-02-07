function plot_wafms_snapshots(Yo, Y, windx)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

ts_indx = [1,2,3,6];

for i=1:length(ts_indx)
    nzero = find(Y.val(:,ts_indx(i))<=50);
    Y.val(nzero,ts_indx(i)) = NaN;
end
figure(1)
subplot(2,4,1)
x = [1:6500]*0.04;
plot(x,Y.val(:,ts_indx),'LineWidth',2);
ax = gca();
ax.FontSize = 16;
xlim([x(1),x(end)]); xlabel('time(sec)')
ylim([50.1,50.8]); ylabel('Freq.(Hz)')
grid on;
legend('Mumbai','Kanpur','Kharagpur','Delhi')

k=1;
for i=1:size(Yo,1)
    for j=windx
        x = Yo{i}{j}.t_indx;
        y = Yo{i}{j}.val;
        
        subplot(2,4,k+4)
        plot(x,y,'LineWidth',2)
        xlim([x(1),x(end)]); xlabel('time(sec)');
        ylim([min(min(y))-0.01,max(max(y))+0.01]);
        if k==1
            ylabel('Freq.(Hz)');
        end
        ax = gca();
        ax.FontSize = 16;
        grid on;
        k=k+1;
    end
end

end

