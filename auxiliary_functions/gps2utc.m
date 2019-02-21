function [ t_utc ] = gps2utc( t_gps )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

e = datenum('01-jan-1970 05:30:00');
t_utc = cellstr(datestr(e+t_gps/86400,'HH:MM:SS.FFF'));
for i=1:size(t_utc)
    t_utc_sep(i,:) = str2double(regexp(t_utc{i},':','split'));
end

t_utc = duration(t_utc_sep);

end

