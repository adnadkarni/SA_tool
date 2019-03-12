function [seq] = strseq(Text,Num)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
for i=1:size(Num,1)
    seq{i} = strcat(Text,num2str(Num(i)));
end
end

