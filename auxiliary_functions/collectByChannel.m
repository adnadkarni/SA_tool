function [ fld_mat ] = collectByChannel( x, fld_name )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

for i=1:size(x,2)
    if isstruct(x{i})
        fld_mat(i,:) = x{i}.(fld_name);
    else
        fld_mat(i,:) = x{i}(fld_name);
    end
end
end

