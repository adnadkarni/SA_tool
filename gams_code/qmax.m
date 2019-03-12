len = 300; %km
base_kv = 500;
base_MVA = 100;

 r = 0.05403; %pu
% r=0;
x = 0.22304; %pu
b = 0.0492; %pu

zb = base_kv^2/base_MVA;
yb = 1/zb;

r1 = r*zb/len; %ohm\km
x1 = x*zb/len; %ohm\km
y1 = b*yb/len; %Siemens\km

gamma_l = sqrt((r1+1i*x1)*(1i*y1))*len;

A = abs(cosh(gamma_l));
theta_A = angle(cosh(gamma_l));

Z_surge = sqrt((r1+1i*x1)/(1i*y1));
Z_dash = (Z_surge)*sinh(gamma_l);

Qmax_1_5_part1 = base_kv^2*((V_gms(1,2)*V_gms(5,2)/abs(Z_dash))*sin(angle(Z_dash)-(Vph_gms(1,2)-Vph_gms(5,2))*pi/180));
Qmax_1_5_part2 = base_kv^2*((A*V_gms(5,2)^2/abs(Z_dash))*sin(angle(Z_dash)-theta_A));

Qmax_1_5 = (Qmax_1_5_part1 - Qmax_1_5_part2);

Pmax_1_5_part1 = (V_gms(1,2)*V_gms(5,2)/abs(Z_dash))*cos(angle(Z_dash)-(Vph_gms(1,2)-Vph_gms(5,2))*pi/180);
Pmax_1_5_part2 = (A*V_gms(5,2)^2/abs(Z_dash))*cos(angle(Z_dash)-theta_A);

Pmax_1_5 = base_kv^2*(Pmax_1_5_part1 - Pmax_1_5_part2);