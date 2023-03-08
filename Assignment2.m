clc
close all
clear all

%Read data 1
T1 = readtable('IAGOS_timeseries_2019021011295591','Delimiter',' '); 
%Distance is in km
[output1] = questionA(T1);
%{
%Read data 2
T2 = readtable('IAGOS_timeseries_2019021102051591','Delimiter',' '); 
%Distance is in km
[output2] = questionA(T2);

%Read data 3
T3 = readtable('IAGOS_timeseries_2019021122212591','Delimiter',' '); 
%Distance is in km
[output3] = questionA(T3);

%Read data 4
T4 = readtable('IAGOS_timeseries_2019021216295591','Delimiter',' '); 
%Distance is in km
[output4] = questionA(T4);

%Read data 5
T5 = readtable('IAGOS_timeseries_2019042914412591','Delimiter',' '); 
%Distance is in km
[output5] = questionA(T5);

%Read data 6
T6 = readtable('IAGOS_timeseries_2019043004153591','Delimiter',' '); 
%Distance is in km
[output6] = questionA(T6);

%Read data 7
T7 = readtable('IAGOS_timeseries_2019043020424591','Delimiter',' '); 
%Distance is in km
[output7] = questionA(T7);

%Read data 8
T8 = readtable('IAGOS_timeseries_2019050116041591','Delimiter',' '); 
%Distance is in km
[output8] = questionA(T8);
%}
