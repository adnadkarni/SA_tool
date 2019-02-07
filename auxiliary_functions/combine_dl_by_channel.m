function [ fld_mat ] = combine_dl_by_channel( in, fld_name )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

for i=1:size(in,2)
    if isstruct(in{i})
        fld_mat(i,:) = in{i}.(fld_name);
    else
        fld_mat(i,:) = in{i}(fld_name);
    end
end
end

