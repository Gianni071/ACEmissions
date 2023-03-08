function[output] = questionA(T)
tic
% Constants
Qold = 43.2*10^6; %J/kg
Qnew = 101.0*10^6; %J/kg
EIold = 1.25; %kg/kg
EInew = 9; %kg/kg
etaold = 0.3;
etanew = 0.5;

M_air = 28.97;  % kg/kmol
M_H2O = 18;     % kg/kmol
Cp = 1000; %J/kgK

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
oldlist = [];
newlist = [];
newpersistent = [];
oldpersistent = [];

persistchangeold = [0];
persistchangenew = [0];
oldcount = 0;
newcount = 0;
SACold = 0;
tempold = 0;
rhiold = 0;
SACnew = 0;
tempnew = 0;
rhinew = 0;

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
   
   vbar = (v1+v2)/2;
   dt = t2-t1;
   dist = vbar*dt;
   totlist = [totlist dist];
   % Check pressure altitude
   pres1 = T(i-count,10).Var10;
   pres2 = T(i,10).Var10;
   pres = (pres1+pres2)/2;
   if pres <=75000
       nonLTOlist = [nonLTOlist dist];
   end
   % Check freezing threshold temp
   temp1 = T(i,16).Var16;
   temp2 = T(i-count,16).Var16;
   temp = (temp1+temp2)/2;
   if temp <= Th
       templist = [templist dist];
   end
   % Check rhi
   
   e_si_val = exp(a1i/temp + a2i + a3i*temp + a4i*temp^2 + a7i*log(temp));
   %Check VMR flag
   flag2 = T(i,30).Var30;
   if flag2 == 0
       ppm1 = T(i,28).Var28;
       ppm2 = T(i-count,28).Var28;
       ppm = (ppm1+ppm2)/2;
       paH2O = pres * ppm/(1*10^6);
       rhi = paH2O/e_si_val;
       if rhi >= 1
           ISSRlist = [ISSRlist dist];
       end
       % Compute G
       Gnew = pres*Cp*(M_air/M_H2O)*(EInew/((1-etanew)*Qnew));
       Gold = pres*Cp*(M_air/M_H2O)*(EIold/((1-etaold)*Qold));
       % Compute T_LM
       T_LMnew = -46.46 + 9.43*log(Gnew - 0.053) + 0.720*(log(Gnew-0.053))^2; %Celsius
       T_LMnew = T_LMnew + 273.15; %Kelvin
       T_LMold = -46.46 + 9.43*log(Gold - 0.053) + 0.720*(log(Gold-0.053))^2; %Celsius
       T_LMold = T_LMold + 273.15; %Kelvin
       e_liq_new = exp(a1w/T_LMnew + a2w + a3w*T_LMnew + a4w*T_LMnew^2 + a7w*log(T_LMnew));
       e_liq_old = exp(a1w/T_LMold + a2w + a3w*T_LMold + a4w*T_LMold^2 + a7w*log(T_LMold));
       leftside_old = paH2O + Gold*(T_LMold - temp);
       if leftside_old > e_liq_old
           oldlist = [oldlist dist];
       end
       leftside_new = paH2O + Gnew*(T_LMnew - temp);
       if leftside_new > e_liq_new
           newlist = [newlist dist];
       end
       %New airplane
       if leftside_new > e_liq_new && rhi >= 1 && temp <= Th
            newpersistent = [newpersistent dist];
            persistchangenew = [persistchangenew 1];
       else 
            persistchangenew = [persistchangenew 0];
       end
       if persistchangenew(end) == 0 && persistchangenew(end-1) == 1
           newcount = newcount + 1;
           if leftside_new <= e_liq_new
               SACnew = SACnew + 1;
           end
           if rhi < 1
               rhinew = rhinew + 1;
           end
           if temp > Th
               tempnew = tempnew + 1;
           end
       end
       
       if leftside_old > e_liq_old && rhi >= 1 && temp <= Th
            oldpersistent = [oldpersistent dist];
            persistchangeold = [persistchangeold 1];
       else 
            persistchangeold = [persistchangeold 0];
       end
       if persistchangeold(end) == 0 && persistchangeold(end-1) == 1
           oldcount = oldcount + 1;
           if leftside_old <= e_liq_old
               SACold = SACold + 1;
           end
           if rhi < 1
               rhiold = rhiold + 1;
           end
           if temp > Th
               tempold = tempold + 1;
           end
       end
   end
   count = 1;
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
newlist = sum(newlist)/1000;
newperc = (newlist/nonLTOdistance)*100;
oldlist = sum(oldlist)/1000;
oldperc = (oldlist/nonLTOdistance)*100;
oldpersistent = sum(oldpersistent)/1000;
oldpersistent = (oldpersistent/nonLTOdistance)*100;
newpersistent = sum(newpersistent)/1000;
newpersistent = (newpersistent/nonLTOdistance)*100;

%Output Array
output = [totaldistance nonLTOdistance ISSRCond TempCond oldperc newperc oldpersistent newpersistent oldcount newcount rhiold rhinew tempold tempnew SACold SACnew];
toc