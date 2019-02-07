function [outputArg1,outputArg2] = calcChangeInWindow(Yo, event)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

st = event.max_trnd_st;
en = event.max_trnd_en;
%dT = Yo{sw}.t_indx(en)-Yo{sw}.t_indx(st);
dY = Yo.X(en,:)-Yo.X(st,:);
dW = Yo.X(end,:)-Yo.X(1,:);


outputArg1 = dY;
outputArg2 = dW;
end

