function[totaldistance,nonLTOdistance,TempCond] = questionA(T)


Th = -38+273.15; %Kelvin
len = size(T);
len = len(:,1);
count = 1;


totlist = [];
nonLTOlist = [];
templist = [];

for i = drange(73:len)
   flag1 = T(i,15).Var15;
   if flag1 ~= 0
       count = count + 1;
       continue
   end
   t1 = T(i-count,1).Var1;
   t2 = T(i,1).Var1;
   v1 = T(i-count,14).Var14;
   v2 = T(i,14).Var14;
   count = 1;
   vbar = (v1+v2)/2;
   dt = t2-t1;
   dist = vbar*dt;
   totlist = [totlist dist];
   pres = T(i,10).Var10;
   pres = pres/100;
   if pres <=750
       nonLTOlist = [nonLTOlist dist];
   end
   temp = T(i,16).Var16;
   if temp <= Th
       templist = [templist dist];
   end
end

totaldistance = sum(totlist);
totaldistance = totaldistance/1000;
nonLTOdistance = sum(nonLTOlist);
nonLTOdistance = nonLTOdistance/1000;
tempdistance = sum(templist);
tempdistance = tempdistance/1000;
TempCond = (tempdistance/nonLTOdistance)*100;