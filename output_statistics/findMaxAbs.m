%## Author: aditya <aditya@aditya-Lenovo-G510>
%## Created: 2019-02-24

function [y] = findMaxAbs (x)
    sgn = sign(x);
    [xmCol, ixmCol] = max(abs(x));
    [xmRow, ixmRow] = max(xmCol);
    if (size(x,1) > 1)
        y = sgn(ixmCol(ixmRow), ixmRow)*xmCol(ixmRow);
        iy = ixmRow;
    else
        y = sgn(ixmCol)*x(ixmCol);
        iy = ixmCol;
    end
end
