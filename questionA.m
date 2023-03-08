function[output] = questionA(T)
tic
% Molar Masses
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

% Particle Freezing Temp
Th = -38+273.15; %Kelvin

% For loop to analyse datasets
len = size(T);
len = len(:,1);
count = 1;
totlist = [];
nonLTOlist = [];
templist = [];
ISSRlist = [];

for i = drange(73:len)
   % Check Measurement Flag
   flag1 = T(i,15).Var15;
   if flag1 ~= 0
       count = count + 1;
       continue
   end
   % Compute distance travelled between measurement points
   t1 = T(i-count,1).Var1;
   t2 = T(i,1).Var1;
   v1 = T(i-count,14).Var14;
   v2 = T(i,14).Var14;
   count = 1;
   vbar = (v1+v2)/2;
   dt = t2-t1;
   dist = vbar*dt;
   totlist = [totlist dist];
   % Check pressure altitude
   pres = T(i,10).Var10;
   if pres <=75000
       nonLTOlist = [nonLTOlist dist];
   end
   % Check freezing threshold temp
   temp = T(i,16).Var16;
   if temp <= Th
       templist = [templist dist];
   end
   % Check rhi
   e_si_val = exp(a1i/temp + a2i + a3i*temp + a4i*temp^2 + a7i*log(temp));
   %Check VMR flag
   flag2 = T(i,30).Var30;
   if flag2 == 0
       paH2O = pres * T(i,28).Var28/(1*10^6);
       rhi = paH2O/e_si_val;
       if rhi >= 1
           ISSRlist = [ISSRlist dist];
       end
   end
end

%Convert Data
totaldistance = sum(totlist);
totaldistance = totaldistance/1000;
nonLTOdistance = sum(nonLTOlist);
nonLTOdistance = nonLTOdistance/1000;
tempdistance = sum(templist);
tempdistance = tempdistance/1000;
TempCond = (tempdistance/nonLTOdistance)*100;
ISSRlist = sum(ISSRlist);
ISSRlist = ISSRlist/1000;
ISSRCond = (ISSRlist/nonLTOdistance)*100;


%Output Array
output = [totaldistance nonLTOdistance TempCond ISSRCond];
toc