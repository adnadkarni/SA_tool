## Author: aditya <aditya@aditya-Lenovo-G510>
## Created: 2019-02-24

function [yOut] = collectResults (ySt)
  
for i=1:length(ySt)
  for j=1:length(ySt{i})
    yOut.wtdTrend(j,:) = ySt{i}{j}.wtdTrend';
    yOut.lastSegTrend(j,:) = ySt{i}{j}.magTrend(end,:);
    yOut.durLastSegTrend(j,:) = ySt{i}{j}.durTrendSeg(end,:);
  endfor
endfor

%keyboard
endfunction
