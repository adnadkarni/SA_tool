function [controlPara] = getControlPara()

[controlPara.mpc, controlPara.ntp] = getNTP();                              % get the network

[controlPara.Ybus] = makeYbus(baseMVA, mpc.bus, mpc.branch);                % get network Ybus

end

