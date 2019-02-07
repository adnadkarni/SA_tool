function [outputArg1] = spk_event_detect(op, Yo, Ye, pl)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% Find outside threshold trend windows
num_win = size(op.win_st,1);
num_ser = size(op.wtr,2);

% names of time series
name_ser = Yo{1}{1}.name;

%% get windows with significant spikes

% threshold for detecting spike event
thr = pl{7};

for i=1:size(Ye,1)
    for j=1:size(Ye{i},2)
        [maxSpk] = max(abs(Ye{i}{j}.spk_mag_zm),[],2);  % get maximum spike magnitude in each time series at each detected sample
        spkIndx = find(maxSpk >= thr);         % see if any spike exceeds threshold
        if ~isempty(spkIndx)
            event.spkIndx_smp{j,1} = Ye{i}{j}.spk_indx_zm(spkIndx,:);  % gather all time-samples with atleast one time series exceeding threshold
            event.spkIndx_t{j,1} = Yo{i}{j}.t_indx(event.spkIndx_smp{j,1},:); % get actual time of spikes
            event.spkMag{j,1} = Ye{i}{j}.spk_mag_zm(spkIndx,:); % get spike magnitudes (time x time-series name)
            event.winSpk(j,1) = 1;  % spike status for a window
        else
            event.spkIndx_smp{j,1} = [];
            event.spkIndx_t{j,1} = [];
            event.spkMag{j,1} = [];
            event.winSpk(j,1) = 0;
        end
        event.win_st(j,1) = op.win_st(j,1); % start of window
        event.win_en(j,1) = op.win_en(j,1); % end of window
    end
end

% Find the window number of each suspect window
event.suspWin = find(event.winSpk);

if sum(event.winSpk)
    plotWin = 1;
    selectWin = event.suspWin(plotWin);
else
    disp('No spike-event detected');
end

%% plot windows with significant spikes
figure(2)
if sum(event.winSpk)
    % subplot of spike status--------------------------------------------------
    subplot(2,2,1)
    %bar(op.win_en,event.win,'LineWidth',2,'FaceColor',[1 0 0],...
    %    'BarWidth',0.4)
    %plot(op.win_en,event.win,'k','LineWidth',2);
    stem(op.win_en,event.winSpk,'MarkerFaceColor',[0 0 0],...
        'MarkerEdgeColor','none',...
        'LineWidth',3,...
        'Color',[0 0 0]);
    xlim([op.win_en(1),op.win_en(end)])
    xlabel('time (sec)')
    ylabel('Event status')
    title('Spike-event detection status (window-wise)')
    ax1 = gca();
    ax1.FontSize = 12;
    ax1.YTick = [0 1];
    ax1.Position = [0.0812591508052709 0.598814893362756 0.902635431918009 0.326185106637244];
    grid on
end

% subplot of window data---------------------------------------------------
subplot(2,2,3)

if ~isempty(event)
    ypl1 = Yo{1}{selectWin}.val*pl{6};
    tpl1 = Yo{1}{selectWin}.t_indx;
    
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
    xlim([op.win_st(selectWin),op.win_en(selectWin)])
    xlabel('time (sec)')
    ylabel(sprintf('%s (%s)', pl{1}, pl{2}));
    title(sprintf('Data in window [%2.0f   %2.0f]', event.win_st(selectWin), event.win_en(selectWin)));
    legend(name_ser)
    ax2.FontSize = 12;
    % ax2.Position = [0.0733137829912024 0.11 0.26466275659824 0.309973192699049];
    grid on
end

% subplot of zoomed data---------------------------------------------------
subplot(2,2,4)
ax3 = gca();
    
if ~isempty(event)
    ypl1 = event.spkMag{selectWin}*pl{6};
    tpl1 = event.spkIndx_t{selectWin};
    
    % Remove NaN entries for plotting
    if strcmp(pl{1}, 'Frequency')
        for i=1:size(ypl1,2)
            nzero = find(ypl1(:,i)<=45);
            ypl1(nzero,i) = NaN;
        end
    end
    
    c = categorical(name_ser);
    bar1 = bar(c,[ypl1]');
    set(bar1,'BarWidth',0.2);
%     set(ax3,'xtick);
    
    title(sprintf('Spike magnitude for window [%2.0f   %2.0f]', event.win_st(selectWin), event.win_en(selectWin)));
    xlabel('Spike time (sec)');
    ylabel('\Delta MW');
    legend(strcat('time = ',num2str(tpl1)));
    ax3.FontSize = 12;
    grid on
end

outputArg1 = event;

end

