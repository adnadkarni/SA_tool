## Copyright (C) 2019 aditya
## 
## This program is free software; you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
## 
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## 
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.

## -*- texinfo -*- 
## @deftypefn {} {@var{retval} =} getMiningResults (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: aditya <aditya@aditya-Lenovo-G510>
## Created: 2019-02-24

function [yOut] = getMiningResults (yIn, thrIn)
  
for i=1:size(yIn.lastSegTrend,1)
  indexMaxTrend = find(abs(yIn.lastSegTrend(i,:)) >= thrIn.thrMaxTrend);          % find window with significant last segment trend
  durSeg = yIn.durLastSegTrend(i);                                                % get duration of that trend segment
  %wtdTrend = yIn.lastSegTrend(i,:);                                               % get weighted trend for the whole window
  
  if (~isempty(indexMaxTrend) & durSeg >= thrIn.thrDur)
 % timeMaxTrend = yIn.indexTime(indexMaxTrend);
    yOut.statusLastSegTrend(i,1) = 1;
    yOut.lastSegTrend(i,:) = yIn.lastSegTrend(i,:);
    yOut.wtdAtInstTrend(i,:) = yIn.wtdTrend(i,:);
    yOut.durLastSegTrend(i,1) = durSeg;
  else
    yOut.statusLastSegTrend(i,1) = 0;
    yOut.lastSegTrend(i,1) = nan;
    yOut.wtdAtInstTrend(i,1) = nan;
    yOut.durLastSegTrend(i,1) = nan; 
  endif
  
endfor



endfunction
