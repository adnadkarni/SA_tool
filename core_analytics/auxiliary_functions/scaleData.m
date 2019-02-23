function [ yIn ] = scaleData(yIn)

% divide by mean
yavg = mean(yIn.val);
yIn.scfact = diag(1./yavg);

yIn.val = yIn.val*yIn.scfact;

% normalize
end