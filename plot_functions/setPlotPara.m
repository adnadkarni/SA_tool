function setPlotPara(para, pl)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
numLines = length(pl);

for i=1:numLines
    if ~isempty(para.LineWidth)
        pl(i).LineWidth = para.LineWidth(i);
    end
    
    if ~isempty(para.Color)
        pl(i).Color = para.Color{i};
    end
    
    % Markers
    if ~isempty(para.markerStatus)
        if ~isempty(para.markerEdgeColor)
            pl(i).MarkerEdgeColor = para.markerEdgeColor;
        end
        if ~isempty(para.markerFaceColor)
            pl(i).MarkerFaceColor = para.markerFaceColor;
        end
        
        if ~isempty(para.markerSize)
            pl(i).MarkerSize = para.markerSize;
        end
    end
end



ax = gca;
if ~isempty(para.position)
    ax.Position = para.position;
end


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



if ~isempty(para.xticks)
    xticks(ax,para.xticks);
end

if ~isempty(para.xticklabels)
    xticklabels(para.xticklabels);
end
yticks(ax,para.yticks);



if ~isempty(para.TSnames)
    legend(para.TSnames, 'FontSize' , 8);
end

if ~isempty(para.title)
    title(para.title);
end


end

