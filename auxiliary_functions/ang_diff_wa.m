function [ dij ] = ang_diff_wa( Y, ref_bus, num_ph )
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

if num_ph == 3
    dij(:,ref_bus)
    for j=1:size(Y.val,2)
        if rem(j,3) == 1
            dij(:,j) = ang_diff_pmu( Y.val(:,j), Y.val(:,ref_bus(1)) );
        elseif rem(j,3) == 2
            dij(:,j) = ang_diff_pmu( Y.val(:,j), Y.val(:,ref_bus(2)) );
        else
            dij(:,j) = ang_diff_pmu( Y.val(:,j), Y.val(:,ref_bus(3)) );
        end
    end
end

if num_ph == 4
    for j=1:size(Y.val,2)
        if rem(j,4) == 1
            dij(:,j) = ang_diff_pmu( Y.val(:,j), Y.val(:,ref_bus(1)) );
        elseif rem(j,4) == 2
            dij(:,j) = ang_diff_pmu( Y.val(:,j), Y.val(:,ref_bus(2)) );
        elseif rem(j,4) == 3
            dij(:,j) = ang_diff_pmu( Y.val(:,j), Y.val(:,ref_bus(3)) );
        else
            dij(:,j) = ang_diff_pmu( Y.val(:,j), Y.val(:,ref_bus(4)) );
        end
    end
end

end

