function [ yData ] = imputeData( yData, yPara, yLoss)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

substNAgo = 2;

for i=1:length(yPara.selectTS)
%     indexTS = yPara.selectTS(i);
    
    indexLim = find(yLoss.byChannel{i}.typeDataloss(:,4));            % find nan entries
    
    yData.val(indexLim, i) = yData.val(indexLim-substNAgo, i);
 
end

end

