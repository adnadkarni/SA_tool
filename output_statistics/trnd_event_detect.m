function [outputArg1] = trnd_event_detect(op,Yo,Ye,pl)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% Find outside threshold trend windows
num_win = size(op.win_st,1);
num_ser = size(op.wtr,2);

% names of time series
name_ser = Yo{1}{1}.name;

%% Find windows that exceed the trend threhsold
% Find windows with trends exceesing thresholds
for i=1:num_win
    win_event_p{i} = find(op.wtr(i,:)*pl{5} >= pl{7});
    win_event_n{i} = find(op.wtr(i,:)*pl{5} <= pl{8});
end
% collate the windows with violating trends (non empty cells)
wen_p = find(~cellfun(@isempty,win_event_p));
wen_n = find(~cellfun(@isempty,win_event_n));
wen = unique([wen_p,wen_n]);

% Set the windows to 1 where event is detected
if ~isempty(wen)
    event.win = zeros(num_win,1);
    event.win(wen) = 1;
    event.susp_win = wen;
    
    % start and end time of all window
    event.win_st = op.win_st(wen,1);
    event.win_en = op.win_en(wen,1);
    event.wtr = op.wtr(wen,:);
    
    
    % Select windows to plot
    pl_win_no = 1;
    select_win_no = event.susp_win(pl_win_no);
    
    event.max_trnd = op.max_trnd(select_win_no)*pl{5};  % maximum trend observed in any of the data series
    event.max_trnd_ser = op.max_trnd_ser(select_win_no); % series showing the maximum trend
    event.max_trnd_len = round(op.max_trnd_len(select_win_no)); % duration of maximum trend
    event.max_trnd_st = op.max_trnd_st(select_win_no);
    event.max_trnd_en = op.max_trnd_en(select_win_no);
else
    event = [];
    disp('No trend-event was detected');
end


%% plot event windows

figure(1)
% subplot of detected windows
subplot(2,3,1)

if ~isempty(event)
    %bar(op.win_en,event.win,'LineWidth',2,'FaceColor',[1 0 0],...
    %    'BarWidth',0.4)
    %plot(op.win_en,event.win,'k','LineWidth',2);
    stem(op.win_en,event.win,'MarkerFaceColor',[0 0 0],...
        'MarkerEdgeColor','none',...
        'LineWidth',3,...
        'Color',[0 0 0]);
    xlim([op.win_en(1),op.win_en(end)])
    xlabel('time (sec)')
    ylabel('Event status')
    title('Trend-event detection status (window-wise)')
    ax1 = gca();
    ax1.FontSize = 12;
    ax1.YTick = [0 1];
    ax1.Position = [0.0403225806451613 0.598814893362756 0.447947214076246 0.326185106637244];
    grid on
end

%-----------------------------------------------------------------------------------------------------------------
% subplot of window data
subplot(2,3,3)

if ~isempty(event)
    ypl1 = Yo{1}{select_win_no}.val*pl{6};
    tpl1 = Yo{1}{select_win_no}.t_indx;
    
    % Remove NaN entries for plotting
    if strcmp(pl{1}, 'Frequency')
        for i=1:size(ypl1,2)
            nzero = find(ypl1(:,i)<=45);
            ypl1(nzero,i) = NaN;
        end
    end
    
    ax2 = gca();
    plot(tpl1,ypl1,'LineWidth',2)
    hold on;
    xlim([op.win_st(select_win_no),op.win_en(select_win_no)])
    xlabel('time (sec)')
    ylabel(sprintf('%s (%s)', pl{1}, pl{2}));
    title(sprintf('Data of window [%2.0f   %2.0f]', event.win_st(pl_win_no), event.win_en(pl_win_no)));
    legend(name_ser)
    ax2.FontSize = 12;
    ax2.Position = [0.55425219941349 0.583837209302326 0.426686217008798 0.334325733810159];
    grid on
end
%--------------------------------------------------------------------------
% subplot of spatial trend profile

subplot(2,3,4)

if ~isempty(event)
    ypl2 = op.wtr(select_win_no,:)*pl{5};
    xpl2 = [1:size(op.wtr,2)];
    plot(xpl2,ypl2,'ZDataSource','','MarkerFaceColor',[0 0 0],...
        'MarkerEdgeColor','none',...
        'MarkerSize',10,...
        'Marker','o',...
        'LineWidth',2,...
        'LineStyle','none',...
        'Color',[0 0 0]);
    ax3 = gca();
    set(ax3,'XTick',[1:num_ser],'XTickLabel',name_ser);
    set(ax3, 'FontSize',12)
    xlabel('Series name')
    ylim([1.5*pl{8} 1.5*pl{7}] )
    ylabel(sprintf('%s (%s)', pl{3}, pl{4}));
    title('Weighted spatial trends')
    ax3.Position = [0.0417888563049853 0.11 0.302052785923754 0.334325733810159];
    grid on
    hold on
    plot([pl{7}*ones(length(xpl2),1),pl{8}*ones(length(xpl2),1)], '-.r', 'LineWidth', 2);
end
%--------------------------------------------------------------------------
% subplot of trend fit
subplot(2,3,5)

if ~isempty(event)
    snum = event.max_trnd_ser;
    swin = select_win_no;
    
    xpl3 = Yo{1}{swin}.X(:,snum)*pl{6};
    ypl3 = Yo{1}{swin}.val(:,snum)*pl{6};
    tpl3 = Yo{1}{swin}.t_indx;
    
    % Remove NaN entries for plotting
    if strcmp(pl{1}, 'Frequency')
        for i=1:size(ypl3,2)
            nzero = find(ypl3(:,i)<=45);
            ypl3(nzero,i) = NaN;
        end
    end
    
    plot(tpl3,ypl3,'LineWidth',2);
    hold on;
    plot(tpl3,xpl3,'k','LineWidth',3);
    ax4 = gca();
    ax4.FontSize = 12;
    xlim([tpl3(1) tpl3(end)])
    xlabel('time (sec)')
    ylabel(sprintf('%s (%s)', pl{1}, pl{2}));
    title(sprintf('%s of %s', pl{1}, name_ser{snum}));
    legend('data','trend-fit')
    ax4.Position = [0.412756598240469 0.11 0.222140762463343 0.334325733810159];
    grid on;
    txt = {sprintf('Max. %s = %2.1f %s', pl{3},event.max_trnd, pl{4}),...
        sprintf('%s = [%2.1f %2.1f] %s','seg', tpl3(event.max_trnd_st),tpl3(event.max_trnd_en), 'sec'),...
        sprintf('%s = %2.1f %s','duration', event.max_trnd_len, 'sec')
        };
    
    tobj = text(tpl3(1),max(ypl3),txt,'FontSize',10);
    tobj(1).Color = 'red';
    tobj(1).Position = [757.491749174917 79.9580842586956 0];
end

% plot of trend correlations-----------------------------------------------
%[R] = TrendCorrelation(Yo{1}{swin}.X, event);
[dY, dW] = calcChangeInWindow(Yo{1}{swin}, event);
subplot(2,3,6)
ax5 = gca();
if ~isempty(event)
   b = bar([dY;dW]'); 
   legend('seg-data', 'window-data');
   ax5.FontSize = 12;
   set(ax5,'XTick',[1:num_ser],'XTickLabel',name_ser);
   xlabel('series name');
   ylabel(pl{2});
   title('Change in magnitude');
   ax5.Position = [0.697947214076246 0.11 0.283724340175953 0.341162790697674];
   grid on;
end
%% output argumentspl.trnd_type,event.max_trnd, pl.trnd_unit
outputArg1 = event;
%outputArg2 = inputArg2;
end

