clear
clc
close all

pth = '/media/aditya/Data/PMU_Data/GETCO_freq';
[db] = read_wafms(pth, 'event7.csv');

[eventStat, eventIndex, yDown] = detect_by_distribution(db);

plot(yDown)
find(eventStat==1, 1)