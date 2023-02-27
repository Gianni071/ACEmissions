import numpy as np
import matplotlib.pyplot as plt

#Initial values
VMRinit = 10e-12 #-
rho_air = 1 #kg m^-3
Mair = 29 #kg/kmol
NA = 6.02e26 #molec/kmol
Vbox = 10**9 #m3
MN = 14 #kg/kmol
P = 0.004166666666666667 #kgN per hour
L = 0.9834714538 #per hour
a = 1/L
b = a - 1

#Production in molec/cm3/hr
Cprod = P*(10**-15)*(MN**-1)*NA

#Concentration of NOx in molec/cm^3:
Ci = VMRinit*(10**-6)*NA*rho_air*(Mair**-1)

#Calculate concentrations
Carray = [Ci]
for i in range(1,721):
    if i<241:
        Ci = (Ci)/(1+b)
        Carray.append(Ci)
    else:
        Ci = (Ci+Cprod)/(1+b)
        Carray.append(Ci)

Carray = np.array(Carray)
#Convert to kgN per box
Mboxarray = Carray*(10**15)*(1/NA)*MN
t = np.linspace(0,720,721)
t = t/24 #Convert to days

#Plot figure
plt.figure()
plt.plot(t,Mboxarray,"r")
plt.xlabel("Time [days]")
plt.ylabel("$NO_x$ Concentration [kgN/box]")
plt.grid()
plt.show()

