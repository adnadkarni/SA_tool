function plotExtrapolate(yTr, yCP, yPara)

figure(1)
    
    plot(yTr.indexTime, yTr.val(:,yCP.selectTS), 'LineWidth',1, 'DisplayName', 'measurement');
    hold on;
    
    
%     plot(yTr.indexTime, yTr.X(:,yCP.selectTS), 'k', 'LineWidth',2, 'DisplayName', 'trend-fit');
     tAhead = yTr.indexTime(end) + seconds(yCP.tstampAhead) ;
    
    plot(tAhead, yCP.yAhead(:,yCP.selectTS),'--','LineWidth',2,  'DisplayName', 'predicted course');
    tAll = [yTr.indexTime;tAhead];
    
    h = plot(tAll,ones(length(tAll),2)*diag([yPara.limitMax, yPara.limitMin]),'-.r','LineWidth',1);
    set(h,{'DisplayName'}, {'max. loading limit'; 'min loading limit'});
    
   plot([yTr.indexTime(end),yTr.indexTime(end)],[1.01*yPara.limitMax,...
                (1-0.01*sign(yPara.limitMin))*yPara.limitMin], '-.k',...
                'DisplayName', 'prediction start');
    
    set(gca,'Fontsize',12);
    ylim([(1-0.02*sign(yPara.limitMin))*yPara.limitMin 1.02*yPara.limitMax ]); 
    xlim([tAll(1), tAll(end)]);
    ylabel('Line loading (MW)');
    xlabel('time (sec)');
    title('Course prediction for lines loading');
    
    
    % add text to the plot
    legend(yTr.nameTS(yCP.selectTS), 'FontSize' , 8, 'Position', [0.82 0.63 0.15 0.25]);
%    text(yTr.indexTime(1)*ones(1,length(yCP.selectTS)),2*yTr.val(1,yCP.selectTS),...
%        yTr.nameTS(yCP.selectTS), 'FontSize', 12); % line name
%     text(0.57*yTr.indexTime(end),0.9*yPara.limitMin,'start prediction \rightarrow',...
%         'FontSize', 10); % prediction instant
%     text(yTr.indexTime(1), 1.1*yPara.limitMax, 'Max. limit (rev)', 'FontSize',...
%         10, 'Color', 'red' ); % min limit
%     text(yTr.indexTime(1), 1.1*yPara.limitMin, 'Max. limit', 'FontSize', 10,...
%         'Color', 'red' ); % max limit
    grid on;
end