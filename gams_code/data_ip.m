clc
clear
% 
%  V = xlsread('results2.xlsx',5,'B2:P5004'); nv = size(V,2);
%  Pg = xlsread('results2.xlsx',4,'B2:F5004'); npg=size(Pg,2);
%  Qg = xlsread('results2.xlsx',2,'B2:F5004'); nqg=size(Qg,2);
% % Zg = xlsread('results2.xlsx',2,'A2:J5004'); nzg=size(Zg,2)/2;
%  del = xlsread('results2.xlsx',11,'B2:P5004'); ndel=size(del,2);
%  ifd = xlsread('results2.xlsx',1,'B2:F5004'); nifd = size(ifd,2);
%  Ps =  xlsread('results2.xlsx',8,'B2:D5004'); nPs = size(Ps,2); nbr = nPs;
%  Pr =  xlsread('results2.xlsx',9,'B2:D5004'); nPr = size(Pr,2);
%  Qs =  xlsread('results2.xlsx',6,'B2:D5004'); nQs = size(Qs,2);
%  Qr =  xlsread('results2.xlsx',7,'B2:D5004'); nQr = size(Qr,2);
%  t2in = xlsread('results2.xlsx',1,'A2:A5004');

%  numcol = [nv;npg;nqg;nifd;nbr;ndel]-1;
%  data_ip_temp = [t2in,V,Pg,Qg,del,ifd,Qr];
 numcol = 2; 
t = open('data_ip_temp.mat');
V = t.data_ip_temp(:,2:16);
Pg = t.data_ip_temp(:,17:21);
Qg = t.data_ip_temp(:,22:26);
del = t.data_ip_temp(:,27:41);
ifd = t.data_ip_temp(:,42:46);
Qr =  t.data_ip_temp(:,47:49);
t2in = t.data_ip_temp(:,1);

 [init] = l1_prediction_new(V,Pg,Qg,del,ifd,Qr,t2in,numcol);