function cellPlot(Xcell, Ycell)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
ax = gca;
hold on
p = cellfun(@plot,Ycell);
indexTicks = [0:2000:14000];
xticks(gca, indexTicks);
xticklabels(gca, char(Xcell(indexTicks+1)));
xlabel('Time (hh:mm:ss)');
ylabel('Frequency (Hz)');
ax.FontSize = 11;

for i=1:length(Ycell)
    p(i).LineWidth = 2;
end
hold off

end

