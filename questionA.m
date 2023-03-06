function[totaldistance,nonLTOdistance] = questionA(T)

len = size(T);
len = len(:,1);
count = 1;


totlist = [];
nonLTOlist = [];

for i = drange(73:len)
   flag1 = T(i,15).Var15;
   if flag1 ~= 0
       count = count + 1;
       t2 = T(i,1).Var1;
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
end

totaldistance = sum(totlist);
totaldistance = totaldistance/1000;
nonLTOdistance = sum(nonLTOlist);
nonLTOdistance = nonLTOdistance/1000;