function setPlotPara(para, pl)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
numLines = length(pl);
for i=1:numLines
    pl(i).LineWidth = para.LineWidth;
end

ax = gca;
%ax.Position = para.position;
ax.FontSize = para.FontSize;
xlabel(para.xlabel);
ylabel(para.ylabel);
if (~isempty(para.xlim))
    xlim(para.xlim);
end
if (~isempty(para.ylim))
    ylim(para.ylim);
end

if (~isempty(para.facecolor))
    pl.FaceColor = para.facecolor;
end

if (~isempty(para.barwidth))
    pl.BarWidth = para.barwidth;
end

xticks(ax,para.xticks);
yticks(ax,para.yticks);

end

