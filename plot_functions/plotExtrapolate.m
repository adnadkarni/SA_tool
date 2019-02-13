function plotExtrapolate(M1, M4)

figure(1)
    
    plot(M1.t_indx, M1.val(:,M4.selectTs), 'LineWidth',1, 'DisplayName', 'measurement');
    hold on;
    
    
    plot(M1.t_indx, M1.X(:,M4.selectTs), 'k', 'LineWidth',2, 'DisplayName', 'trend-fit');
    tAhead = (M4.tstampAhead + M1.t_indx(end));
    
    plot(tAhead, M4.yAhead(:,M4.selectTs),'--k','LineWidth',2,  'DisplayName', 'predicted course');
    tAll = [M1.t_indx;tAhead];
    
    h = plot(tAll,ones(length(tAll),2)*diag(M4.limitMaxMin),'-.r','LineWidth',1);
    set(h,{'DisplayName'}, {'max. loading limit'; 'min loading limit'});
    
    plot([M1.t_indx(end),M1.t_indx(end)],[1.1*M4.limitMaxMin(1), 1.1*M4.limitMaxMin(2)], '-.k',...
        'DisplayName', 'prediction start');
    
    set(gca,'Fontsize',12);
    ylim([1.2*M4.limitMaxMin(1), 1.2*M4.limitMaxMin(2)]); 
    xlim([tAll(1), tAll(end)]);
    ylabel('Line loading (MW)');
    xlabel('time (sec)');
    title('Course prediction for lines loading');
    
    
    % add text to the plot
    text(M1.t_indx(1)*ones(1,length(M4.selectTs)),2*M1.val(1,M4.selectTs),...
        M1.name(M4.selectTs), 'FontSize', 12); % line name
    text(0.57*M1.t_indx(end),0.9*M4.limitMaxMin(2),'start prediction \rightarrow',...
        'FontSize', 10); % prediction instant
    text(M1.t_indx(1), 1.1*M4.limitMaxMin(1), 'Max. limit (rev)', 'FontSize',...
        10, 'Color', 'red' ); % min limit
    text(M1.t_indx(1), 1.1*M4.limitMaxMin(2), 'Max. limit', 'FontSize', 10,...
        'Color', 'red' ); % max limit
    grid on;
end