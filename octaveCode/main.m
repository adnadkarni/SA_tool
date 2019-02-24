clear
clc

load ../WS_23_2_19.mat;
[combOut] = collectResults (Yst);
[thrMine] = getThr4Mine (1);
[resMine] = getMiningResults (combOut, thrMine);

