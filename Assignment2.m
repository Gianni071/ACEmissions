clc
close all
clear all

%Read data 1
T1 = readtable('IAGOS_timeseries_2019021011295591','Delimiter',' '); 

%Distance is in km
[totaldistance1,nonLTOdistance1] = questionA(T1);

%Read data 2
T2 = readtable('IAGOS_timeseries_2019021011295591','Delimiter',' '); 

%Distance is in km
[totaldistance2,nonLTOdistance2] = questionA(T2);
