clc
close all
clear all
% function plot_ISSR()

% Gathering Temperatures
% Temp = T(73:end,:).Var16;

% Constants
M_air = 28.97;  % kg/mol
M_H2O = 18;     % kg/mol

% Saturation Pressure coefficients water
a1w = -6.0969385E3;
a2w = 2.12409642E1;
a3w = -2.711193E-2;
a4w = 1.673952E-5;
a7w = 2.433502;

% Saturation Pressure coefficients ice
a1i = -6.0245282E3;
a2i = 2.932707E1;
a3i = 1.061386E-2;
a4i = -1.3198825E-5;
a7i = -4.9382577E-1;

e_sw = [];
e_si = [];

Temps = 210:240;

for Temp = Temps
    e_sw_val = exp(a1w/Temp + a2w + a3w*Temp + a4w*Temp^2 + a7w*log(Temp));
    e_si_val = exp(a1i/Temp + a2i + a3i*Temp + a4i*Temp^2 + a7i*log(Temp));
    e_sw = [e_sw e_sw_val];
    e_si = [e_si e_si_val];
end

plot(Temps-273,e_sw, DisplayName='water')
hold on
plot(Temps-273,e_si, DisplayName='ice')
xlabel('Temperature in [K]')
ylabel('Water vaport pressure [Pa]')
legend


